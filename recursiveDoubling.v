`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:48:37 11/01/2020 
// Design Name: 
// Module Name:    recursiveDoubling 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module recursiveDoubling(
    input [63:0] A,
    input [63:0] B,
    output [63:0] S,
    output C
    );
	 
	wire [127:0] kgp;
	wire [127:0] temp1;
	wire [127:0] temp2;
	wire [127:0] temp3;
	wire [127:0] temp4;
	wire [127:0] temp5;
	wire [127:0] temp6;
	
	wire[63:0] cin;
	
	genvar i;
	
	generate
	for(i = 0; i < 64; i = i + 1)
	begin: for_loop
		assign kgp[2 * i] = A[i];
		assign kgp[2 * i + 1] = B[i];
	end
	endgenerate
	
	parallelPrefix PPC0(kgp[1:0], 2'b00, temp1[1:0]);
	parallelPrefix PPC1[62:0](kgp[127:2], temp1[125:0], temp1[127:2]);

	parallelPrefix PPC2[1:0](temp1[3:0], 4'b00, temp2[3:0]);
	parallelPrefix PPC3[61:0](temp1[127:4], temp2[125:2], temp2[127:4]);

	parallelPrefix PPC5[3:0](temp2[7:0], 8'b00, temp3[7:0]);
	parallelPrefix PPC6[59:0](temp2[127:8], temp3[125:6], temp3[127:8]);

	parallelPrefix PPC7[7:0](temp3[15:0], 16'b00, temp4[15:0]);
	parallelPrefix PPC8[55:0](temp3[127:16], temp4[125:14], temp4[127:16]);

	parallelPrefix PPC9[15:0](temp4[31:0], 32'b00, temp5[31:0]);
	parallelPrefix PPC10[47:0](temp4[127:32], temp5[125:30], temp5[127:32]);

	parallelPrefix PPC11[31:0](temp5[63:0], 64'b00, temp6[63:0]);
	parallelPrefix PPC12[31:0](temp5[127:64], temp6[125:62], temp6[127:64]);

	for(i = 0; i < 64; i = i + 1)
	begin: cin_loop
		assign cin[i] = temp6[2 * i + 1];
	end
	
	assign S[0] = A[0] ^ B[0];
    
	for(i = 1; i < 64; i = i + 1)
	begin: s_loop
		assign S[i] = A[i] ^ B[i] ^ cin[i - 1];
	end
	
	assign C = cin[63];
	 
endmodule

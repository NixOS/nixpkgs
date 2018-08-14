/*
 * Copyright CANON INC. 2003
 * Endian independent buffer access library.
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 *  OTHER DEALINGS IN THE SOFTWARE.
 */

#ifndef _buftool_
#define _buftool_


#define	BUFTOOL_LITTLE_ENDIAN	0
#define	BUFTOOL_BIG_ENDIAN		1


typedef struct buf_tool_s
{
	unsigned char *data;
	int bytes;
	unsigned char arch;
	unsigned char swap;
	int pos;
} BufTool;

BufTool *buftool_new(int max_buf_size, int big_endian);
void buftool_destroy(BufTool *buf_tool);
unsigned char *buftool_data(BufTool *buf_tool);
int buftool_pos(BufTool *buf_tool);
int buftool_set_pos(BufTool *buf_tool, int pos);
int buftool_size(BufTool *buf_tool);

int buftool_write_byte(BufTool *buf_tool, char data);
int buftool_write_short(BufTool *buf_tool, short data);
int buftool_write_long(BufTool *buf_tool, long data);
int buftool_write(BufTool *buf_tool, char *data, int bytes);

int buftool_read_byte(BufTool *buf_tool, char *data);
int buftool_read_short(BufTool *buf_tool, short *data);
int buftool_read_long(BufTool *buf_tool, long *data);
int buftool_read(BufTool *buf_tool, char *data, int bytes);

#endif


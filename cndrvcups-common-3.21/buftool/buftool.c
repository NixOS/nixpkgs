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

#include <stdlib.h>
#include <unistd.h>
#include <string.h>


#include "buftool.h"


BufTool *buftool_new(int max_buf_size, int big_endian)
{
	BufTool* buf_tool = (BufTool*)malloc(sizeof(BufTool));
	unsigned char *p_data = (unsigned char *)calloc(max_buf_size, 1);

	if( buf_tool != NULL && p_data != NULL )
	{
		unsigned char bytes[2];
		short *p_short = (short*)bytes;
		*p_short = 1;

		buf_tool->data = p_data;
		buf_tool->bytes = max_buf_size;
		buf_tool->arch = bytes[1];
		buf_tool->swap = (bytes[1] == big_endian)? 0 : 1;
		buf_tool->pos = 0;

		return buf_tool;
	}

	if( p_data )
		free(p_data);
	if( buf_tool )
		free(buf_tool);

	return NULL;
}

void buftool_destroy(BufTool *buf_tool)
{
	if( buf_tool != NULL )
	{
		if( buf_tool->data != NULL )
			free(buf_tool->data);

		free(buf_tool);
	}
}

unsigned char *buftool_data(BufTool *buf_tool)
{
	if( buf_tool != NULL )
		return buf_tool->data;
	else
		return NULL;
}

int buftool_pos(BufTool *buf_tool)
{
	if( buf_tool != NULL )
		return buf_tool->pos;
	else
		return -1;
}

int buftool_set_pos(BufTool *buf_tool, int pos)
{
	if( buf_tool != NULL )
		return buf_tool->pos = pos;
	else
		return -1;
}

int buftool_size(BufTool *buf_tool)
{
	if( buf_tool != NULL )
		return buf_tool->bytes;
	else
		return -1;
}

int buftool_write_byte(BufTool *buf_tool, char data)
{
	if( buf_tool->pos <= buf_tool->bytes - 1 )
	{
		buf_tool->data[buf_tool->pos++] = (unsigned char)data;
		return 1;
	}
	else
		return -1;
}

int buftool_write_short(BufTool *buf_tool, short data)
{
	if( buf_tool->pos <= buf_tool->bytes - 2 )
	{
		unsigned char *p_byte = (unsigned char*)&data;

		if( buf_tool->swap )
		{
			buf_tool->data[buf_tool->pos++] = p_byte[1];
			buf_tool->data[buf_tool->pos++] = p_byte[0];
		}
		else
		{
			buf_tool->data[buf_tool->pos++] = p_byte[0];
			buf_tool->data[buf_tool->pos++] = p_byte[1];
		}
		return 2;
	}
	else
		return -1;
}

int buftool_write_long(BufTool *buf_tool, long data)
{
	if( buf_tool->pos <= buf_tool->bytes - 4 )
	{
		unsigned char *p_byte = (unsigned char*)&data;

		if( buf_tool->arch && sizeof(data) == 8 )
			p_byte += 4;

		if( buf_tool->swap )
		{
			p_byte += 3;
			buf_tool->data[buf_tool->pos++] = *p_byte--;
			buf_tool->data[buf_tool->pos++] = *p_byte--;
			buf_tool->data[buf_tool->pos++] = *p_byte--;
			buf_tool->data[buf_tool->pos++] = *p_byte;
		}
		else
		{
			buf_tool->data[buf_tool->pos++] = *p_byte++;
			buf_tool->data[buf_tool->pos++] = *p_byte++;
			buf_tool->data[buf_tool->pos++] = *p_byte++;
			buf_tool->data[buf_tool->pos++] = *p_byte;
		}
		return 4;
	}
	else
		return -1;
}

int buftool_write(BufTool *buf_tool, char *data, int bytes)
{
	if( buf_tool->pos <= buf_tool->bytes - bytes )
	{
		memcpy(buf_tool->data + buf_tool->pos, data, bytes);
		buf_tool->pos += bytes;

		return bytes;
	}
	else
		return -1;
}

int buftool_read_byte(BufTool *buf_tool, char *data)
{
	if( buf_tool->pos < buf_tool->bytes )
	{
		*data = buf_tool->data[buf_tool->pos++];
		return 1;
	}
	else
		return -1;
}

int buftool_read_short(BufTool *buf_tool, short *data)
{
	if( buf_tool->pos < buf_tool->bytes - 1 )
	{
		unsigned char *p_byte = (unsigned char*)data;
		*data = 0;

		if( buf_tool->swap )
		{
			p_byte[1] = buf_tool->data[buf_tool->pos++];
			p_byte[0] = buf_tool->data[buf_tool->pos++];
		}
		else
		{
			p_byte[0] = buf_tool->data[buf_tool->pos++];
			p_byte[1] = buf_tool->data[buf_tool->pos++];
		}
		return 2;
	}
	else
		return -1;
}

int buftool_read_long(BufTool *buf_tool, long *data)
{
	if( buf_tool->pos < buf_tool->bytes - 3 )
	{
		unsigned char *p_byte = (unsigned char*)data;
		*data = 0;

		if( buf_tool->arch && sizeof(data) == 8 )
			p_byte += 4;

		if( buf_tool->swap )
		{
			p_byte += 3;
			*p_byte-- = buf_tool->data[buf_tool->pos++];
			*p_byte-- = buf_tool->data[buf_tool->pos++];
			*p_byte-- = buf_tool->data[buf_tool->pos++];
			*p_byte   = buf_tool->data[buf_tool->pos++];
		}
		else
		{
			*p_byte++ = buf_tool->data[buf_tool->pos++];
			*p_byte++ = buf_tool->data[buf_tool->pos++];
			*p_byte++ = buf_tool->data[buf_tool->pos++];
			*p_byte   = buf_tool->data[buf_tool->pos++];
		}
		return 4;
	}
	else
		return -1;
}

int buftool_read(BufTool *buf_tool, char *data, int bytes)
{
	if( buf_tool->pos <= buf_tool->bytes - bytes )
	{
		memcpy(data, buf_tool->data + buf_tool->pos, bytes);
		buf_tool->pos += bytes;

		return bytes;
	}
	else
		return -1;
}


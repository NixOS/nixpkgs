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


#include "buflist.h"


BufList *buflist_new(unsigned char *buf, int size)
{
	BufList *buf_list = (BufList*)malloc(sizeof(BufList));

	if( buf_list != NULL )
	{
		if( buf != NULL && size != 0 )
		{
			unsigned char *p_data = (unsigned char*)malloc(size);

			if( p_data != NULL )
			{
				memcpy(p_data, buf, size);
				buf_list->next = NULL;
				buf_list->data = p_data;
				buf_list->size = size;

				return buf_list;
			}
		}
		else
		{
			buf_list->next = NULL;
			buf_list->data = NULL;
			buf_list->size = 0;

			return buf_list;
		}

		if( buf_list )
			free(buf_list);
	}

	return NULL;
}

void buflist_destroy(BufList *buf_list)
{
	BufList *p_list = buf_list;
	BufList *p_next;

	if( p_list != NULL )
	{
		do
		{
			p_next = p_list->next;

			if( p_list->data != NULL )
				free(p_list->data);

			free(p_list);
		}
		while( (p_list = p_next) != NULL );
	}
}

unsigned char *buflist_data(BufList *buf_list)
{
	if( buf_list != NULL )
		return buf_list->data;
	else
		return NULL;
}

int buflist_size(BufList *buf_list)
{
	if( buf_list != NULL )
		return buf_list->size;
	else
		return -1;
}

BufList *buflist_tail(BufList *buf_list)
{
	BufList *p_list = buf_list;

	while( p_list != NULL )
	{
		if( p_list->next == NULL )
			break;

		p_list = p_list->next;
	}

	return p_list;
}

BufList *buflist_add_tail(BufList *buf_list, BufList *buf_tail)
{
	BufList *p_list = buflist_tail(buf_list);

	if( p_list != NULL )
		p_list->next = buf_tail;

	return buf_list;
}

BufList *buflist_dup(BufList *buf_list)
{
	BufList *p_list = buf_list;
	BufList *p_new_list = NULL;

	while( p_list != NULL )
	{
		BufList *p_new
			= buflist_new(buflist_data(p_list), buflist_size(p_list));

		if( p_new_list == NULL )
			p_new_list = p_new;
		else
			p_new_list = buflist_add_tail(p_new_list, p_new);

		p_list = p_list->next;
	}

	return p_new_list;
}

int buflist_write(BufList* buf_list, int fd)
{
	BufList *p_list = buf_list;
	int write_bytes = 0;

	while( p_list != NULL )
	{
		if( p_list->data != NULL )
		{
			int bytes = write(fd, p_list->data, p_list->size);

			if( bytes >= 0 )
				write_bytes += bytes;
			else return bytes;
		}
		p_list = p_list->next;
	}

	return write_bytes;
}


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

#ifndef _buflist_
#define _buflist_


typedef struct buf_list_s
{
	struct buf_list_s *next;
	unsigned char *data;
	int size;
} BufList;

BufList *buflist_new(unsigned char *buf, int size);
BufList *buflist_dup(BufList *buf_list);
void buflist_destroy(BufList *buf_list);

unsigned char *buflist_data(BufList* buf_list);
int buflist_size(BufList* buf_list);
BufList *buflist_tail(BufList* buf_list);
BufList *buflist_add_tail(BufList *buf_list, BufList *buf_tail);
BufList *buflist_dup(BufList *buf_list);

int buflist_write(BufList* buf_list, int fd);

#endif


/*
 *  Status monitor for Canon CAPT Printer.
 *  Copyright CANON INC. 2004
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



#ifndef	_CNSKTMODULE_
#define	_CNSKTMODULE_

#include "cnsktdef.h"
#include "buftool.h"

#define MAX_BUFF_SIZE	2048
#define RESPONSE_HEADER_SIZE	12

#define USER_MODE_FLAGS_CERR	(1 << 6)
#define USER_MODE_FLAGS_CNOERR	(1 << 5)
#define USER_MODE_FLAGS_FLICKER (1 << 2)
#define USER_MODE_FLAGS_GRAPHIC (1 << 1)
#define USER_MODE_FLAGS_DUPLEX  (1 << 0)
#define PRINTER_FLAGS_SB_DUPLEX (1 << 5)
#define	PRINTER_FLAGS_SB_NIC	(1 << 7)

typedef struct{
	int socket_fd;

	char req_header[4];
	long req_command;
	char *printer;
	int size_printer;
	char *locale;
	int size_locale;

	short response_code;
	short status_code;
	long total_length;

	BufTool *send_data;
	BufTool *recv_data;
}CnsktModule;

CnsktModule* cnsktNew(char *printer, char *locale, char *folder_path, int port_num);
void cnsktDestroy(CnsktModule *pCnskt);
int cnsktWrite(CnsktModule *pCnskt, long command);
int cnsktRead(CnsktModule *pCnskt);
int cnsktSetReqByte(CnsktModule *pCnskt, char ch);
int cnsktSetReqShort(CnsktModule *pCnskt, short st);
int cnsktSetReqLong(CnsktModule *pCnskt, long lg);
int cnsktSetReqData(CnsktModule *pCnskt, void *pData, int nSize);
int cnsktGetSocketFD(CnsktModule *pCnskt);
int cnsktGetReqCommand(CnsktModule *pCnskt);
short cnsktGetResCode(CnsktModule *pCnskt);
unsigned short cnsktGetStatusCode(CnsktModule *pCnskt);
char* cnsktGetStatusData(CnsktModule *pCnskt);
int cnsktGetStatusLen(CnsktModule *pCnskt);
int cnsktGetResSize(CnsktModule *pCnskt);
int cnsktGetResData(CnsktModule *pCnskt, void *pData, int nType, int nSize);
int cnsktSeekResData(CnsktModule *pCnskt, int nOffset);
#ifdef _CNSKT_LCAPT
int cnsktResetReqData(CnsktModule *pCnskt);
#endif
#endif

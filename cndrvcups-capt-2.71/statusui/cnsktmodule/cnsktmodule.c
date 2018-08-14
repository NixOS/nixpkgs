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


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netdb.h>
#include <unistd.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <ctype.h>

#include <errno.h>

#include "cnsktmodule.h"

#define HOST_NAME 		"localhost"
#define	LONGDATA_SIZE	4

#define SEND_BUFSIZE	512
#define	RETRY_NUMBER	10

static char* ChkPrinterName(char *printer_name);
static int ConnectSocket(char *host_name, int port);

#ifdef __APPLE__
#define	CCPD_FOLDER_NAME "CCPD"
#define	PROG_NAME "ccpd"
static int StartProcessCCPD(char *folder_path);
#endif

CnsktModule* cnsktNew(char *printer, char *locale, char *folder_path, int port_num)
{
	CnsktModule *pCnskt = NULL;
	char *host_name;
	int socket_fd;
	int i;

	pCnskt = (CnsktModule *)malloc(sizeof(CnsktModule));
	if(pCnskt == NULL){
		return NULL;
	}

	memset(pCnskt, 0, sizeof(CnsktModule));

	host_name = ChkPrinterName(printer);

	for(i = 0; i < RETRY_NUMBER; i++){
		if((socket_fd = ConnectSocket(host_name, port_num)) != -1)
			break;
		usleep(10000);
	}

	if(i == RETRY_NUMBER){
#ifdef	__APPLE__
		int j;
		if(StartProcessCCPD(folder_path)){
			goto err;
		}else{
			for(j = -40; j < RETRY_NUMBER; j++){
				if((socket_fd = ConnectSocket(host_name, port_num)) != -1)
					break;
				usleep(100000);
			}
		}
		if(j == RETRY_NUMBER)
			goto err;
#else
		goto err;
#endif
	}

	memcpy(pCnskt->req_header, HEADER_REQ_STR, strlen(HEADER_REQ_STR));
	pCnskt->socket_fd = socket_fd;
	pCnskt->printer = strdup(printer);
	pCnskt->locale = strdup(locale);

	pCnskt->size_printer = strlen(pCnskt->printer);
	pCnskt->size_locale = strlen(pCnskt->locale);
	free(host_name);

	pCnskt->send_data = buftool_new(SEND_BUFSIZE, BUFTOOL_LITTLE_ENDIAN);

	return pCnskt;

err:
	free(pCnskt);
	free(host_name);
	return NULL;
}

void cnsktDestroy(CnsktModule *pCnskt)
{
	if (pCnskt->printer != NULL)	{ free(pCnskt->printer);    pCnskt->printer = NULL; }
 	if (pCnskt->locale != NULL)		{ free(pCnskt->locale);     pCnskt->locale = NULL;  }
	if (pCnskt->socket_fd != -1)	{ close(pCnskt->socket_fd); pCnskt->socket_fd = -1; }
	buftool_destroy(pCnskt->send_data);
	buftool_destroy(pCnskt->recv_data);
	if (pCnskt != NULL)				{ free(pCnskt); pCnskt = NULL; }
}

static char* ChkPrinterName(char *printer_name)
{
	char *ptr = NULL;
	char *host_name = NULL;

	if((ptr = strchr(printer_name, '@')) != NULL){
		ptr++;
		host_name = strdup(ptr);
		host_name[strlen(host_name)] = '\0';
		ptr--;
		*ptr = '\0';
	}
	return host_name;
}


static int GetPortNum(int port)
{
	char *port_str = NULL;
	int port_num = port;

	port_str = getenv("CCPD_PORT");
	if(port_str != NULL){
		if(isdigit(*port_str))
			port_num = atoi(port_str);
	}

	return port_num;
}

static int ConnectSocket(char *host_name, int port)
{
	int fd;
	struct sockaddr_in addr;
	struct hostent *host;

	if(host_name == NULL){
		host = gethostbyname(HOST_NAME);
	}else{
		host = gethostbyname(host_name);
	}

	if(!host){
		return -1;
	}

	if((fd = socket(AF_INET, SOCK_STREAM, 0)) >= 0){
		addr.sin_family = AF_INET;
		addr.sin_port = htons(GetPortNum(port));
		addr.sin_addr.s_addr = inet_addr(inet_ntoa(*(struct in_addr *)*host->h_addr_list));
		if(connect(fd, (struct sockaddr *)&addr, sizeof(addr)) == -1){
			close(fd);
			fd = -1;
		}
	}
	return fd;
}

static int socket_write(int fd, char *data, int write_size)
{
	int size = write_size;
	int tmp_size = 0;

	while(size){
		data += tmp_size;
		tmp_size = write(fd, data, size);

		if(tmp_size == -1)
			return -1;
		size -= tmp_size;
	}
	return 0;
}

int cnsktWrite(CnsktModule *pCnskt, long command)
{
	BufTool *buftool;
	long total_size, size = 0;
	int ret = 0;
	buftool = buftool_new(MAX_BUFF_SIZE, BUFTOOL_LITTLE_ENDIAN);

	if(buftool){
		pCnskt->req_command = (long)command;
		total_size = pCnskt->size_printer
			+ pCnskt->size_locale + (LONGDATA_SIZE * 2);

		switch(pCnskt->req_command){
		case CCPD_REQ_STATUS:
#ifdef _CNSKT_LCAPT
			total_size += LONGDATA_SIZE;
#endif
			break;
		default:
			if((size = buftool_pos(pCnskt->send_data)) != 0)
				total_size += size;
			break;
		}

		buftool_write(buftool, pCnskt->req_header, LONGDATA_SIZE);
		buftool_write_long(buftool, pCnskt->req_command);
		buftool_write_long(buftool, total_size);
		buftool_write_long(buftool, pCnskt->size_printer);
		buftool_write(buftool, pCnskt->printer, pCnskt->size_printer);
		buftool_write_long(buftool, pCnskt->size_locale);
		buftool_write(buftool, pCnskt->locale, pCnskt->size_locale);

		switch(pCnskt->req_command){
		case CCPD_REQ_STATUS:
#ifdef _CNSKT_LCAPT
			buftool_write_long(buftool, 0);
#endif
			break;
		default:
			if((size = buftool_pos(pCnskt->send_data)) != 0){
				buftool_write(buftool,
					(char *)buftool_data(pCnskt->send_data),
					size);
			}
			break;
		}

		if(socket_write(pCnskt->socket_fd,
				(char *)buftool_data(buftool),
				buftool_pos(buftool)) < 0){
			ret = -1;
		}
		buftool_destroy(buftool);
	}else{
		ret = -1;
	}

	buftool_set_pos(pCnskt->send_data, 0);

	return ret;
}

int socket_read(int fd, char *data, int read_size)
{
	int size = read_size;
	int tmp_size = 0;
	int cnt = 0;

	while(size){
		data += tmp_size;
		tmp_size = read(fd, data, size);

		if(tmp_size == -1){
			return -1;
		}
		if(tmp_size == 0){
			if(cnt == 10)
				return -1;
			cnt++;
		}
		size -= tmp_size;
	}
	return 0;
}

int cnsktRead(CnsktModule *pCnskt)
{
	BufTool *buftool;
	char header[4];
	buftool = buftool_new(RESPONSE_HEADER_SIZE, BUFTOOL_LITTLE_ENDIAN);

	if(buftool){
		buftool_set_pos(buftool, 0);

		if(socket_read(pCnskt->socket_fd,
				(char *)buftool_data(buftool),
				RESPONSE_HEADER_SIZE) < 0){
			buftool_destroy(buftool);
			return -1;
		}

		buftool_read(buftool, header, LONGDATA_SIZE);
		buftool_read_short(buftool, &pCnskt->response_code);
		buftool_read_short(buftool, &pCnskt->status_code);
		buftool_read_long(buftool, &pCnskt->total_length);

		buftool_destroy(buftool);
	}

	if(pCnskt->recv_data){
		buftool_destroy(pCnskt->recv_data);
		pCnskt->recv_data = NULL;
	}

	if(pCnskt->total_length > 0){
		pCnskt->recv_data = buftool_new(pCnskt->total_length + 1, BUFTOOL_LITTLE_ENDIAN);
		if(pCnskt->recv_data){
			buftool_set_pos(pCnskt->recv_data, 0);
			if(socket_read(pCnskt->socket_fd,
					(char *)buftool_data(pCnskt->recv_data),
					pCnskt->total_length) < 0){
				buftool_destroy(pCnskt->recv_data);
				pCnskt->recv_data = NULL;
				return -1;
			}
			switch(pCnskt->req_command){
			case CCPD_REQ_STATUS:
				break;
			default:
				break;
			}

			return pCnskt->total_length;
		}
	}

	return 0;
}

int cnsktSetReqByte(CnsktModule *pCnskt, char ch)
{
	int pos = buftool_pos(pCnskt->send_data);
	if(pos + 1 > SEND_BUFSIZE)
		return -1;
	buftool_write_byte(pCnskt->send_data, ch);
	return 0;
}

int cnsktSetReqShort(CnsktModule *pCnskt, short st)
{
	int pos = buftool_pos(pCnskt->send_data);
	if(pos + 2 > SEND_BUFSIZE)
		return -1;
	buftool_write_short(pCnskt->send_data, st);
	return 0;
}

int cnsktSetReqLong(CnsktModule *pCnskt, long lg)
{
	int pos = buftool_pos(pCnskt->send_data);
	if(pos + 4 > SEND_BUFSIZE)
		return -1;
	buftool_write_long(pCnskt->send_data, lg);
	return 0;
}


int cnsktSetReqData(CnsktModule *pCnskt, void *pData, int nSize)
{
	int pos = buftool_pos(pCnskt->send_data);

	if(pos + nSize > SEND_BUFSIZE)
		return -1;
	buftool_write(pCnskt->send_data, pData, nSize);

	return 0;
}

int cnsktGetResSize(CnsktModule *pCnskt)
{
	if(pCnskt->recv_data == NULL)
		return -1;

	return pCnskt->total_length;
}

int cnsktGetResData(CnsktModule *pCnskt, void *pData, int nType, int nSize)
{
	if(pCnskt->recv_data == NULL)
		return -1;

	if(buftool_pos(pCnskt->recv_data) >= pCnskt->total_length)
		return -1;

	switch(nType){
	case READ_TYPE_BYTE:
		buftool_read_byte(pCnskt->recv_data, pData);
		break;
	case READ_TYPE_SHORT:
		buftool_read_short(pCnskt->recv_data, pData);
		break;
	case READ_TYPE_LONG:
		buftool_read_long(pCnskt->recv_data, pData);
		break;
	case READ_TYPE_ARRAY:
		buftool_read(pCnskt->recv_data, pData, nSize);
		break;
	case READ_TYPE_ALL:
		buftool_read(pCnskt->recv_data, pData, pCnskt->total_length);
		break;
	}

	return 0;
}

int cnsktSeekResData(CnsktModule *pCnskt, int nOffset)
{
	int pos;

	if(pCnskt->recv_data == NULL)
		return -1;

	if((pos = buftool_pos(pCnskt->recv_data)) >= pCnskt->total_length)
		return -1;

	if(nOffset >= pCnskt->total_length)
		return -1;

	buftool_set_pos(pCnskt->recv_data, nOffset);
	return 0;
}


int cnsktGetSocketFD(CnsktModule *pCnskt)
{
	return pCnskt->socket_fd;
}

int cnsktGetReqCommand(CnsktModule *pCnskt)
{
	return pCnskt->req_command;
}

short cnsktGetResCode(CnsktModule *pCnskt)
{
	return pCnskt->response_code;
}

unsigned short cnsktGetStatusCode(CnsktModule *pCnskt)
{
	return pCnskt->status_code;
}

char* cnsktGetStatusData(CnsktModule *pCnskt)
{
	return (char *)buftool_data(pCnskt->recv_data);
}

int cnsktGetStatusLen(CnsktModule *pCnskt)
{
	return pCnskt->total_length;
}

#ifdef _CNSKT_LCAPT
int cnsktResetReqData(CnsktModule *pCnskt)
{
	return buftool_set_pos(pCnskt->send_data, 0);
}
#endif

#ifdef __APPLE__
static int StartProcessCCPD(char *folder_path)
{
	int pid = 0;
	char *param_list[2];
	char path[256];

	if(folder_path == NULL)
		return 1;

	memset(path, 0, 255);
	strncpy(path, folder_path, 255);
	strncat(path, "/", 255 - strlen(path));
	strncat(path, CCPD_FOLDER_NAME, 255 - strlen(path));
	strncat(path, "/", 255 - strlen(path));
	strncat(path, PROG_NAME, 255 - strlen(path));
	param_list[0] = strdup(path);
	param_list[1] = NULL;

	if((pid = fork()) != -1){
		if(pid == 0){
			if( -1 == execv(path, param_list) ){
				exit(EXIT_FAILURE);
			}
		}else{
			return 0;
		}
	}
	return 1;
}
#endif

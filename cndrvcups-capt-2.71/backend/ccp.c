/*
 *  CUPS backend for a named pipe.
 *  Copyright CANON INC. 2004
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

//
//  '2004.05.25
//  Using the original "usb.c" code of the CUPS 1.1.14 to create a new
//  backend for writing the printing data into a named pipe.
//

/*
 * "$Id: ccp.c,v 1.2 2010/11/10 01:22:35 207046 Exp $"
 *
 *   USB port backend for the Common UNIX Printing System (CUPS).
 *
 *   Copyright 1997-2002 by Easy Software Products, all rights reserved.
 *
 *   These coded instructions, statements, and computer programs are the
 *   property of Easy Software Products and are protected by Federal
 *   copyright law.  Distribution and use rights are outlined in the file
 *   "LICENSE" which should have been included with this file.  If this
 *   file is missing or damaged please contact Easy Software Products
 *   at:
 *
 *       Attn: CUPS Licensing Information
 *       Easy Software Products
 *       44141 Airport View Drive, Suite 204
 *       Hollywood, Maryland 20636-3111 USA
 *
 *       Voice: (301) 373-9603
 *       EMail: cups-info@cups.org
 *         WWW: http://www.cups.org
 *
 * Contents:
 *
 *   main()         - Send a file to the specified USB port.
 *   list_devices() - List all USB devices.
 */




#include <cups/cups.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>

#include <unistd.h>
#include <fcntl.h>
#include <limits.h>

#include "buftool.h"


#define	CPRTD_BACKEND_NAME	"ccp"

#define	kCCPD_DataPort_Number	59687
#define	DATA_BUF_SIZE		(PIPE_BUF)

#define HOST_NAME 				"localhost"

#define HEADER_SIGN_LENGTH			4
#define HEADER_SIGN_INFO			"CCP2"
#define HEADER_SIGN_RETURN			"CCP3"
#define RETURN_CODE_SIZE			8
#define RETURN_CODE_TRUE			1
#define RETURN_CODE_FALSE			0
#define RETURN_CODE_ERR_PARAMERR	-1
#define RETURN_CODE_ERR_NOQUEUE	-2
#define RETURN_CODE_ERR_BUSY		-3
#define RETURN_CODE_ERR_NOTHREAD	-4

#define CONNECT_RETRY_INTERVAL		100000
#define CONNECT_RETRY_NUMBER		600
#define SENDINFO_RETRY_INTERVAL	500000

int	g_canceled = 0;

FILE *g_log_fp;


void list_devices(void)
{
#if 0
	char device[256];
	int i;

	for( i = 0 ; i < CPRTD_MAX_FIFO ; i++ )
	{
		sprintf(device, CPRTD_FIFO_PATH, i);
		if( !access(device, 0) )
		{
      		printf(
			"direct %s:%s \"Unknown\" \"Canon Priter Daemon Port#%d\"\n",
			CPRTD_BACKEND_NAME, device, i + 1);
		}
    }
#else
	printf("direct ccp \"Unknown\" \"CAPT Printer\"\n");
#endif
}

#if 0
void make_header(unsigned int job, unsigned int bytes, char buf[8])
{
	buf[0] = job & 0xff;
	buf[1] = (job >> 8)  & 0xff;
	buf[2] = (job >> 16) & 0xff;
	buf[3] = (job >> 24) & 0xff;

	buf[4] = bytes & 0xff;
	buf[5] = (bytes >> 8)  & 0xff;
	buf[6] = (bytes >> 16) & 0xff;
	buf[7] = (bytes >> 24) & 0xff;
}
#else
void make_header(unsigned int job, unsigned int bytes, BufTool *buf_tool)
{
	buftool_set_pos(buf_tool, 0);
	buftool_write_long(buf_tool, (long)job);
	buftool_write_long(buf_tool, (long)bytes);
}
#endif

#if 0
int write_data(int ofd, unsigned char *data, int data_bytes)
{
	int written_bytes = 0;
	int bytes;
	unsigned char *p_data = data;

#ifdef	DEBUG
	{
		int size
			=  (unsigned int)data[4]
			+ ((unsigned int)data[5] << 8)
			+ ((unsigned int)data[6] << 16)
			+ ((unsigned int)data[7] << 24);
		fprintf(g_log_fp, "DEBUG: ccp:wrote %d bytes, size=%d\n",
		data_bytes, size);
	}
#endif

	while( !g_canceled && data_bytes > 0 )
	{
		bytes = write(ofd, p_data, data_bytes);

		if( bytes < 0 )
		{
			if( errno == EINTR )
				continue;

			fprintf(g_log_fp, "ERROR: %s write error,%d\n",
					CPRTD_BACKEND_NAME, errno);

			goto error_exit;
		}
		data_bytes -= bytes;
		written_bytes += bytes;
		p_data += bytes;
	}

	return written_bytes;

error_exit:
	fprintf(g_log_fp, "ERROR: ccp: write_data error, exit\n");
	return -1;
}
#endif

#if 0
int send_data(int ifd, int ofd, int job)
{
	char data_buf[DATA_BUF_SIZE];

	while( !g_canceled )
	{
		int read_bytes = read(ifd, data_buf + 8, DATA_BUF_SIZE - 8);

		if( read_bytes > 0 )
		{
			int write_bytes = read_bytes + 8;

			make_header(job, read_bytes, data_buf);

			if( write_data(ofd, data_buf, write_bytes) < write_bytes )
				goto error_exit;
		}
		else if( read_bytes < 0 )
		{
			if( errno == EINTR )
				continue;
			fprintf(g_log_fp, "ERROR: %s read error,%d\n",
			CPRTD_BACKEND_NAME, errno);
			goto error_exit;
		}
		else
		{
			break;
		}
	}

	make_header(job, 0, data_buf);

	fprintf(g_log_fp, "DEBUG: ccp: last data.\n");

	if( write_data(ofd, data_buf, 8) < 8 )
		goto error_exit;

	fprintf(g_log_fp, "DEBUG: ccp: end of send data.\n");
	return 0;

error_exit:
	fprintf(g_log_fp, "ERROR: ccp: send_data error, exit\n");
	return -1;
}
#endif

int connect_socket(char *host_name, int port)
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
		addr.sin_port = htons(port);
		addr.sin_addr.s_addr = inet_addr(inet_ntoa(*(struct in_addr *)*host->h_addr_list));
		if(connect(fd, (struct sockaddr *)&addr, sizeof(addr)) == -1){
			close(fd);
			fd = -1;
		}
	}
	return fd;
}

int make_queue_info( char *queue_name, BufTool *buf_tool )
{

	buftool_set_pos( buf_tool, 0 );
	buftool_write( buf_tool, HEADER_SIGN_INFO, HEADER_SIGN_LENGTH );
	buftool_write_long( buf_tool, (long)strlen(queue_name) );
	buftool_write( buf_tool, queue_name, (long)strlen(queue_name) );

	return buf_tool->pos;
}

int send_packet( int ofd, unsigned char *data, int data_bytes )
{
	int bytes;
	unsigned char *p_data = data;

	while ( !g_canceled && data_bytes > 0 )
	{
		bytes = write( ofd, p_data, data_bytes );

		if ( bytes < 0 )
		{
			if( ( errno == EINTR ) || ( errno == EAGAIN ) )
				continue;

			fprintf(g_log_fp, "ERROR: %s write error,%d\n",
					CPRTD_BACKEND_NAME, errno);
			goto error_exit;
		}
		data_bytes -= bytes;
		p_data += bytes;

	}

	if ( data_bytes != 0 )
	{
		goto error_exit;
	}

	return 0;

error_exit:
	fprintf(g_log_fp, "ERROR: %s send_packet error, exit\n",
			CPRTD_BACKEND_NAME );
	return -1;
}

int recv_packet( int ofd, unsigned char *data, int data_bytes )
{
	int bytes;
	unsigned char *p_data = data;
	int count = 0;

	while ( !g_canceled && data_bytes > 0 )
	{
		bytes = read( ofd, p_data, data_bytes );

		if ( bytes == -1 )
		{
			if( ( errno == EINTR ) || ( errno == EAGAIN ) )
				continue;
			fprintf(g_log_fp, "ERROR: %s read error,%d\n",
					CPRTD_BACKEND_NAME, errno);
			goto  error_exit;
		}

		if ( bytes == 0 )
		{
			if ( count == 10 )
				goto error_exit;

			count++;
		}

		data_bytes -= bytes;
		p_data += bytes;
	}

	if ( data_bytes != 0 )
	{
		goto error_exit;
	}

	return 0;

error_exit:
	fprintf(g_log_fp, "ERROR: %s recv_packet error, exit\n",
			CPRTD_BACKEND_NAME );
	return -1;

}


int check_return( BufTool *buf_tool, long *return_code )
{
	char header[HEADER_SIGN_LENGTH];

	buftool_set_pos( buf_tool, 0 );
	buftool_read( buf_tool, header, HEADER_SIGN_LENGTH );

	if ( memcmp( header, HEADER_SIGN_RETURN, HEADER_SIGN_LENGTH ) != 0 )
	{
		return -1;
	}

	buftool_read_long( buf_tool, return_code );

	return 0;
}

int send_data(int ifd, int job)
{
	BufTool *buf_tool_w = buftool_new( DATA_BUF_SIZE, BUFTOOL_LITTLE_ENDIAN );
	BufTool *buf_tool_r = buftool_new( RETURN_CODE_SIZE, BUFTOOL_LITTLE_ENDIAN );
	BufTool *buf_tool_info = buftool_new( DATA_BUF_SIZE, BUFTOOL_LITTLE_ENDIAN );
	unsigned char *pBufWrite = NULL;
	unsigned char *pBufRead = NULL;
	unsigned char *pBufInfo = NULL;
	char *queue_name = NULL;
	int write_bytes = 0;
	int read_bytes = 0;
	long ccpd_return;
	int infoAccepted = 0;
	int err = 0;
	int ofd = -1;
	int i = 0;

	if ( ( buf_tool_w == NULL ) || ( buf_tool_r == NULL ) )
		goto error_exit;

	pBufWrite = buftool_data( buf_tool_w );
	pBufRead = buftool_data( buf_tool_r );
	pBufInfo = buftool_data( buf_tool_info );

	queue_name = getenv( "PRINTER" );
	if ( queue_name == NULL ) goto error_exit;

	while( !g_canceled )
	{
		read_bytes = read( ifd, pBufWrite + 8, DATA_BUF_SIZE - 8 );
		if ( read_bytes == 0 )
		{
			goto error_exit;
		}
		else if ( read_bytes < 0 )
		{
			if ( errno != EINTR ){
				goto error_exit;
			}
		}
		else
		{
			break;
		}
	}

	for ( i = 0; (i < CONNECT_RETRY_NUMBER) && !g_canceled ; i++ )
	{
		if ( ( ofd = connect_socket( HOST_NAME, kCCPD_DataPort_Number )) != -1 )
			break;
		usleep( CONNECT_RETRY_INTERVAL );
	}

	if ( g_canceled )
	{
		goto error_exit;
	}

	if ( ofd == -1 )
	{
		perror("ERROR: Can't connect to CCPD");
		goto error_exit;
	}


	write_bytes = make_queue_info( queue_name, buf_tool_info );
	while ( !g_canceled && !infoAccepted )
	{

		err = send_packet( ofd, pBufInfo, write_bytes );

		if ( !err )
		{
			err = recv_packet( ofd, pBufRead, RETURN_CODE_SIZE );
		}

		if ( !err )
		{
			err = check_return( buf_tool_r, &ccpd_return );
		}

		if ( !err )
		{
			switch ( ccpd_return )
			{
				case RETURN_CODE_TRUE:
					infoAccepted = 1;
					break;
				case RETURN_CODE_ERR_BUSY:
					usleep( SENDINFO_RETRY_INTERVAL );
					break;
				case RETURN_CODE_FALSE:
				case RETURN_CODE_ERR_PARAMERR:
				case RETURN_CODE_ERR_NOQUEUE:
				case RETURN_CODE_ERR_NOTHREAD:
				default:
					goto error_exit;
					break;
			}
		}

		if ( err ) goto error_exit;
	}

	while ( !g_canceled )
	{
		if ( read_bytes >= 0 )
		{
			write_bytes = read_bytes + 8;

			make_header( job, read_bytes, buf_tool_w );

			err = send_packet( ofd, pBufWrite, write_bytes );

			if ( !err )
			{
				err = recv_packet( ofd, pBufRead, RETURN_CODE_SIZE );
			}

			if ( !err )
			{
				err = check_return( buf_tool_r, &ccpd_return );
			}

			if ( !err )
			{
				switch ( ccpd_return )
				{
					case RETURN_CODE_TRUE:
						break;
					case RETURN_CODE_ERR_BUSY:
					case RETURN_CODE_FALSE:
					case RETURN_CODE_ERR_PARAMERR:
					case RETURN_CODE_ERR_NOQUEUE:
					case RETURN_CODE_ERR_NOTHREAD:
					default:
						goto error_exit;
						break;
				}
			}

			if ( ( !err ) && ( read_bytes == 0 ) )
			{
				break;
			}
		}
		else
		{
			if ( errno == EINTR )
			{
				read_bytes = read( ifd, pBufWrite + 8, DATA_BUF_SIZE - 8 );
				continue;
			}
			fprintf(g_log_fp, "ERROR: %s read error,%d\n",
					CPRTD_BACKEND_NAME, errno);
			goto error_exit;
		}

		read_bytes = read( ifd, pBufWrite + 8, DATA_BUF_SIZE - 8 );

		if ( err ) goto error_exit;
	}

	buftool_destroy( buf_tool_w );
	buftool_destroy( buf_tool_r );
	buftool_destroy( buf_tool_info );

	close(ofd);

	return 0;

error_exit:

	if ( buf_tool_w != NULL )
		buftool_destroy( buf_tool_w );
	if ( buf_tool_r != NULL )
		buftool_destroy( buf_tool_r );
	if ( buf_tool_info != NULL )
		buftool_destroy( buf_tool_info );

	if( ofd != -1 )
		close(ofd);

	fprintf(g_log_fp, "ERROR: %s send_data error, exit\n",
			CPRTD_BACKEND_NAME);
	return -1;
}


void signal_handler(int sigcode)
{
	g_canceled = 1;
}

int main(int argc, char *argv[])
{
	struct sigaction sigact;
#if 0
	char resource[1024];
	char *options;
#endif
	int job;
	int ifd = 0;
	int ret;

#ifdef DEBUG_SLEEP
	sleep(30);
#endif

	setbuf(stderr, NULL);

#ifdef	DEBUG_LOG
	g_log_fp = fopen("/tmp/cnbma_log.txt", "w");
#else
	g_log_fp = stderr;
#endif

	if( argc == 1 )
	{
		list_devices();
		return 0;
	}
	else if( argc < 6 || argc > 7 )
	{
		fprintf(stderr, "Usage: %s job-id user title copies options [file]\n",
		CPRTD_BACKEND_NAME);
		return 1;
	}

	memset(&sigact, 0, sizeof(sigact));
	sigact.sa_handler = signal_handler;
	if( sigaction(SIGTERM, &sigact, NULL) )
	{
		return 1;
	}

	memset(&sigact, 0, sizeof(sigact));
	sigact.sa_handler = signal_handler;
	if( sigaction(SIGPIPE, &sigact, NULL) )
	{
		return 1;
	}

	if( argc == 7 )
	{
		if( (ifd = open(argv[6], O_RDONLY)) == -1 )
		{
			perror("ERROR: Can't open file");
			return 1;
		}
	}

#if 0
	if( (strncmp(argv[0], "ccp:/var/ccpd", 13) == 0) )
	{
		memset(resource, 0, 1024);
		strncpy(resource, argv[0] + 4, 1023);
	}
	else
	{
		perror("ERORR: Illegal backend");
		return (1);
	}

	if( (options = strchr(resource, '?')) != NULL )
	{
		*options++ = '\0';
	}

	if( (ofd = open(resource, O_WRONLY | O_EXCL)) == -1 )
	{
		perror("ERROR: Can't open FIFO");
		return 1;
	}
#else
	if (strncmp(argv[0], CPRTD_BACKEND_NAME, strlen(CPRTD_BACKEND_NAME)) != 0)
	{
		perror("ERROR: Illegal backend");
		ret = 1;
		goto exit;
	}
#endif
	job = atoi(argv[1]);

	if( send_data(ifd, job) < 0 )
		ret = 1;
	else
		ret = 0;

exit:

	if( ifd != 0 )
		close(ifd);


#ifdef	DEBUG_LOG
	if( g_log_fp != NULL )
		fclose(g_log_fp);
#endif

	return ret;
}


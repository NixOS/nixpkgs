/*
 *  Print Dialog for Canon LIPS/PS/LIPSLX/UFR2 Printer.
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

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <ctype.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <termios.h>

#include <cups/cups.h>

#define ACCOUNT_PATH "/etc/cngplp/account"
#define ACCOUNT_FILE_TYPE_STATUS_READ 1
#define ACCOUNT_FILE_TYPE_STATUS_WRITE 2
#define ACCOUNT_FILE_TYPE_CONF_READ 3
#define ACCOUNT_FILE_TYPE_CONF_WRITE 4

#define ACCOUNT_FILE_STATUS "status"
#define ACCOUNT_FILE_CONF ".conf"

#define ACCOUNT_FILE_STATUS_NEW "status.new"
#define ACCOUNT_FILE_CONF_NEW ".conf.new"

#define MAX_BUFSIZE     512

#define ACCOUNT_STATUS_FORMAT "<%s>%s</%s>\n"
#define ACCOUNT_CONF_FORMAT_START "<%s>\n"
#define ACCOUNT_CONF_FORMAT_ID "id=%s\n"
#define ACCOUNT_CONF_FORMAT_PSWD "password=%s\n"
#define ACCOUNT_CONF_FORMAT_END "</%s>\n"
#define PRINTER_NAME_FORMAT_START "<%s>"
#define PRINTER_NAME_FORMAT_END "</%s>"
#define PRINTER_NAME_FORMAT_STARTEND "<%s>%s</%s>"
#define ACCOUNT_ON "ON"
#define ACCOUNT_OFF "OFF"

static int check_printer_name(char * const printer_name, const char * const t_line, const char * const format);
static int check_account_printer_name(char * const printer_name, char * const t_line);
static int get_account_status(char * const printer_name, char * const t_line);

static int file_write(int fd, char *line, int line_size)
{
	int w_bytes = 0;
	int offset = 0;

	fsync(fd);
	do{
		w_bytes = write(fd, line + offset, line_size - offset);
		if(w_bytes + offset == line_size)
			break;
		offset += w_bytes;
	}while(w_bytes + offset < line_size);
	sync();

	return 0;
}

static int get_line_from_buffer(char **line, char *buff, int offset, int max)
{
	int i;
	char *tmp = buff + offset;
	char *l_tmp = NULL;

	if(*line == NULL){
		l_tmp = (char *)calloc(max + 1, 1);
		if(l_tmp == NULL)
			return -2;
	}else{
		int len = strlen(*line) + max + 1;
		l_tmp = (char *)calloc(len , 1);
		if(l_tmp == NULL)
			return -2;
		strncpy(l_tmp, *line, strlen(*line));
		free(*line);
	}

	for(i = 0; offset + i < max; i++){
		if(*tmp == '\n' || *tmp == '\r' || *tmp == EOF){
			strncat(l_tmp, buff + offset, i);
			*line = l_tmp;
			if( *(tmp + 1) == '\n' || *(tmp + 1) == '\r' || *tmp == EOF)
				i++;
			return (i + 1);
		}
		tmp++;
	}

	strncat(l_tmp, buff + offset, max);
	*line = l_tmp;

	return -1;
}

static int check_printer_name(char * const printer_name, const char * const t_line, const char * const format)
{
	int n_diff_size = 1;
	char str_printer_name[MAX_BUFSIZE];

	if( (printer_name == NULL) || (t_line == NULL) || (format == NULL) ) {
		return n_diff_size;
	}

	memset( str_printer_name, 0x00, MAX_BUFSIZE );

	snprintf( str_printer_name, MAX_BUFSIZE - 1, format, printer_name );
	n_diff_size = strcmp( t_line, str_printer_name );

	return n_diff_size;
}

static int check_account_printer_name(char * const printer_name, char * const t_line)
{
	int n_diff_size = 1;
	int status = 0;
	char *useAccountStr = NULL;
	char str_printer_name[MAX_BUFSIZE];

	if( (printer_name == NULL) || (t_line == NULL) ) {
		return n_diff_size;
	}

	memset( str_printer_name, 0x00, MAX_BUFSIZE );

	status = get_account_status( printer_name, t_line );
	if( status == 1 ) {
		useAccountStr = ACCOUNT_ON;
	}
	else {
		useAccountStr = ACCOUNT_OFF;
	}

	snprintf( str_printer_name, MAX_BUFSIZE - 1, PRINTER_NAME_FORMAT_STARTEND, printer_name, useAccountStr, printer_name );
	n_diff_size = strcmp( t_line, str_printer_name );

	return n_diff_size;
}

static int get_account_status(char * const printer_name, char * const t_line)
{
	int n_ret = 0;
	unsigned int un_print_name_size = 0;
	char *buf_str = NULL;
	char str_printer_name[MAX_BUFSIZE];

	if( (printer_name == NULL) || (t_line == NULL) ) {
		return n_ret;
	}

	memset( str_printer_name, 0x00, MAX_BUFSIZE );

	snprintf( str_printer_name, MAX_BUFSIZE - 1, PRINTER_NAME_FORMAT_START, printer_name );
	un_print_name_size = strlen( str_printer_name );
	buf_str = t_line;
	buf_str += un_print_name_size;

	if( strncasecmp( buf_str, ACCOUNT_ON, strlen(ACCOUNT_ON) ) == 0 ) {
		n_ret = 1;
	}
	else {
		n_ret = 0;
	}
	return n_ret;
}

int exist_file(char *file_name)
{
	struct stat info;
	int ret = 0;

	if(file_name != NULL){
		ret = stat(file_name, &info);
	}
	return (ret == 0) ? 0 : 1;
}

char* make_file_path(int type, char *user, char *filename)
{
	char path[256];

	memset(path, 0, 256);
	switch(type){
	case ACCOUNT_FILE_TYPE_STATUS_READ:
		strncpy(path, ACCOUNT_PATH, 255);
		strncat(path, "/", 255 - strlen(path));
		strncat(path, filename, 255 - strlen(path));
		if(exist_file(path))
			return NULL;
		break;
	case ACCOUNT_FILE_TYPE_STATUS_WRITE:
		strncpy(path, ACCOUNT_PATH, 255);
		strncat(path, "/", 255 - strlen(path));
		strncat(path, filename, 255 - strlen(path));
		break;
	case ACCOUNT_FILE_TYPE_CONF_READ:
		strncpy(path, ACCOUNT_PATH, 255);
		strncat(path, "/", 255 - strlen(path));
		if(user == NULL)
		{
			strncat(path, "root", 255 - strlen(path));
		}else{
			strncat(path, user, 255);
		}
		strncat(path, filename, 255 - strlen(path));
		if(exist_file(path))
			return NULL;
		break;
	case ACCOUNT_FILE_TYPE_CONF_WRITE:
		strncpy(path, ACCOUNT_PATH, 255);
		strncat(path, "/", 255 - strlen(path));
		if(user == NULL)
		{
			strncat(path, "root", 255 - strlen(path));
		}else{
			strncat(path, user, 255);
		}
		strncat(path, filename, 255 - strlen(path));
		break;
	default:
		break;
	}
	return strdup(path);
}


int save_account_status(char *printer, int useAccount)
{
	int fd_new, fd_org;
	char *file_new = NULL, *file_org = NULL;
	char *useAccountStr = NULL;
	char *t_line = NULL;

	if(printer == NULL)
		return 1;

	if((file_org = make_file_path(ACCOUNT_FILE_TYPE_STATUS_WRITE, NULL,
				ACCOUNT_FILE_STATUS)) == NULL)
		return 1;

	if((file_new = make_file_path(ACCOUNT_FILE_TYPE_STATUS_WRITE, NULL,
				ACCOUNT_FILE_STATUS_NEW)) == NULL)
		goto err;

	if((fd_new = open(file_new, O_RDWR|O_CREAT|O_EXCL, 0644)) < 0)
		goto err;

	useAccountStr = useAccount ? "ON" : "OFF";

	if((fd_org = open(file_org, O_RDONLY)) < 0){
		t_line = (char *)calloc(MAX_BUFSIZE + 1, 1);
		if(t_line == NULL)
			goto err;
		snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_STATUS_FORMAT,
			printer, useAccountStr, printer);
		file_write(fd_new, t_line, strlen(t_line));
	}else{
		int is_curr = 0;
		int offset = 0, l_bytes = 0, r_bytes = 0;
		char t_buf[MAX_BUFSIZE + 1];
		memset(t_buf, 0, sizeof(t_buf));
		while((r_bytes = read(fd_org, t_buf, MAX_BUFSIZE))){
			if(r_bytes == -1){
				if(errno == EINTR){
					continue;
				}else{
					break;
				}
			}
			offset = 0;
			while( r_bytes > offset){
				char new_line[MAX_BUFSIZE];
				memset(new_line, 0, MAX_BUFSIZE);
				l_bytes = get_line_from_buffer(&t_line, t_buf, offset, MAX_BUFSIZE);
				if(l_bytes < 0){
					break;
				}


				if((t_line[0] == '<') &&
				   (check_account_printer_name(printer, &t_line[0]) == 0))
				{
					snprintf(new_line, MAX_BUFSIZE - 1,
						ACCOUNT_STATUS_FORMAT, printer,
						useAccountStr, printer);
					file_write(fd_new, new_line, strlen(new_line));
					is_curr = 1;
				}else{
					char *tmp = NULL;
					int len = strlen(t_line) + 1;
					tmp = (char *)calloc(len + 1, 1);
					if(tmp != NULL){
						snprintf(tmp, len + 1, "%s\n", t_line);
						file_write(fd_new, tmp, strlen(tmp));
						free(tmp);
					}
				}
				offset += l_bytes;
				if(t_line != NULL){
					free(t_line);
					t_line = NULL;
				}
			}
			memset(t_buf, 0, sizeof(t_buf));
		}
		if(is_curr == 0){
			if(t_line != NULL)
				free(t_line);
			t_line = (char *)calloc(MAX_BUFSIZE + 1, 1);
			if(t_line != NULL){
				snprintf(t_line, MAX_BUFSIZE - 1,
					ACCOUNT_STATUS_FORMAT, printer,
					 useAccountStr, printer);
				file_write(fd_new, t_line, strlen(t_line));
			}
		}
	}

	unlink(file_org);
	rename(file_new, file_org);

	if(t_line != NULL)
		free(t_line);
	if(file_new != NULL)
		free(file_new);
	if(file_org != NULL)
		free(file_org);
	if(fd_new > 0)
		close(fd_new);
	if(fd_org > 0)
		close(fd_org);

	return 0;

err:
	if(file_new != NULL)
		free(file_new);
	if(file_org != NULL)
		free(file_org);

	return 1;
}

int save_account_conf(char *printer, char *user, char *id, char *ps, int del)
{
	int fd_new, fd_org;
	char *file_new = NULL, *file_org = NULL;
	char *t_line = NULL;

	if(printer == NULL)
		return 1;

	if((file_org = make_file_path(ACCOUNT_FILE_TYPE_CONF_WRITE, user,
				ACCOUNT_FILE_CONF)) == NULL)
		return 1;

	if((file_new = make_file_path(ACCOUNT_FILE_TYPE_CONF_WRITE, user,
				ACCOUNT_FILE_CONF_NEW)) == NULL)
		goto err;

	if((fd_new = open(file_new, O_RDWR|O_CREAT|O_EXCL, 0600)) < 0)
		goto err;

	if((fd_org = open(file_org, O_RDONLY)) < 0){
		if(del){
			close(fd_new);
			unlink(file_new);
			goto err;
		}
		t_line = (char *)calloc(MAX_BUFSIZE + 1, 1);
		if(t_line == NULL)
			goto err;
		snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_START, printer);
		file_write(fd_new, t_line, strlen(t_line));
		memset(t_line, 0, MAX_BUFSIZE + 1);
		snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_ID, id);
		file_write(fd_new, t_line, strlen(t_line));
		memset(t_line, 0, MAX_BUFSIZE + 1);
		snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_PSWD, ps);
		file_write(fd_new, t_line, strlen(t_line));
		memset(t_line, 0, MAX_BUFSIZE + 1);
		snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_END, printer);
		file_write(fd_new, t_line, strlen(t_line));
	}else{
		int is_curr = 0;
		int offset = 0, l_bytes = 0, r_bytes = 0;
		char t_buf[MAX_BUFSIZE + 1];
		memset(t_buf, 0, sizeof(t_buf));
		while((r_bytes = read(fd_org, t_buf, MAX_BUFSIZE))){
			if(r_bytes == -1){
				if(errno == EINTR)
					continue;
				else
					break;
			}
			offset = 0;

			while(r_bytes > offset){
				char new_line[MAX_BUFSIZE];

				memset(new_line, 0, sizeof(new_line));
				l_bytes = get_line_from_buffer(&t_line, t_buf, offset, MAX_BUFSIZE);

				if(l_bytes < 0){
					break;
				}

				if((t_line[0] == '<') &&
				   (check_printer_name(printer, &t_line[0], PRINTER_NAME_FORMAT_START) == 0))
				{
					is_curr = 1;
					if(del)
						goto skip;
					snprintf(new_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_START, printer);
					file_write(fd_new, new_line, strlen(new_line));
				}
				else if((t_line[0] == '<') && (t_line[1] == '/') &&
				        (check_printer_name(printer, &t_line[0], PRINTER_NAME_FORMAT_END) == 0))
				{
					is_curr = 2;
					if(del)
						goto skip;
					snprintf(new_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_END, printer);
					file_write(fd_new, new_line, strlen(new_line));
				}
				else if((is_curr == 1) &&
				        (strncmp(t_line, "id=", strlen("id=")) == 0))
				{
					if(del)
						goto skip;
					snprintf(new_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_ID, id);
					file_write(fd_new, new_line, strlen(new_line));
				}
				else if((is_curr == 1) &&
			     	    (strncmp(t_line, "password=", strlen("password=")) == 0))
				{
					if(del)
						goto skip;
					snprintf(new_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_PSWD, ps);
					file_write(fd_new, new_line, strlen(new_line));
				}else{
					char *tmp = NULL;
					int len = strlen(t_line) + 1;
					tmp = (char *)calloc(len + 1, 1);
					if(tmp != NULL){
						snprintf(tmp, len + 1, "%s\n", t_line);
						file_write(fd_new, tmp, strlen(tmp));
						free(tmp);
					}
				}
skip:
				offset += l_bytes;
				if(t_line != NULL){
					free(t_line);
					t_line = NULL;
				}
			}
			memset(t_buf, 0, sizeof(t_buf));
		}
		if(is_curr == 0 && del == 0){
			if(t_line != NULL)
				free(t_line);
			t_line = (char *)calloc(MAX_BUFSIZE + 1, 1);
			if(t_line != NULL){
				memset(t_line, 0, MAX_BUFSIZE);
				snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_START, printer);
				file_write(fd_new, t_line, strlen(t_line));
				memset(t_line, 0, MAX_BUFSIZE);
				snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_ID, id);
				file_write(fd_new, t_line, strlen(t_line));
				memset(t_line, 0, MAX_BUFSIZE);
				snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_PSWD, ps);
				file_write(fd_new, t_line, strlen(t_line));
				memset(t_line, 0, MAX_BUFSIZE);
				snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_END, printer);
				file_write(fd_new, t_line, strlen(t_line));
			}
		}
	}

	unlink(file_org);
	rename(file_new, file_org);

	if(t_line != NULL)
		free(t_line);
	if(file_new != NULL)
		free(file_new);
	if(file_org != NULL)
		free(file_org);
	if(fd_new > 0)
		close(fd_new);
	if(fd_org > 0)
		close(fd_new);
	return 0;
err:
	if(file_new != NULL)
		free(file_new);
	if(file_org != NULL)
		free(file_org);

	return 1;
}

int ChangedJobAccount(char *id, char *ps, char *org_id, char *org_ps)
{
	if(strlen(id) == strlen(org_id)){
		if(strcmp(id, org_id) == 0){
			if(strlen(ps) == strlen(org_ps)){
				if(strcmp(ps, org_ps) == 0)
					return 0;
			}
		}
	}
	return 1;
}

int SaveJobAccount(char *printer, char *user, char *id, char *ps, int del)
{
	if(printer == NULL)
		return -1;

#if 0
#else
	switch(del){
		case 0:
			if(id != NULL && ps != NULL){
				save_account_conf(printer, user, id, ps, 0);
			}
			else{
				return -1;
			}
			break;
		case 1:
			save_account_conf(printer, user, NULL, NULL, 1);
			break;
		case 3:
			save_account_status(printer,1);
			break;
		case 4:
			save_account_status(printer,0);
			break;
		default:
			return -1;
	}
#endif

	return 0;
}

int CheckCUPSEntry(char *printer)
{
	cups_dest_t *dest;
	cups_dest_t *curr;
	int num = 0;
	int ret = 1;

	if((num = cupsGetDests(&dest)) != 0){
		if((curr = cupsGetDest(printer, NULL, num, dest)) != NULL)
			ret = 0;
		cupsFreeDests(num, dest);
	}

	return ret;
}

int GetInputID(char *id)
{
	int c;
	int cnt = 0;

	fprintf(stdout, "id : ");

	id[cnt] = 0;
	while((c = getchar()) != '\n'){
		if(cnt < 7)
			id[cnt] = c;
		cnt++;
	}

	return cnt;
}

int GetInputPSWD(char *ps)
{
	struct termios new, org;
	int c;
	int cnt = 0;

	tcgetattr(STDIN_FILENO, &new);
	org = new;

	new.c_lflag &=~ECHO;
	new.c_lflag |= ECHONL;
	tcsetattr(STDIN_FILENO, TCSAFLUSH, &new);

	fprintf(stdout, "password : ");

	ps[cnt] = 0;
	while((c = getchar()) != '\n'){
		if(cnt < 7)
			ps[cnt] = c;
		cnt++;
	}

	tcsetattr(STDIN_FILENO, TCSANOW, &org);

	return cnt;
}

int GetArg(int ac, char *av[])
{
	int ret = 0;

	if(strncmp(av[1], "-p", 2) == 0)
		ret = 0;
	else if(strncmp(av[1], "-x", 2) == 0)
		ret = 1;
	else if(strncmp(av[1], "-e", 2) == 0)
		ret = 3;
	else if(strncmp(av[1], "-d", 2) == 0)
		ret = 4;
	else
		ret = -1;

	if(CheckCUPSEntry(av[2]))
		return 2;

	return ret;
}

void Usage(void)
{
	fprintf(stderr, "cnjatool Usage: \n");
	fprintf(stderr, "Setting Job Accounting ID/Password \n");
	fprintf(stderr, "  cnjatool -p [Printer Name]\n");
	fprintf(stderr, "Remove ID/Password \n");
	fprintf(stderr, "  cnjatool -x [Printer Name]\n\n");
	fprintf(stderr, "Root privilege is required to perform following operations \n");
	fprintf(stderr, "Enable Job Accounting \n");
	fprintf(stderr, "  cnjatool -e [Printer Name]\n");
	fprintf(stderr, "Disable Job Accounting \n");
	fprintf(stderr, "  cnjatool -d [Printer Name]\n");
}

int main(int ac, char *av[])
{
	char *user = NULL;
	char id[32];
	char ps[32];
	int ret = 0;

	if(ac != 3){
		Usage();
		return 0;
	}

	if(getuid() != 0){
		if((user = getenv("USER")) == NULL)
			return 1;
	}

	ret = GetArg(ac, av);

	if(ret == 0){
		memset(id, 0, 32);
		memset(ps, 0, 32);
		while(GetInputID(id) == 0);
		GetInputPSWD(ps);
		SaveJobAccount(av[2], user, id, ps, 0);
	}else if(ret == 1){
		SaveJobAccount(av[2], user, NULL, NULL, 1);
	}else if(ret == 2){
		fprintf(stderr, "No Printer Queue Entry\n");
	}else if(ret == 3 || ret == 4 ){
		if(getuid() == 0 ){
			SaveJobAccount(av[2], user, NULL, NULL, ret);
		}
		else{
			Usage();
		}
	}else{
		Usage();
	}

	return 0;
}


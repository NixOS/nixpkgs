/*
 *  CUPS add-on module for Canon CAPT printer.
 *  Copyright CANON INC. 2001
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

#include <cups/cups.h>
#include <cups/ppd.h>
#include <ctype.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <ctype.h>
#include <errno.h>


#include "paramlist.h"
#include "buflist.h"




#define	TABLE_BUF_SIZE	1024
#define	LINE_BUF_SIZE	1024
#define	DATA_BUF_SIZE	(1024 * 256)

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#define FILTER_PATH    PROG_PATH
#define FILTER_BIN     "captfilter"
#define GS_PATH        "/usr/bin"
#define GS_BIN         "gs"
#define SHELL_PATH     "/bin"
#define SHELL_NAME     "sh"

#define IS_BLANK(c)		(c == ' '  || c == '\t')
#define IS_RETURN(c)	(c == '\r' || c == '\n')

#define ACRO_UTIL "%%BeginResource: procset Adobe_CoolType_Utility_MAKEOCF"
#define ACRO_UTIL_LEN 55

int g_filter_pid = -1;


char *ppd_opt_name[] =
{
	"PageSize",
	"MediaType",
	"InputSlot",
	"Collate",
	"OutputBin",
	"Resolution",
	"CNTonerSaving",
	"CNTonerDensity",
	"CNSuperSmooth",
	"CNHalftone",
	"BindEdge",
	"Duplex",
	"CNFixingMode",
	"CNBackPaperPrint",
	"CNRotatePrint",
};

char *cmd_opt_name[] =
{
	"CNCopies",
	"CNBindEdgeShift",
	"CNPPAPrint",
	"number-up",
	"outputorder",
};

char *drv_tbl_name[] =
{
	"CNTblHalftone",
	"CNTblModel",
};


static
int is_cmd_opt_name(char *cmd_opt)
{
	int cmd_opt_num = sizeof(cmd_opt_name) / sizeof(char*);
	int i;

	for( i = 0 ; i < cmd_opt_num ; i++ )
	{
		if( strcmp(cmd_opt, cmd_opt_name[i]) == 0 )
			return 1;
	} return 0;
}

static
char *ppd_mark_to_job_attr(ppd_file_t *p_ppd,
	cups_option_t *p_cups_opt, int num_opt, char *p_table)
{
	int ppd_opt_num = sizeof(ppd_opt_name) / sizeof(char*);
	int opt_len = strlen(p_table);
	char *p_job_attr = NULL;
	ppd_choice_t *p_choice;
	cups_option_t *p_opt;

	int i;

	for( i = 0 ; i < ppd_opt_num ; i++ )
	{
		p_choice = ppdFindMarkedChoice(p_ppd, ppd_opt_name[i]);
		if( p_choice != NULL )
		{
			opt_len += strlen(ppd_opt_name[i])
					+ strlen(p_choice->choice)
					+ 4;
		}
	}
	for( p_opt = p_cups_opt, i = 0 ; i < num_opt ; i++ )
	{
		if( is_cmd_opt_name(p_opt->name) )
		{
			opt_len += strlen(p_opt->name)
					+ strlen(p_opt->value)
					+ 4;
		}
		p_opt++;
	}

	if( opt_len > 0 )
	{
		if( (p_job_attr = malloc(opt_len + 1)) != NULL )
		{

			strcpy(p_job_attr, p_table);

			for( i = 0 ; i < ppd_opt_num ; i++ )
			{
				p_choice = ppdFindMarkedChoice(p_ppd, ppd_opt_name[i]);
				if( p_choice != NULL )
				{
					strcat(p_job_attr, "--");
					strcat(p_job_attr, ppd_opt_name[i]);
					strcat(p_job_attr, "=");
					strcat(p_job_attr, p_choice->choice);
					strcat(p_job_attr, " ");
				}
			}

			for( p_opt = p_cups_opt, i = 0 ; i < num_opt ; i++ )
			{
				if( is_cmd_opt_name(p_opt->name) )
				{
					strcat(p_job_attr, "--");
					strcat(p_job_attr, p_opt->name);
					strcat(p_job_attr, "=");
					strcat(p_job_attr, p_opt->value);
					strcat(p_job_attr, " ");
				}
				p_opt++;
			}
			p_job_attr[opt_len - 1] = '\0';
		}
	}
	return p_job_attr;
}

static
int get_string(char *p_line_buf, char *p_value_buf, int value_len)
{
	int pos = 0;
	int val_pos = 0;

	while( IS_BLANK(p_line_buf[pos]) )
		pos++;
	while( p_line_buf[pos] == ':' )
		pos++;
	while( IS_BLANK(p_line_buf[pos]) )
		pos++;
	while( p_line_buf[pos] == '"')
		pos++;

	while( !IS_BLANK(p_line_buf[pos])
		&& !IS_RETURN(p_line_buf[pos])
		&& p_line_buf[pos] != '"'
		&& p_line_buf[pos] != '\n'
		&& val_pos < 255 )
			p_value_buf[val_pos++] = p_line_buf[pos++];
	p_value_buf[val_pos++] = 0;

	return val_pos;
}

static
int get_driver_table(char *ppd_file, char *p_buf, int buf_len)
{
	FILE *fp = fopen(ppd_file, "r");
	int drv_tbl_num = sizeof(drv_tbl_name) / sizeof(char*);
	char line_buf[LINE_BUF_SIZE];
	int got_tbl_num = 0;

	if( fp && p_buf != NULL && buf_len > 0 )
	{
		int cc;
		int pos = 0;

		*p_buf = '\0';

		do
		{
			cc = fgetc(fp);

			if( cc != '\n' && cc != EOF )
			{
				if( pos < LINE_BUF_SIZE - 1 )
					line_buf[pos++] = cc;
			}
			else
			{
				int i;

				line_buf[pos] = 0;

				for( i = 0 ; i < drv_tbl_num ; i++ )
				{
					int name_len = strlen(drv_tbl_name[i]);
					char value[256];

					if( line_buf[0] == '*'
					 && strncmp(line_buf + 1, drv_tbl_name[i], name_len) == 0 )
					{
						if( get_string(line_buf+1+name_len, value, 256) > 0 )
						{
							int new_len = strlen(p_buf)
										+ name_len + strlen(value) + 2;

							if( new_len < buf_len - 1 )
							{
								strcat(p_buf, "--");
								strcat(p_buf, drv_tbl_name[i]);
								strcat(p_buf, "=");
								strcat(p_buf, value);
								strcat(p_buf, " ");
							}
							got_tbl_num++;
						}
					}
				}
				pos = 0;
			}
		}
		while( cc != EOF && got_tbl_num < drv_tbl_num );

		fclose(fp);
	}
	return got_tbl_num;
}

static
char *make_job_attr(ppd_file_t *p_ppd, char *p_ppd_name,
	 cups_option_t *p_cups_opt, int num_opt)
{
	char *p_job_attr = NULL;
	char table_buf[TABLE_BUF_SIZE];

	if( get_driver_table(p_ppd_name, table_buf, TABLE_BUF_SIZE) )
	{
		p_job_attr = ppd_mark_to_job_attr(p_ppd,
						p_cups_opt, num_opt, table_buf);
	}
	return p_job_attr;
}

static
int is_acro_util(char *p_data_buf, int read_bytes)
{
	if( strncmp(p_data_buf, ACRO_UTIL, ACRO_UTIL_LEN) == 0 )
		return 1;
	else
		return 0;
}

static
int is_end_resource(char *p_data_buf, int read_bytes)
{
	if( strncmp(p_data_buf, "%%EndResource", 13) == 0 )
		return 1;
	else
		return 0;
}

static
int read_line(int fd, char *p_buf, int bytes)
{
	static char read_buf[DATA_BUF_SIZE];
	static int buf_bytes = 0;
	static int buf_pos = 0;
	int read_bytes = 0;

	while( bytes > 0 )
	{
		if( buf_bytes == 0 && fd != -1 )
		{
			buf_bytes = read(fd, read_buf, DATA_BUF_SIZE);

			if( buf_bytes > 0 )
				buf_pos = 0;
		}

		if( buf_bytes > 0 )
		{
			*p_buf = read_buf[buf_pos++];
			bytes--;
			buf_bytes--;
			read_bytes++;

			if( IS_RETURN(*p_buf) )
				break;

			p_buf++;
		}
		else if( buf_bytes < 0 )
		{
			if( errno == EINTR )
				continue;
		}
		else
			break;
	}

	return read_bytes;
}

static
ParamList *get_ps_params(int ifd, BufList **ps_data)
{
	char read_buf[DATA_BUF_SIZE];
	ParamList *p_list = NULL;
	int begin_page = 0;
	int acro_util = 0;
	int read_bytes;
	BufList *bl = NULL;
	BufList *prev_bl = NULL;

	while( (read_bytes = read_line(ifd, read_buf, DATA_BUF_SIZE - 1)) > 0 )
	{

		{
			if( is_acro_util(read_buf, read_bytes) ){
				acro_util = 1;
			}
			else if( acro_util && is_end_resource(read_buf, read_bytes) ){
				acro_util = 0;
			}

			if( acro_util ){
				int line_bytes=0;
				while( line_bytes+29 < read_bytes ){
					if(!strncmp(&read_buf[line_bytes],
								" ct_BadResourceImplementation?", 30)){
						strcpy(&read_buf[line_bytes], " false");
						line_bytes+=6;
						strcpy(&read_buf[line_bytes],
							   &read_buf[line_bytes+24]);
						read_bytes-=24;
					}
					else{
						line_bytes++;
					}
				}
			}
		}

		bl = buflist_new(read_buf, read_bytes);

		if( *ps_data == NULL )
			*ps_data = bl;
		else
			buflist_add_tail(prev_bl, bl);

		prev_bl = bl;

		if( read_bytes > 0 )
		{
			if( read_buf[read_bytes - 1] == '\n' )
				read_buf[read_bytes - 1] = '\0';
			else
				read_buf[read_bytes] = '\0';
		}
		else
		{
			read_buf[0] = '\0';
		}

		if( strncmp(read_buf, "%%BeginFeature:", 15) == 0 )
		{
			char key_buf[MAX_KEY_LEN + 1];
			char value_buf[MAX_VALUE_LEN + 1];
			int key_len = 0;
			int value_len = 0;
			char *p_code;

			p_code = read_buf + 15;

			while( *p_code != '\0' )
				if( *p_code++ == '*' )
					break;

			while( *p_code != '\0' )
			{
				if( IS_BLANK(*p_code)
				 || key_len >= MAX_KEY_LEN )
					break;
				key_buf[key_len++] = *p_code++;
			}
			while( *p_code != '\0' )
			{
				if( !IS_BLANK(*p_code)  )
					break;
				*p_code++;
			}
			while( *p_code != '\0' )
			{
				if( IS_BLANK(*p_code)
				 || value_len >= MAX_VALUE_LEN )
					break;
				value_buf[value_len++] = *p_code++;
			}
			if( key_len > 0 && value_len > 0 )
			{
				key_buf[key_len] = '\0';
				value_buf[value_len] = '\0';

				param_list_add(&p_list, key_buf, value_buf, value_len + 1);
			}
		}
		else if( !begin_page && strncmp(read_buf, "%%Page:", 7) == 0 )
		{
			begin_page = 1;
		}
		else if( begin_page )
		{
			if( strncmp(read_buf, "%%EndPageSetup", 14) == 0 )
				break;
			else if( strncmp(read_buf, "gsave", 5) == 0 )
				break;
			else if( read_buf[0] >= '0' && read_buf[0] <= '9' )
				break;
		}
	}

	while( (read_bytes = read_line(-1, read_buf, DATA_BUF_SIZE - 1)) > 0 )
	{
		BufList *bl = buflist_new(read_buf, read_bytes);

		if( *ps_data == NULL )
			*ps_data = bl;
		else
			buflist_add_tail(prev_bl, bl);

		prev_bl = bl;
	}

	return p_list;
}

static
void mark_ps_param_options(ppd_file_t *p_ppd, ParamList *p_param)
{
	int num = param_list_num(p_param);

	if( num > 0 )
	{
		cups_option_t *options
			= (cups_option_t*)malloc(num * sizeof(cups_option_t));
		if( options )
		{
			int i;
			for( i = 0 ; i < num ; i++ )
			{
				options[i].name = p_param->key;
				options[i].value = p_param->value;
				p_param = p_param->next;
			}
			for( i = num - 1 ; i >= 0 ; i-- )
			{
				cupsMarkOptions(p_ppd, 1, &options[i]);
			}

			free(options);
		}
	}
}

static
char* make_cmd_param(cups_option_t *p_cups_opt, int num_opt,
	ParamList *p_param)
{
#ifdef DEBUG_PPD
	char *p_ppd_name = "debug.ppd";
#else
	char *p_ppd_name = getenv("PPD");
#endif
	ppd_file_t *p_ppd;
	ppd_choice_t *p_choice;
	int reso;
	char *p_job_attr = NULL;
	char gs_exec_buf[256];
	char gs_cmd_buf[1024];
	char *flt_exec_buf=NULL;
	char *flt_cmd_buf=NULL;
	char *cmd_buf = NULL;

	if( (p_ppd = ppdOpenFile(p_ppd_name)) == NULL )
		return NULL;

	ppdMarkDefaults(p_ppd);
	cupsMarkOptions(p_ppd, num_opt, p_cups_opt);
	mark_ps_param_options(p_ppd, p_param);

	p_choice = ppdFindMarkedChoice(p_ppd, "Resolution");
	reso = atoi(p_choice->choice);

	strcpy(gs_exec_buf, GS_PATH);
	strcat(gs_exec_buf, "/");
	strcat(gs_exec_buf, GS_BIN);
	snprintf(gs_cmd_buf, 1023,
		 "%s -r%d -q -dNOPROMPT -dSAFER -sDEVICE=pgmraw -sOutputFile=- -| ",
			 gs_exec_buf, reso);

	p_job_attr = make_job_attr(p_ppd, p_ppd_name, p_cups_opt, num_opt);
	ppdClose(p_ppd);

	if( p_job_attr != NULL )
	{
		int buf_len;
		int exec_len, cmd_len;

		exec_len = strlen(FILTER_PATH) + strlen(FILTER_BIN) + 3;
		cmd_len = strlen(p_job_attr) + exec_len + 3;
		flt_exec_buf = malloc(exec_len);
		flt_cmd_buf = malloc(cmd_len);

		if( flt_exec_buf != NULL && flt_cmd_buf != NULL ){

			strcpy(flt_exec_buf, FILTER_PATH);
			strcat(flt_exec_buf, "/");
			strcat(flt_exec_buf, FILTER_BIN);
			snprintf(flt_cmd_buf, cmd_len-1, "%s %s", flt_exec_buf, p_job_attr);

			buf_len = strlen(gs_cmd_buf) + strlen(flt_cmd_buf) + 1;

			if( (cmd_buf = (char*)malloc(buf_len)) != NULL )
			{
				strcpy(cmd_buf, gs_cmd_buf);
				strcat(cmd_buf, flt_cmd_buf);
			}
			free(p_job_attr);
			free(flt_exec_buf);
			free(flt_cmd_buf);
		}
		return cmd_buf;
	}
	else
		return NULL;
}


int exec_filter(char *cmd_buf, int ofd, int fds[2])
{
	int status = 0;
	int	child_pid = -1;
	char *filter_param[4];
	char shell_buf[256];

	if( pipe(fds) >= 0 )
	{
		child_pid = fork();

		if( child_pid == 0 )
		{

			setpgid(0, 0);

			close(0);
			dup2(fds[0], 0);
			close(fds[0]);
			close(fds[1]);

			if( ofd != 1 )
			{
				close(1);
				dup2(ofd, 1);
				close(ofd);
			}

			{

				strcpy(shell_buf, SHELL_PATH);
				strcat(shell_buf, "/");
				strcat(shell_buf, SHELL_NAME);

				filter_param[0] = shell_buf;
				filter_param[1] = "-c";
				filter_param[2] = cmd_buf;
				filter_param[3] = NULL;

				execv(shell_buf, filter_param);

				fprintf(stderr, "execv() error\n");
				status = -1;
			}
		}
		else if( child_pid != -1 )
		{
			close(fds[0]);
		}
	}
	return child_pid;
}

static
void
sigterm_handler(int sigcode)
{
	if( g_filter_pid != -1 )
		kill(-g_filter_pid, SIGTERM);
}

int	main(int argc, char *argv[])
{
	cups_option_t *p_cups_opt = NULL;
	int num_opt = 0;
	ParamList *p_ps_param = NULL;
	BufList *p_ps_data = NULL;
	char *p_data_buf;
	int ifd = 0;
	int fds[2];
	struct sigaction sigact;
	char *cmd_buf = NULL;

#ifdef	DEBUG_SLEEP
	sleep(30);
#endif

	setbuf(stderr, NULL);
	fprintf(stderr, "DEBUG: pstocapt start.\n");

	memset(&sigact, 0, sizeof(sigact));
	sigact.sa_handler = sigterm_handler;
	if( sigaction(SIGTERM, &sigact, NULL) )
	{
		fputs("ERROR: pstocapt can't register signal hander.\n", stderr);
		return 1;
	}

	if( argc < 6 || argc > 7 )
	{
		fputs("ERROR: pstocapt illegal parameter number.\n", stderr);
		return 1;
	}

	if( argv[5] != NULL )
	{
		num_opt = cupsParseOptions(argv[5], 0, &p_cups_opt);
		if( num_opt < 0 )
		{
			fputs("ERROR: illegal option.\n", stderr);
			return 1;
		}
	}

	if( argc == 7 )
	{
		if( (ifd = open(argv[6], O_RDONLY)) == -1 )
		{
			fputs("ERROR: can't open file.\n", stderr);
			return 1;
		}
	}

	p_ps_param = get_ps_params(ifd, &p_ps_data);

	if( (cmd_buf=make_cmd_param(p_cups_opt, num_opt, p_ps_param))
		== NULL )
	{
		fputs("ERROR: can't make parameter.\n", stderr);
		goto error_return;
	}

	if( (p_data_buf = (char*)malloc(DATA_BUF_SIZE)) != NULL )
	{
#ifdef	DEBUG_PS
		int log_fd = open("/tmp/debug_data_log.ps", O_WRONLY);
#endif
		g_filter_pid = exec_filter(cmd_buf, 1, fds);

		buflist_write(p_ps_data, fds[1]);

#ifdef	DEBUG_PS
		buflist_write(p_ps_data, log_fd);
#endif

		for(;;)
		{
			int read_bytes = read(ifd, p_data_buf, DATA_BUF_SIZE);

			if( read_bytes > 0 )
			{
				int write_bytes;
				char *p_data = p_data_buf;
#ifdef	DEBUG_PS
				write(log_fd, p_data_buf, read_bytes);
#endif
				do
				{
					write_bytes = write(fds[1], p_data, read_bytes);

					if( write_bytes < 0 )
					{
						if( errno == EINTR )
							continue;
						fprintf(stderr,
							"ERROR: pstocapt write error,%d.\n", errno);
						goto error_exit;
					}
					read_bytes -= write_bytes;
					p_data += write_bytes;
				}
				while( read_bytes > 0 );
			}
			else if( read_bytes < 0 )
			{
				if( errno == EINTR )
					continue;
				fprintf(stderr, "ERROR: pstocapt read error,%d.\n", errno);
				goto error_exit;
			}
			else
				break;
		}

		free(p_data_buf);

#ifdef	DEBUG_PS
		if( log_fd != -1 ) close(log_fd);
#endif
	}

	free(cmd_buf);

	if( p_ps_param != NULL )
		param_list_free(p_ps_param);
	if( p_ps_data != NULL )
		buflist_destroy(p_ps_data);
	if( ifd != 0 )
		close(ifd);

	close(fds[1]);

	if( g_filter_pid != -1 )
		waitpid(g_filter_pid, NULL, 0);

	return 0;

error_exit:
	if( p_data_buf != NULL )
		free(p_data_buf);

error_return:
	free(cmd_buf);

	if( p_ps_param != NULL )
		param_list_free(p_ps_param);
	if( p_ps_data != NULL )
		buflist_destroy(p_ps_data);
	if( ifd != 0 )
		close(ifd);

	return 1;
}


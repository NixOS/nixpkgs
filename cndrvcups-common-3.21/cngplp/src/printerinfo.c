/*
 *  Print Dialog for Canon LIPS/PS/LIPSLX/UFR2/CAPT Printer.
 *  Copyright CANON INC. 2010
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
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "printerinfo.h"
#include "mainwnd.h"

#define LIB_PREFIX 		"lib"
#define LIB_SUFFIX 		".so"
#define PRINT_LANG		"*%CNPrintLang"
#define PRINT_LIB_NAME		"*%CNGPLPLIBNAME:"
#define PRINT_LIB_NAME_VER	"*%CNGPLPLIBNAMEVER:"
#define SEPERATOR		"."
#define LIB_INFO_MAX		32

PrintersInfo* g_printers = NULL;
char* FillUp(char *buff);
char* ChkMainKey(char *dest, char *src, int num);
static PrinterInfo* GetPrinterInfo(const char* printer_name);

int GetAllPrinters()
{
	cups_dest_t *all_dests = NULL;
	cups_dest_t *curr_dest = NULL;
	PrintersInfo *printers = NULL;
	int num = 0, i = 0;
	PrinterInfo *info = NULL;

	num = cupsGetDests(&all_dests);
	if(0 == num){
		return -1;
	}
	printers = (PrintersInfo*)malloc(sizeof(PrintersInfo));
	if(NULL == printers){
		return -1;
	}
	memset(printers, 0, sizeof(PrintersInfo));
	g_printers = printers;

	curr_dest = all_dests;
	for(i = 0; i < num; i++){
		if(curr_dest->name != NULL){
			info = GetPrinterInfo((char*)curr_dest->name);
			if(info != NULL){
				printers->printer_list = g_list_append(printers->printer_list, info);
				if(TRUE == curr_dest->is_default){
					printers->curr_printer = info;
				}
			}
		}
		curr_dest++;
	}
	if(0 == g_list_length(printers->printer_list))
	{
		return -1;
	}
	if(NULL == printers->curr_printer){
		printers->curr_printer = g_list_nth_data(printers->printer_list, 0);
	}
	cupsFreeDests(num, all_dests);
	return 0;
}

int GetPrinterToGList(const char* combo_name)
{
	PrintersInfo* printers = NULL;
	GList* list = NULL;
	GtkWidget *combo = NULL, *entry = NULL;
	PrinterInfo* info = NULL;
	int i = 0;

	printers = g_printers;
	if(NULL == printers){
		if(GetAllPrinters() < 0){
			return -1;
		}
		printers = g_printers;
	}

	for(i = 0; i < g_list_length(printers->printer_list); i++){
		info = (PrinterInfo*)g_list_nth_data(printers->printer_list, i);
		if(info != NULL){
			list = g_list_append(list, info->name);
		}
	}
	combo = glade_xml_get_widget(g_main_xml, combo_name);
	if(combo != NULL){
		entry = GTK_COMBO(combo)->entry;
	}

	if(list != NULL){
		gtk_combo_set_popdown_strings(GTK_COMBO(combo), list);
		gtk_entry_set_text(GTK_ENTRY(entry), printers->curr_printer->name);
		g_list_free(list);
	}
	return 0;
}

int GetCurrPrinterType()
{
	PrintersInfo* printers = g_printers;
	if(NULL == printers){
		if(GetAllPrinters() < 0){
			return -1;
		}
		printers = g_printers;
	}

	return printers->curr_printer->type;
}

char* GetCurrPrinterLib()
{
	PrintersInfo* printers = g_printers;
	if(NULL == printers){
		if(GetAllPrinters() < 0){
			return NULL;
		}
		printers = g_printers;
	}
	return printers->curr_printer->lib;
}

void SetLibInfo(char* buff, char** lib_name)
{
	char *ptr = NULL, lib_info[LIB_INFO_MAX], *np = NULL;

	memset(lib_info, 0, sizeof(lib_info));
	ptr = buff;
	np = lib_info;

	while(1){
		if(((*ptr) == '\0') || ((*ptr) == '\n')){
			break;
		}
		if((*ptr) == '\"'){
			ptr++;
			break;
		}
		ptr++;
	}

	while(1){
		if(((*ptr) == '\0') || ((*ptr) == '\n')){
			*np = '\0';
			break;
		}
		if((*ptr) == '\"'){
			*np = '\0';
			break;
		}
		if((np - lib_info) == (LIB_INFO_MAX - 1)){
			break;
		}
		*np = *ptr;
		np++;
		ptr++;
	}
	*lib_name = strdup(lib_info);
}

static PrinterInfo* GetPrinterInfo(const char* printer_name)
{
	FILE *fp = NULL;
	char buff[MAXWORDSIZE], *ptr = NULL, *tmp = NULL;
	char* lib_name = NULL, *lib_version = NULL;
	int lib_len = 0;
	gboolean find_lang = FALSE;
	const char* ppd_file = NULL;
	int printer_type = PRINTER_TYPE_OTHER;

	ppd_file = cupsGetPPD(printer_name);
	if(NULL == ppd_file){
		return NULL;
	}
	fp = fopen(ppd_file, "r");
	if(NULL == fp){
		return NULL;
	}else{
		while((fgets(buff, MAXWORDSIZE, fp)) != NULL){
			ptr = FillUp(buff);
			tmp = ChkMainKey(ptr, PRINT_LANG, strlen(PRINT_LANG));
			if(tmp != NULL){
				if(strstr(tmp, "LIPS4") != NULL){
					printer_type = PRINTER_TYPE_LIPS;
				}else if(strstr(tmp, "PS3") != NULL){
					printer_type = PRINTER_TYPE_PS;
				}else if(strstr(tmp, "UFR2") != NULL){
					printer_type = PRINTER_TYPE_UFR2;
				}else if(strstr(tmp, "CAPT") != NULL){
					printer_type = PRINTER_TYPE_CAPT;
				}
				find_lang = TRUE;
			}else{
				tmp = ChkMainKey(ptr, PRINT_LIB_NAME, strlen(PRINT_LIB_NAME));
				if(tmp != NULL){
					SetLibInfo(tmp, &lib_name);
				}else{
					tmp = ChkMainKey(ptr, PRINT_LIB_NAME_VER, strlen(PRINT_LIB_NAME_VER));
					if(tmp != NULL){
						SetLibInfo(tmp, &lib_version);
					}
				}
			}
			if((TRUE == find_lang) && (lib_name != NULL) && (lib_version != NULL)){
				break;
			}
		}
	}
	fclose(fp);
	unlink(ppd_file);
	if(NULL == lib_name || NULL == lib_version){
		if(lib_name != NULL){
			free(lib_name);
			lib_name = NULL;
		}
		if(lib_version != NULL){
			free(lib_version);
			lib_version = NULL;
		}
		return NULL;
	}
	PrinterInfo* info = (PrinterInfo*)malloc(sizeof(PrinterInfo));
	if(NULL == info){
		if(lib_name != NULL){
			free(lib_name);
			lib_name = NULL;
		}
		if(lib_version != NULL){
			free(lib_version);
			lib_version = NULL;
		}
		return NULL;
	}
	memset(info, 0, sizeof(PrinterInfo));
	info->name = strdup(printer_name);
	lib_len = strlen(LIB_PREFIX)+ strlen(lib_name) + strlen(LIB_SUFFIX) + strlen(SEPERATOR) + strlen(lib_version) + 1;
	info->lib = (char*)malloc(lib_len);
	memset(info->lib, 0, lib_len);
	strcat(info->lib, LIB_PREFIX);
	strcat(info->lib, lib_name);
	strcat(info->lib, LIB_SUFFIX);
	strcat(info->lib, SEPERATOR);
	strcat(info->lib, lib_version);
	free(lib_version);
	free(lib_name);
	info->type = printer_type;
	return info;
}

int SetCurrPrinter(const char* printer_name)
{
	int i = 0;
	PrintersInfo* printers = NULL;
	PrinterInfo* info = NULL;
	if(NULL == printer_name){
		return -1;
	}

	printers = g_printers;
	if(NULL == printers){
		if(GetAllPrinters() < 0){
			return -1;
		}
		printers = g_printers;
	}
	for(i = 0; i < g_list_length(printers->printer_list); i++){
		info = g_list_nth_data(printers->printer_list, i);
		if((info != NULL) && (0 == strcmp(printer_name, info->name))){
			printers->curr_printer = info;
			break;
		}
	}
	return 0;
}

char* FillUp(char *buff)
{
	char *ptr = NULL;
	ptr = buff;
	while(1){
		if(((*ptr) == ' ') || ((*ptr) == '\t')){
			ptr++;
		}else if(((*ptr) == '\0') || ((*ptr) == '\n')){
			break;
		}else{
			break;
		}
	}
	return ptr;
}

char* ChkMainKey(char *dest, char *src, int num)
{
	int i = 0;
	int dc = 0, sc = 0;
	char *dp = NULL, *sp = NULL;
	dp = dest;
	sp = src;

	for(i = 0; i < num; i++){
		dc = tolower(*dp);
		sc = tolower(*sp);
		if(dc != sc){
			return NULL;
		}
		dp++;
		sp++;
	}
	return dp;
}

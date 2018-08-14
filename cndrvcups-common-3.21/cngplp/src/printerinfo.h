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


#ifndef _PRINTERINFO
#define _PRINTERINFO

#include <gtk/gtk.h>
typedef struct{
	char* name;
	char* lib;
	int type;
}PrinterInfo;

typedef struct{
	int printer_num;
	GList* printer_list;
	PrinterInfo* curr_printer;
}PrintersInfo;

#define MAXWORDSIZE 512
#define	PRINTER_TYPE_OTHER	0
#define PRINTER_TYPE_LIPS	1
#define PRINTER_TYPE_PS		2
#define	PRINTER_TYPE_CAPT	3
#define	PRINTER_TYPE_UFR2	4
#define	PRINTER_TYPE_CAPT_BIND	11

int GetSysPrinters();
int GetCurrPrinterType();
char* GetCurrPrinterLib();
int GetPrinterToGList(const char* combo_name);
int SetCurrPrinter(const char* printer_name);
int GetAllPrinters();
extern PrintersInfo* g_printers;

#endif

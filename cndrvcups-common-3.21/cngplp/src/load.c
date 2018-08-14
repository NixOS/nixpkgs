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


#include <gmodule.h>
#include <stdio.h>
#include <string.h>
#include "load.h"
#include "mainwnd.h"
#include "printerinfo.h"

GModule* g_module = NULL;
char pre_lib_name[MAX_PATH];
gboolean first_load = TRUE;

int LoadPDL(GladeXML* main_xml, const char* print_file)
{
	GtkWidget* main_dlg = NULL;
	char *lib_name = NULL;
	const int printer_type = GetCurrPrinterType();
	int ret = 0;
	if(printer_type == PRINTER_TYPE_OTHER){
		return 0;
	}

	main_dlg = glade_xml_get_widget(g_main_xml, "MainDlg");
	if(NULL == main_dlg){
		printf("the main dialog does not exist\n.");
		return -1;
	}
	lib_name = GetCurrPrinterLib();
	if(NULL == lib_name){
		printf("the module name does not exist in ppd file\n.");
		return -1;
	}
	UnLoadPDL();
	first_load = TRUE;
	g_module = g_module_open(lib_name, G_MODULE_BIND_LAZY);
	if(NULL == g_module){
		printf("%s\n", g_module_error());
		printf("the module %s does not exist\n.", lib_name);
		memset(pre_lib_name, 0, MAX_PATH);
		return -1;
	}
	g_module_symbol(g_module, "InitController", (gpointer *)&InitPDLController);
	g_module_symbol(g_module, "ShowDialog", (gpointer *)&ShowPDLDialog);
	g_module_symbol(g_module, "UpdateData", (gpointer*)&UpdatePDLData);
	g_module_symbol(g_module, "UpdateDataInt", (gpointer*)&UpdatePDLDataInt);
	g_module_symbol(g_module, "CloseController", (gpointer *)&ClosePDLController);
	g_module_symbol(g_module, "SavePrinterData", (gpointer *)&SavePDLPrinterData);
	g_module_symbol(g_module, "PrintFile", (gpointer *)&PrintPDLFile);
	g_module_symbol(g_module, "GetData", (gpointer *)&GetPDLData);
	g_module_symbol(g_module, "GetDataInt", (gpointer *)&GetPDLDataInt);
	g_module_symbol(g_module, "ExecJobMode", (gpointer *)&ExecPDLJobMode);
	ret = InitPDLController(main_dlg, g_printers->curr_printer->name, print_file, first_load);
	if(TRUE == ret){
		first_load = FALSE;
		strcpy(pre_lib_name, lib_name);
	}else{
		memset(pre_lib_name, 0, MAX_PATH);
	}
	return ret;
}

void UnLoadPDL()
{
	if(g_module != NULL){
		if(ClosePDLController != NULL){
			ClosePDLController();
		}
		g_module_close(g_module);
		g_module = NULL;
		InitPDLController = NULL;
		ShowPDLDialog = NULL;
		UpdatePDLData = NULL;
		UpdatePDLDataInt = NULL;
		ClosePDLController = NULL;
		SavePDLPrinterData = NULL;
		PrintPDLFile = NULL;
		GetPDLData = NULL;
		GetPDLDataInt = NULL;
		ExecPDLJobMode = NULL;
	}
}

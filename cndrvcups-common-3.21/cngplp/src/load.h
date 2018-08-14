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


#ifndef _LOAD
#define _LOAD

#include <glade/glade.h>

#define MAX_PATH 256
#define GLADE_FILE  "cngplp.glade"

int LoadPDL(GladeXML* main_xml, const char* print_file);
void UnLoadPDL();
void (*ShowPDLDialog)(const char* name, int print);
gboolean (*InitPDLController)(GtkWidget* main_dlg, char *printer_name, const char* print_file, gboolean first_load);
void (*UpdatePDLData)(int id, const char* value);
void (*UpdatePDLDataInt)(int id, int value);
void (*ClosePDLController)();
void (*SavePDLPrinterData)();
void (*PrintPDLFile)();
char* (*GetPDLData)(int id);
int (*GetPDLDataInt)(int id, int def);
int (*ExecPDLJobMode)();

#endif

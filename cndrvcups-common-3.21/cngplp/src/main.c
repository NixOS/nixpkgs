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


#include <dlfcn.h>
#include <gmodule.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gtk/gtk.h>
#include "mainwnd.h"
#include "printerinfo.h"

char* LaunchOption(int argc, char **argv)
{
	char *file = NULL;
	if(argc > 1){
		if(strcmp(argv[1], "-h") == 0){
			printf("cngplp --- Print Dialog for Canon LIPS/PS/LIPSLX/UFR2/CAPT Printer.\n");
			printf("Usage:	cngplp		        Executing default settings.\n");
			printf("	cngplp -p [print file]  Printing Using the UI Setting.\n");
			exit(1);
		}
	}
	if(argc == 3){
		if(strcmp(argv[1], "-p") == 0){
			if(argv[2] != NULL)
				file = argv[2];
		}
	}

	return file;
}

int main(int argc, char **argv)
{
	char *print_file_name = NULL;
#ifdef ENABLE_NLS
	bindtextdomain (PACKAGE, PACKAGE_LOCALE_DIR);
#ifndef OLD_GTK
	bind_textdomain_codeset(PACKAGE, "UTF-8");
#endif
	textdomain (PACKAGE);
#endif
	gtk_set_locale();
	gtk_init(&argc,&argv);
	print_file_name = LaunchOption(argc, argv);
	if(CreateMainDlg(print_file_name, PACKAGE) < 0){
		return -1;
	}
	gtk_main();
	return 0;
}


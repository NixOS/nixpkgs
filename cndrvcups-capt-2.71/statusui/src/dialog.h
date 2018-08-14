/*
 *  Status monitor for Canon CAPT Printer.
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


#ifndef _DIALOG
#define _DIALOG

#include <gtk/gtk.h>

typedef struct ui_dialog_s{
	GtkWidget *window;
	struct ui_dialog_s *parent;
	int size;
}UIDialog;

#define UI_DIALOG(x)	((UIDialog *)x)

UIDialog* CreateDialog(int size, UIDialog *parent);
void DisposeDialog(UIDialog *dialog);
void ShowDialog(UIDialog *dialog, gchar *def_widget_name);
void HideDialog(UIDialog *dialog);

#endif

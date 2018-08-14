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



#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "dialog.h"
#include "widgets.h"

UIDialog* CreateDialog(int size, UIDialog *parent)
{
	UIDialog *dialog;

	if((dialog = (UIDialog *)malloc(size)) == NULL)
		return NULL;

	dialog->window = NULL;
	dialog->parent = (void *)parent;

	dialog->size = size;

	return dialog;
}

void DisposeDialog(UIDialog *dialog)
{
	if(dialog != NULL)
		free(dialog);
}

void ShowDialog(UIDialog *dialog, gchar *def_widget_name)
{
	if(dialog->parent != NULL){
		gtk_window_set_transient_for(GTK_WINDOW(dialog->window), GTK_WINDOW(dialog->parent->window));
		if(def_widget_name){
			GtkWidget *widget;
			if(strcmp(def_widget_name, "MainOK_button") == 0)
				widget = getWidget(dialog->parent->parent->window, def_widget_name);
			else
				widget = getWidget(dialog->parent->window, def_widget_name);
			if(widget != NULL){
				gtk_widget_grab_focus(widget);
				gtk_widget_grab_default(widget);
			}
		}
	}
	gtk_widget_show(dialog->window);
	gtk_main();
}

void HideDialog(UIDialog *dialog)
{
	GtkWidget *top;
	if(dialog == NULL)
		return;
	top = gtk_widget_get_toplevel(dialog->window);
	gtk_widget_hide(top);
	gtk_main_quit();
}



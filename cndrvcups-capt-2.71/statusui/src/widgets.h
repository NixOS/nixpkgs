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


#ifndef _WIDGETS
#define	_WIDGETS

#include "dialog.h"

void SigInit(void);
gboolean SigEnable(void);
gboolean SigDisable(void);
GtkWidget* getWidget(GtkWidget *window, char* const name);
void SetDialogTitle(GtkWidget *window, gchar *title);
void SetWidgetSensitive(GtkWidget *window, gchar* const widgetname, gboolean value);
void SetActiveCheckButton(GtkWidget *window, gchar *button_name, gboolean on);
void SetTextEntry(GtkWidget *window, gchar *entry_name, gchar *text);
int StateWidgets(long job_num);
void WidgetIteration(void);
void ShowWidget(GtkWidget *window, gchar* const widget_name);
void HideWidget(GtkWidget *window, gchar* const widget_name);
void SetTextToLabel(GtkWidget *window, gchar *label_name, gchar *text);
void SetButtonLabel(GtkWidget *window, gchar *button_name, gchar *text);
void SetSpinButtonFloat(GtkWidget *window, gchar *spinbutton_name, gfloat value);

gint GetSpinButtonValue(GtkWidget *window, gchar *spinbutton_name, int value);
gboolean GetToggleButtonActive(GtkWidget *window, gchar *button_name);

void ComboSignalConnect(GtkWidget *window, gchar *combo_name, GtkSignalFunc sig_func);
gchar* GetTextEntry(GtkWidget *window, char *entry_name);
gchar* GetCurrComboText(GtkWidget *window, gchar *combo_entry_name);
void SetGListToCombo(GtkWidget *window, GList *glist, gchar *combo_name, gchar *curr_name);

void SetSpinButtonShort(GtkWidget *window, gchar *spinbutton_name, gshort value);
void SetTextToTextView(GtkWidget *window, gchar *entry_name, gchar *string);
void SetFocus(GtkWidget *window, gchar *widget_name);
void GetWindowPositionAndSize(GtkWidget *window, gint *x, gint *y, gint *w, gint *h);
void GetScreenSize(GtkWidget *window, gint *w, gint *h);
void WindowMove(GtkWidget *window, gint x, gint y);

#endif


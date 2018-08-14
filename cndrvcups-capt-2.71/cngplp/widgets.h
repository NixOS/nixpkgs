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


#ifndef _WIDGETS
#define _WIDGETS

#include <gtk/gtk.h>
#include <glade/glade.h>
#include "cngplpmodIF.h"
#include "controller.h"
#include "localize.h"

#ifdef __cplusplus
extern "C" {
#endif

extern GtkWidget* g_main_dlg;

void SigInit(void);
gboolean SigEnable(void);
gboolean SigDisable(void);
char* GetCurrOpt(cngplpData* data, const int id, const char *in);
char* GetOptionList(cngplpData* data, const int id);
void UpdateDataCheck(const int id, const int active);
void SetGladeXML(GladeXML* my_xml);
void SetData(cngplpData* my_data);
void UpdateData(int id, const char *value);
void UpdateDataCombo(const int id, const char *combo_entry_name);
void UpdateCpcaComboWidget(const int id, const char *combo_name);
const gchar* GetTextEntry(const char *entry_name);
void SetTextEntry(const gchar *entry_name, const gchar *text);
gchar* GetTextofTextView(const char *text_view_name);
void SetTextofTextView(const char *text_view_name, const gchar *text, const int length);
void SetTextview(const WidgetInfo* widget_info);
void SavePrinterData();
FuncInfo *FindKeyInfoBasedID(ConfigFile* config, int id);
void ShowDialog(const char *dialog, int print);
PropInfo *FindProperty(PropInfo *prop_list, const char *name);
char* GetCNUIValue(char *key);
void SetMainDlgInfo(GtkWidget* main_dlg, const char* main_dlg_name);
double GetCurrOptDouble(int id, double def);
void SetActiveCheckButton(const gchar *widget_name, gboolean on);
void UpdateDataDouble(int id, double value);
gfloat GetSpinButtonValue(const gchar *spin_button_name);
void SetCursolPosition(const gchar *entry_name, const gint position);
int GetCharSet(void);
void SetTextMaxLength(const gchar *entry_name, const gint max_num);
void SetEntryVisibility(const gchar *entry_name);
void UpdateAllPPDWidgets(char *id_list);
void UpdatePropGeneralWidgets(const int id);
void SetWidgetSensitive(const gchar *widget_name, gboolean value);
void memFree(void *pointer);
int GetCurrOptInt(int id, int def);
void UpdateDataInt(int id, int value);
void HideDialog(const char *dlg_name, const gboolean flag);
void RestoreDefault();
void SetTextToLabel(const gchar *label_name, const gchar *text);
void SetButtonLabel(const gchar *button_name, const gchar *text);
void SetActiveRadioButton(const gchar *button_name[], int set_index);
gboolean FindKey(const KeyInfo *key, cngplpData *data);
#define EUC 	1
#define UTF8 	2
#if 0
GList *GetGList(cngplpData* data, int id);
gchar* GetCurrComboText(gchar *combo_entry_name);
void ShowFunctionWidget(const FuncInfo *funclist);
#endif

#ifdef __cplusplus
}
#endif

#endif

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


#include <locale.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <strings.h>
#include "widgets.h"
#include "ppdoptions.h"
#include "cupsoption.h"
#include "execjob.h"

#define MAXSIZE 256
#define NUMDATA 64

static int g_curr_signal;
void UpdateFunctionWidget(const ConflictInfo *conflict_list);
GtkWidget* g_main_dlg = NULL;
void SaveTopWidgetData(const char *dlg_name);
void UpdateTopWidget(const char* dlg_name);
void SetSpinButtonValue(const WidgetInfo* widget_info);
void SetEntryText(const WidgetInfo* widget_info);
void UpdateWidget(const int id, char *str);
void SetWidgetStatus(const WidgetInfo *widget_info);
int GetValue(int id, char *value, char *name);
int SetCpcaWidgetSensitive(const int id, const char *widget_name);
int GetCurrDisable(const int id, const char *in);

const gchar *g_orientation_button_name[] = {
	"Portrait_radiobutton",
	"Landscape_radiobutton",
	"ReverseLandscape_radiobutton",
	"ReversePortrait_radiobutton",
	NULL
};

void memFree(void *pointer)
{
	if(pointer != NULL){
		free(pointer);
	}
	pointer = NULL;
}

void SigInit(void)
{
	g_curr_signal = 0;
}

gboolean SigEnable(void)
{
	gboolean enable = TRUE;
	if(g_curr_signal > 0){
		g_curr_signal--;
		enable = FALSE;
	}
	return enable;
}

gboolean SigDisable(void)
{
	gboolean enable = TRUE;
	if(g_curr_signal > 0){
		enable = FALSE;
	}
	g_curr_signal++;
	return enable;
}

void SetCursolPosition(const gchar *entry_name, const gint position)
{
	GtkWidget *entry = NULL;

	entry = glade_xml_get_widget(g_cngplp_xml, entry_name);
	if(entry != NULL){
		if(-1 == position){
			const gint num = GTK_ENTRY(entry)->text_length;
			gtk_editable_set_position(GTK_EDITABLE(entry), num);
		}else{
			gtk_editable_delete_text(GTK_EDITABLE(entry), position, -1);
			gtk_editable_set_position(GTK_EDITABLE(entry), position);
		}
	}
}

int GetCharSet(void)
{
	char *lang = NULL;

	if((lang = getenv("LC_CTYPE")) == NULL)
		lang = getenv("LANG");
	if(lang != NULL){
		if(strncasecmp("ja", lang, 2) == 0){
#ifndef OLD_GTK
			return 2;
#endif
			char *tmp = lang;
			while(1){
				if(*tmp == '.'){
					tmp++;
					break;
				}
				if(*tmp == '\0'){
					return 0;
				}
				tmp++;
			}
			if(strncasecmp(tmp, "UTF-8", 5) == 0)
				return 2;
			else if(strncasecmp(tmp, "euc", 3) == 0)
				return 1;
		}
	}
	return 0;
}

void SetGListToCombo(const char *combo_widget, GList *glist, const gchar *curr_name)
{
	GtkWidget *entry = NULL, *combo = NULL;

	combo = glade_xml_get_widget(g_cngplp_xml,combo_widget);
	if(combo != NULL){
		entry = GTK_COMBO(combo)->entry;
	}

	if((glist != NULL) || (curr_name != NULL)){
		gtk_combo_set_popdown_strings(GTK_COMBO(combo), glist);
		gtk_entry_set_text(GTK_ENTRY(entry), curr_name);
	}
}

void SetWidgetSensitive(const gchar *widget_name, const gboolean value)
{
	GtkWidget *widget;
	if(widget_name != NULL){
		widget = glade_xml_get_widget(g_cngplp_xml, widget_name);
		if(widget != NULL){
			gtk_widget_set_sensitive(widget, value);
		}
	}
}

void GetOptToGList(const int id, const char *widget_name)
{
	GList *glist = NULL;
	char *list, *plist, value[MAXSIZE], *pvalue, *curr = NULL;
	const char *text = NULL;
	char tmp[MAXSIZE];
	char *str;
	const char *cur;

	list = cngplpGetData(g_cngplp_data,id);
	if(list == NULL){
		return;
	}
	plist = list;
	pvalue = value;

	while(1){
		if(*plist == '\0'){
			int disable;
			*pvalue = '\0';
			memset(tmp, 0, MAXSIZE);
			disable = GetValue(id, value, tmp);
			if(disable  == 0){
				text = NameToText(id, tmp);
				if(text != NULL){
					glist = g_list_append(glist, (char*)text);
				}else{
					str = strdup(tmp);
					glist = g_list_append(glist, str);
				}
			}
			break;
		}
		if(*plist == ','){
			int disable;
			*pvalue = '\0';
			memset(tmp, 0, MAXSIZE);
			disable = GetValue(id, value, tmp);
			if(disable  == 0){
				text = NameToText(id, tmp);
				if(text != NULL){
					glist = g_list_append(glist, (char*)text);
				}else{
					str = strdup(tmp);
					glist = g_list_append(glist, str);
				}
			}
			plist++;
			pvalue = value;
		}
		if(*plist == ':'){
			*pvalue = '\0';
			cur = NameToText(id, value);
			if(cur != NULL){
				curr = strdup(cur);
			}else{
				curr = strdup(value);
			}
			plist++;
			pvalue = value;
		}
		*pvalue = *plist;
		pvalue++;
		plist++;
	}
	SetGListToCombo(widget_name, glist,curr);
	if(glist == NULL){
		SetWidgetSensitive(widget_name, FALSE);
	}else{
		g_list_free(glist);
	}
	free(curr);
	free(list);
	return;
}

char* GetCurrOpt(cngplpData* data, const int id, const char *in)
{
	char *option = NULL, *popt, *plist;
	char *list, tmp[MAXSIZE];

	if(in == NULL){
		list = cngplpGetData(g_cngplp_data,id);
	}else{
		list = strdup(in);
	}
	if(list == NULL){
		return NULL;
	}
	popt = tmp;
	plist = list;
	while(1){
		if(*plist == '\0'){
			*popt = '\0';
			option = strdup(tmp);
			break;
		}
		if(*plist == ','){
			*popt = '\0';
			option = strdup(tmp);
			break;
		}
		if(*plist == ':'){
			*popt = '\0';
			option = strdup(tmp);
			break;
		}
		*popt = *plist;
		popt++;
		plist++;
	}
	free(list);
	return option;
}

int GetCurrOptInt(const int id, const int def)
{
	char *value;
	int num;

	value = GetCurrOpt(g_cngplp_data, id, NULL);
	if(value != NULL){
		num = atoi(value);
		memFree(value);
		return num;
	}else{
		return def;
	}
}

char *GetData(const int id)
{
	return GetOptionList(g_cngplp_data, id);
}

char *GetData2(const int id)
{
	return GetCurrOpt(g_cngplp_data, id, NULL);
}

int GetDataInt(const int id, const int def)
{
	return GetCurrOptInt(id, def);
}

double GetCurrOptDouble(const int id, const double def)
{
	char *value;
	double num;

	value = GetCurrOpt(g_cngplp_data, id, NULL);
	if(value != NULL){
		setlocale (LC_NUMERIC, "C");
		num = atof(value);
		setlocale (LC_NUMERIC, "");
		memFree(value);
		return num;
	}else{
		return def;
	}
}

int GetValue(int id, char *value, char *name)
{
	char tmp[MAXSIZE], *ptmp, *pvalue;
	int disable = 0;

	pvalue = value;
	ptmp = tmp;
	while(pvalue != NULL){
		if(*pvalue == '\0'){
			*ptmp = '\0';
			strcpy(name, tmp);
			break;
		}
		if(*pvalue == '<'){
			*ptmp = '\0';
			strcpy(name, tmp);
			pvalue++;
			ptmp = tmp;
		}
		if(*pvalue == '>'){
			*ptmp = '\0';
			disable = atoi(tmp);
			break;
		}
		*ptmp = *pvalue;
		ptmp++;
		pvalue++;
	}

	return disable;
}

char* GetCNUIValue(char *key)
{
	char *value = NULL;
	value = cngplpGetValue(g_cngplp_data, key);
	return value;
}

const gchar* GetTextEntry(const char *entry_name)
{
	GtkWidget *entry;

	entry = glade_xml_get_widget(g_cngplp_xml, entry_name);
	if(entry == NULL){
		return NULL;
	}
	return gtk_entry_get_text(GTK_ENTRY(entry));
}

void SetTextMaxLength(const gchar *entry_name, const gint max_num)
{
	GtkWidget *entry;

	entry = glade_xml_get_widget(g_cngplp_xml, entry_name);
	if(entry != NULL){
		gtk_entry_set_max_length(GTK_ENTRY(entry), (guint)max_num);
	}
}

void SetEntryVisibility(const gchar *entry_name)
{
	GtkWidget *entry;

	entry = glade_xml_get_widget(g_cngplp_xml, entry_name);
	if(entry != NULL){
		gtk_entry_set_visibility(GTK_ENTRY(entry), FALSE);
	}
}

PropInfo *FindProperty(PropInfo *prop_list, const char *name)
{
	PropInfo *property = prop_list;

	while(property != NULL){
		if(strcmp(property->prop_name, name) == 0){
			return property;
		}
		property = property->next;
	}
	return NULL;
}

FuncInfo *FindKeyInfoBasedID(ConfigFile* config, const int id)
{
	const char *key = GetModStringID(id);
	FuncInfo *func = NULL;
	KeyInfo *key_info = NULL;
	FuncInfo *findfunc = NULL;
	FuncInfo *curr = NULL;

	if(key == NULL){
		return NULL;
	}
	func = g_load_func;
	while(func != NULL){
		key_info = func->func_id;
		while(key_info != NULL){
			if(key_info->name != NULL){
				if(strcmp(key, key_info->name) == 0){
					if(NULL == findfunc){
						findfunc = (FuncInfo *)malloc(sizeof(FuncInfo));
						if(NULL == findfunc){
							return NULL;
						}
						memset(findfunc, 0, sizeof(FuncInfo));
						memcpy(findfunc, func, sizeof(FuncInfo));
						curr = findfunc;
						curr->next = NULL;
					}else{
						if(curr != NULL){
							while(curr->next != NULL){
								curr = curr->next;
							}
						}
						if(curr != NULL){
							curr->next = (FuncInfo *)malloc(sizeof(FuncInfo));
						}
						if(NULL == curr->next){
							return NULL;
						}
						memset(curr->next, 0, sizeof(FuncInfo));
						memcpy(curr->next, func, sizeof(FuncInfo));
						curr->next->next = NULL;
					}
				}
			}
			key_info = key_info->next;
		}
		func = func->next;
	}
	return findfunc;
}

void DealIDFunctions(const FuncInfo* func, int id)
{
	const char *key;
	KeyInfo *key_info = NULL;
	FuncInfo *findfunc = NULL;
	FuncInfo *curr = NULL;
	WidgetInfo* widget_info = NULL;

	if((ID_CNZFOLDING == id) || (ID_CNCFOLDING == id) || (ID_CNHALFFOLDING == id) || (ID_CNACCORDIONZFOLDING == id) || (ID_CNDOUBLEPARALLELFOLDING == id)){
		id = ID_CNFOLDSETTING;
	}
	if((ID_CNCFOLDSETTING == id) || (ID_CNHALFFOLDSETTING == id) || (ID_CNACCORDIONZFOLDSETTING == id) || (ID_CNDOUBLEPARALLELFOLDSETTING == id)){
		id = ID_CNFOLDDETAIL;
	}
	if((ID_CNVFOLDING == id) || (ID_CNVFOLDINGTRIMMING == id) || (ID_CNSADDLESTITCH == id) || (ID_CNTRIMMING == id)){
		id = ID_CNSADDLESETTING;
	}
	if((ID_DUPLEX == id) || (ID_BOOKLET == id)){
		id = ID_CNPRINTSTYLE;
	}
	if(ID_BOOKLET_DLG == id){
		return;
	}
	key = GetModStringID(id);

	if(key == NULL){
		return;
	}
	while(func != NULL){
		key_info = func->func_id;
		while(key_info != NULL){
			if(key_info->name != NULL){
				if(strcmp(key, key_info->name) == 0){
					if(findfunc == NULL){
						findfunc = (FuncInfo *)malloc(sizeof(FuncInfo));
						if(findfunc == NULL){
							return;
						}
						memset(findfunc, 0, sizeof(FuncInfo));
						memcpy(findfunc, func, sizeof(FuncInfo));
						curr = findfunc;
						curr->next = NULL;
					}else{
						if(curr != NULL){
							while(curr->next != NULL){
								curr = curr->next;
							}
						}
						if(curr != NULL){
							curr->next = (FuncInfo *)malloc(sizeof(FuncInfo));
						}
						if(curr->next == NULL){
							return;
						}
						memset(curr->next, 0, sizeof(FuncInfo));
						memcpy(curr->next, func, sizeof(FuncInfo));
						curr->next->next = NULL;
					}
				}
			}
			key_info = key_info->next;
		}
		func = func->next;
	}
	if(findfunc == NULL){
		return;
	}
	if(findfunc->next == NULL){
		widget_info = findfunc->widget_list;
		while(widget_info != NULL){
			if(widget_info->type != NULL){
				if(strcmp(widget_info->type, "combo") == 0){
					UpdateCpcaComboWidget(id, widget_info->name);
				}else if(strcmp(widget_info->type, "checkbutton") == 0){
					SetCpcaWidgetSensitive(id, widget_info->name);
				}else if(strcmp(widget_info->type, "radiobutton") == 0){
					int disable = GetCurrDisable(id, NULL);
					if(disable != -1){
						disable = (disable > 0) ? 0 : 1;
						SetWidgetSensitive(widget_info->name, disable);
					}
				}else if(strcmp(widget_info->type, "spinbutton") == 0){
					SetSpinButtonValue(widget_info);
				}else if(strcmp(widget_info->type, "entry") == 0){
					SetEntryText(widget_info);
				}else if(strcmp(widget_info->type, "textview") == 0){
					SetTextview(widget_info);
				}
			}
			if(widget_info->func != NULL){
				WidgetInformation *lib = g_widget_table;
				while(lib->widget_name != NULL){
					if(strcmp(widget_info->type, lib->widget_name) == 0){
						lib->SpecialFunction(g_cngplp_data, widget_info->name);
						break;
					}
					lib++;
				}
			}
			widget_info = widget_info->next;
		}
		if(findfunc->conflict_list != NULL){
			UpdateFunctionWidget(findfunc->conflict_list);
		}
		MemFree(findfunc);
	}else{
		while(findfunc != NULL){
			widget_info = findfunc->widget_list;
			char *plist;
			char *list = GetOptionList(g_cngplp_data, id);
			int disable = 0;
			plist = strstr(list, findfunc->func_id->value);
			if(plist != NULL){
				char *ptr;
				ptr = strchr(plist, '<');
				if(ptr != NULL){
					ptr++;
					disable = atoi(ptr);
				}
			}
			MemFree(list);
			disable = (disable > 0) ? 0 : 1;
			SetWidgetSensitive(widget_info->name, disable);
			if(findfunc->conflict_list != NULL){
				UpdateFunctionWidget(findfunc->conflict_list);
			}
			curr = findfunc;
			findfunc = findfunc->next;
			MemFree(curr);
		}
	}
	return;
}

void UpdateEntryWidget(const int id, const char *entry_name)
{
	const gchar *text;
	text = GetTextEntry(entry_name);
	if((text != NULL) && (strcmp(text, "")) != 0){
		cngplpSetData(g_cngplp_data, id, (char*)text);
	}
}

void UpdateCpcaComboWidget(const int id, const char *combo_name)
{
	GetOptToGList(id, combo_name);
}

void UpdateData(const int id, const char *value)
{
	char *text;

	text = cngplpSetData(g_cngplp_data, id, (char*)value);
	UpdateWidget(id, text);
}

void UpdateDataDouble(const int id, const double value)
{
	char *text;
	char str[NUMDATA];
	memset(str, 0, NUMDATA - 1);
	snprintf(str, NUMDATA - 1, "%f", value);
	text = cngplpSetData(g_cngplp_data, id, str);
	UpdateWidget(id, text);
}

void UpdateDataInt(const int id, const int value)
{
	char *text;
	char str[NUMDATA];
	memset(str, 0, NUMDATA - 1);
	snprintf(str, NUMDATA - 1, "%d", value);
	text = cngplpSetData(g_cngplp_data, id, str);
	UpdateWidget(id, text);
}

void UpdateDataCombo(const int id, const char *combo_entry_name)
{
	char *text;
	char *str;
	char *tmp;
	GtkWidget *entry = NULL;
	entry = glade_xml_get_widget(g_cngplp_xml, combo_entry_name);
	if(entry != NULL){
		tmp =(gchar*)gtk_entry_get_text(GTK_ENTRY(entry));
		str = TextToName(id, tmp);
		if(str == NULL){
			str = tmp;
		}
		text = cngplpSetData(g_cngplp_data, id, str);
		UpdateWidget(id, text);
	}
}

int GetActive(const int id, const char *list)
{
	char *active;
	int ret = 0;
	active = GetCurrOpt(g_cngplp_data, id, list);
	if(active != NULL){
		if((strcasecmp(active, "False") == 0)
		|| (strcasecmp(active, "None") == 0)){
			ret = 0;
		}else if(strcasecmp(active, "True") == 0){
			ret = 1;
		}
		free(active);
	}
	return ret;
}
int GetCurrDisable(const int id, const char *in)
{
	char *list, *plist;
	char *tmp;
	int disable = 0;

	if(in == NULL){
		list = cngplpGetData(g_cngplp_data,id);
	}else{
		list = strdup(in);
	}
	if(list == NULL){
		return -1;
	}
	plist = list;
	while(1){
		tmp = strchr(plist, '<');
		if(tmp == NULL){
			break;
		}else{
			tmp++;
			disable += atoi(tmp);
			plist = tmp;
		}
	}
	free(list);
	return disable;
}
void SetActiveCheckButton(const gchar *widget_name, const gboolean on)
{
	GtkWidget *button;
	button = glade_xml_get_widget(g_cngplp_xml, widget_name);
	if(button != NULL){
		gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(button), on);
	}
}

void SetActiveRadioButton(const gchar *button_name[], const int set_index)
{
	const GtkWidget *button = glade_xml_get_widget(g_cngplp_xml,(char *)button_name[set_index]);

	if(button != NULL){
		gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(button), 1);
	}
}

void HideWidget(const gchar *widget_name)
{
	GtkWidget *widget;

	widget = glade_xml_get_widget(g_cngplp_xml, widget_name);
	if(widget != NULL){
		gtk_widget_hide(widget);
	}
}

void ShowWidget(const gchar *widget_name)
{
	GtkWidget *widget;

	if(widget_name == NULL){
		return;
	}
	widget = glade_xml_get_widget(g_cngplp_xml, widget_name);
	if(widget != NULL){
		gtk_widget_show(widget);
	}
}

void ChangeShowPage(const int page_index)
{
	GtkWidget *widget;
	SpecialInfo* special = NULL;

	if(g_config_file_data != NULL){
		special = g_config_file_data->special_list;
	}
	while(special != NULL){
		if(0 == special->type){
			widget = glade_xml_get_widget(g_cngplp_xml, special->name);
			if(widget != NULL){
				gtk_notebook_set_page(GTK_NOTEBOOK(widget), page_index);
			}
			break;
		}
		special = special->next;
	}
}

void SetSpinButton(const gchar *spin_name, gint value)
{
	GtkWidget *spin;
	spin = glade_xml_get_widget(g_cngplp_xml, spin_name);
	if(spin != NULL){
		gtk_spin_button_set_value(GTK_SPIN_BUTTON(spin), value);
	}
}

void SetSpinButtonValue(const WidgetInfo* widget_info)
{
	double value = 0.0;
	PropInfo *property = NULL;
	GtkWidget *spin = NULL;
	double def_double = 0;
	int id  = -1;

	if(widget_info != NULL){
		property = FindProperty(widget_info->prop_list, "text");
	}
	if(property != NULL){
		def_double = atof(property->def);
		id = GetModID(property->id);
		value = GetCurrOptDouble(id, def_double);

		spin = glade_xml_get_widget(g_cngplp_xml, widget_info->name);
		if(NULL == spin){
			return;
		}
		gtk_spin_button_set_value(GTK_SPIN_BUTTON(spin), value);
	}
}

void SetTextToLabel(const gchar *label_name, const gchar *text)
{
	GtkWidget *label;
	label = glade_xml_get_widget(g_cngplp_xml, label_name);
	if(label != NULL){
		gtk_label_set_text(GTK_LABEL(label), text);
	}
}

int IsUS(void)
{
	if((g_cngplp_data != NULL) && (g_cngplp_data->ppd_opt != NULL)){
		return g_cngplp_data->ppd_opt->us_type;
	}
	return 0;
}

int SetCpcaWidgetSensitive(const int id, const char *widget_name)
{
	char *list;
	int disable;

	list = cngplpGetData(g_cngplp_data,id);
	if(list == NULL){
		return 0;
	}
	disable = GetCurrDisable(id, list);

	if(disable != -1){
		int active;
		disable = (disable > 0) ? 0 : 1;
		active = GetActive(id, list);
		if(active > -1){
			SetActiveCheckButton(widget_name, active);
		}
		SetWidgetSensitive(widget_name, disable);
	}
	free(list);
	return disable;
}

void UpdatePropPPDWidgets(const int id)
{
	if(id == -1){
		return;
	}
	DealIDFunctions(g_load_func, id);
}

void FindUpdateWidget(char *str)
{
	char id[MAXSIZE], *ptr, *tmp;

	ptr = id;
	tmp = str;
	while(1){
		if(tmp != NULL){
			if(((*tmp) == '\0') || ((*tmp) == '\n')){
				*ptr = '\0';
				UpdatePropPPDWidgets(atoi(id));
				break;
			}
			if(*tmp == ','){
				*ptr = '\0';
				tmp++;
				UpdatePropPPDWidgets(atoi(id));
				ptr = id;
			}
			*ptr = *tmp;
			ptr++;
			tmp++;
		}
	}
}

void UpdateAllPPDWidgets(char *id_list)
{
	FindUpdateWidget(id_list);
}

void UpdatePropGeneralWidgets(const int id)
{
	int num = id;

	if(num == 0){
		GetOptToGList(ID_PAGESIZE, "PaperSize_combo");
		num = ID_PAGESIZE;
	}

	if(num == ID_PAGESIZE){
		int sel;
		sel = GetCurrOptInt(ID_ORIENTATION_REQUESTED, 3) - 3;
		SetActiveRadioButton(g_orientation_button_name, sel);
	}

	if(num == ID_PAGESIZE){
		GetOptToGList(ID_NUMBER_UP, "Nup_combo");
	}

	if(num == ID_PAGESIZE || num == ID_BRIGHTNESS){
		int value;
		value = GetCurrOptInt(ID_BRIGHTNESS, 100);
		if(num != ID_BRIGHTNESS){
			SetSpinButton("Brightness_spinbutton", value);
		}
	}

	if(num == ID_PAGESIZE || num == ID_GAMMA){
		int value;
		value = GetCurrOptInt(ID_GAMMA, 1000);
		if(num != ID_GAMMA){
			SetSpinButton("Gamma_spinbutton", value);
		}
	}

	if(num == ID_PAGESIZE){
		GetOptToGList(ID_JOB_SHEETS_START, "BannerStart_combo");
		GetOptToGList(ID_JOB_SHEETS_END, "BannerEnd_combo");
	}
}

void UpdateWidget(const int id, char *str)
{
	if(str == NULL){
		return;
	}
	if(strcmp(str, "NoChange") == 0){
		return;
	}

	if(id == ID_PAGESIZE){
		char *id_list = cngplpGetData(g_cngplp_data, ID_PPD_OPTION);
		UpdatePropGeneralWidgets(ID_PAGESIZE);
		UpdateAllPPDWidgets(id_list);
	}else if(str != NULL){
		FindUpdateWidget(str);
	}
}

void UpdateDataCheck(const int id, const int active)
{
	char *text;
	char *str;

	str = (active != 0) ? "true" : "false";
	text = cngplpSetData(g_cngplp_data, id, str);
	UpdateWidget(id, text);
}

void SetTextEntry(const gchar *entry_name, const gchar *text)
{
	GtkWidget *entry;

	entry = glade_xml_get_widget(g_cngplp_xml, entry_name);
	if(entry != NULL){
		gtk_entry_set_text(GTK_ENTRY(entry), text);
	}
}

void SetEntryText(const WidgetInfo* widget_info)
{
	char *text = NULL;
	PropInfo *property = NULL;
	int id = -1;

	if(widget_info != NULL){
		property = FindProperty(widget_info->prop_list, "text");
	}
	if(property != NULL){
		id = GetModID(property->id);
		if(id != -1){
			text = GetOptionList(g_cngplp_data, id);
			if(text != NULL){
				SetTextEntry(widget_info->name, text);
				memFree(text);
			}
		}
	}
}

void SetTextview(const WidgetInfo* widget_info)
{
	char *text = NULL;
	PropInfo *property = NULL;
	int id = -1;

	if(widget_info != NULL){
		property = FindProperty(widget_info->prop_list, "text");
	}
	if(property != NULL){
		id = GetModID(property->id);
		if(id != -1){
			text = GetOptionList(g_cngplp_data, id);
			if(text != NULL){
				SetTextofTextView(widget_info->name, text, -1);
				memFree(text);
			}
		}
	}
}

void SetButtonLabel(const gchar *button_name, const gchar *text)
{
	GtkWidget *button;
	button = glade_xml_get_widget(g_cngplp_xml, button_name);
	if(button != NULL){
#ifdef OLD_GTK
		gtk_label_set_text(GTK_LABEL(GTK_BUTTON(button)->child), text);
#else
		gtk_button_set_label(GTK_BUTTON(button), text);
#endif
	}
}

gfloat GetSpinButtonValue(const gchar *spin_button_name)
{
	GtkWidget *spin_button;

	spin_button = glade_xml_get_widget(g_cngplp_xml, spin_button_name);
	if(spin_button == NULL){
		return -1;
	}
	return gtk_spin_button_get_value_as_float(GTK_SPIN_BUTTON(spin_button));
}

gchar* GetTextofTextView(const char *text_view_name)
{
	GtkTextView *text_view = NULL;
	GtkTextBuffer *text_buffer = NULL;
	GtkTextIter start_item, end_item;
	GtkWidget *widget = NULL;

	widget = glade_xml_get_widget(g_cngplp_xml, text_view_name);
	if(widget != NULL){
		text_view = GTK_TEXT_VIEW(widget);
		text_buffer = gtk_text_view_get_buffer(text_view);
		gtk_text_buffer_get_start_iter(text_buffer, &start_item);
		gtk_text_buffer_get_end_iter(text_buffer, &end_item);
		return (gchar*)gtk_text_buffer_get_text(text_buffer, &start_item, &end_item, FALSE);
	}
	return NULL;
}

void SetTextofTextView(const char *text_view_name, const gchar *text, const int length)
{
	GtkTextView *text_view = NULL;
	GtkTextBuffer *text_buffer = NULL;
	GtkWidget *widget = NULL;

	widget = glade_xml_get_widget(g_cngplp_xml, text_view_name);
	if(widget != NULL){
		text_view = GTK_TEXT_VIEW(widget);
		text_buffer = gtk_text_view_get_buffer(text_view);
		gtk_text_buffer_set_text(text_buffer, text, length);
	}
}

char* GetOptionList(cngplpData *data, const int id)
{
	char *list;
	list = cngplpGetData(data, id);
	return list;
}

gboolean FindKey(const KeyInfo *key, cngplpData *data)
{
	char *opt = NULL;
	gboolean found = FALSE;
	if(NULL == key){
		return FALSE;
	}
	const int id = GetModID(key->name);
	if(ID_RESOLUTION == id){
		UIItemsList *item = NULL;
		if((g_cngplp_data != NULL) && (g_cngplp_data->ppd_opt != NULL)){
			item = FindItemsList(g_cngplp_data->ppd_opt->items_list, "Resolution");
		}
		if(item != NULL){
			if(item->num_options > 1){
				return TRUE;
			}else{
				return FALSE;
			}
		}
	}else if(ID_CNFOLDDETAIL == id){
		char *folddetail = NULL;

		opt = GetCurrOpt(data, ID_CNCFOLDING, NULL);
		if(NULL != opt){
			folddetail = GetCurrOpt(data, ID_CNCFOLDSETTING, NULL);
			if(NULL != folddetail){
				memFree(opt);
				memFree(folddetail);
				return TRUE;
			}
		}
		opt = GetCurrOpt(data, ID_CNHALFFOLDING, NULL);
		if(NULL != opt){
			folddetail = GetCurrOpt(data, ID_CNHALFFOLDSETTING, NULL);
			if(NULL != folddetail){
				memFree(opt);
				memFree(folddetail);
				return TRUE;
			}
		}
		opt = GetCurrOpt(data, ID_CNACCORDIONZFOLDING, NULL);
		if(NULL != opt){
			folddetail = GetCurrOpt(data, ID_CNACCORDIONZFOLDSETTING, NULL);
			if(NULL != folddetail){
				memFree(opt);
				memFree(folddetail);
				return TRUE;
			}
		}
		opt = GetCurrOpt(data, ID_CNDOUBLEPARALLELFOLDING, NULL);
		if(NULL != opt){
			folddetail = GetCurrOpt(data, ID_CNDOUBLEPARALLELFOLDING, NULL);
			if(NULL != folddetail){
				memFree(opt);
				memFree(folddetail);
				return TRUE;
			}
		}
	}else{
		if(IDtoPPDOption(id - 1) != NULL){
			opt = GetCurrOpt(data, id, NULL);
		}else{
			opt = GetOptionList(data, id);
		}
	}
	if(NULL == opt){
		opt = GetCNUIValue(key->name);
		if(NULL == opt){
			return FALSE;
		}
	}

	if(NULL == key->value){
		found = TRUE;
	}else{
		if(NULL != key->type){
		 	if(0 == strcmp(key->type, "no")){
				if(strcmp(key->value, opt) != 0){
					found = TRUE;
				}
			}else if(0 == strcmp(key->type, "include")){
				MemFree(opt);
				opt = GetOptionList(data, id);
				if((opt != NULL) && (strstr(opt, key->value) != NULL)){
					found = TRUE;
				}
			}else if(0 == strcmp(key->type, "other")){
				int i = 0, j = 0, k = 0;
				char *option = NULL;
				UIItemsList *item = NULL;
				char *plist = NULL;
				char *list = key->value;

				plist = list;
				option = IDtoPPDOption(id -1);
				if((g_cngplp_data != NULL) && (g_cngplp_data->ppd_opt != NULL)){
					item = FindItemsList(g_cngplp_data->ppd_opt->items_list, option);
				}
				while(1){
					if(*plist == '\0'){
						i++;
						break;
					}
					if(*plist == ','){
						i++;
					}
					plist++;
				}
				if(item != NULL){
					UIOptionList *tmp = item->opt_lists;
					while(tmp != NULL){
						if(strstr(list, tmp->name) != NULL){
							j++;
							k++;
						}
						tmp = tmp->next;
					}
					if((i == j) && (i == k)){
						found = FALSE;
					}else{
						found = TRUE;
					}
				}
			}
		}else{
			if(0 == strcmp(key->value, opt)){
				found  = TRUE;
			}
		}
	}
	if(opt != NULL){
		free(opt);
		opt = NULL;
	}
	return found;
}

void ShowDialog(const char *dialog, const int print)
{
	GtkWidget *widget = NULL, *parent = NULL;
	char *str = NULL;
	SpecialInfo* special = NULL;
	char* printer_name = NULL;
	widget = glade_xml_get_widget(g_cngplp_xml, dialog);
	if(NULL == widget){
		return;
	}
	SigDisable();
	if(g_config_file_data != NULL){
		special = g_config_file_data->special_list;
	}
	while(special != NULL){
		if((1 == special->type) && (0 == strcasecmp(special->name, dialog))){
			special->print = print;
			if(special->parent != NULL){
				if(0 == strcasecmp(special->parent, g_main_dlg_name)){
					str = cngplpGetData(g_cngplp_data, ID_PPD_OPTION);
					UpdateAllPPDWidgets(str);
					memFree(str);
					printer_name = GetCurrOpt(g_cngplp_data, ID_PRINTERNAME, NULL);
					gtk_window_set_title(GTK_WINDOW(widget), printer_name);
					memFree(printer_name);
					if(g_main_dlg != NULL){
						gtk_window_set_transient_for(GTK_WINDOW(widget), GTK_WINDOW(g_main_dlg));
					}
					ChangeShowPage(0);
				}else{
					UpdateTopWidget(dialog);
					parent = glade_xml_get_widget(g_cngplp_xml, special->parent);
					if(parent != NULL){
						gtk_window_set_transient_for(GTK_WINDOW(widget), GTK_WINDOW(parent));
					}
					if((NULL == parent) && (g_main_dlg != NULL)){
						gtk_window_set_transient_for(GTK_WINDOW(widget), GTK_WINDOW(g_main_dlg));
					}
				}
			}
			if(!special->print){
				if(special->conflict_list != NULL){
					UpdateFunctionWidget(special->conflict_list);
				}
			}
			SaveTopWidgetData(dialog);
			gtk_widget_show(widget);
			break;
		}
		special = special->next;
	}
	SigEnable();
	gtk_main();
}

void UpdateFunctionWidget(const ConflictInfo *conflict_list)
{
	GtkWidget *widget;
	const ConflictInfo *conflict = conflict_list;
	int id;
	char *curr = NULL;

	while(conflict != NULL){
		char *type = conflict->type;
		WidgetInfo *update = conflict->update_list;
		if((conflict_list != NULL) && (conflict_list->widget != NULL)){
			gboolean active;
			widget = glade_xml_get_widget(g_cngplp_xml, conflict_list->widget);
			active = gtk_toggle_button_get_active(GTK_TOGGLE_BUTTON(widget));
			if(active == TRUE){
				if(strcasecmp(conflict->value, "True") == 0){
					while(update != NULL){
						SetWidgetStatus(update);
						update = update->next;
					}
				}
			}else{
				if(strcasecmp(conflict->value, "False") == 0){
					while(update != NULL){
						SetWidgetStatus(update);
						update = update->next;
					}
				}
			}
		}else{
			id = GetModID(conflict->id);
			curr = GetCurrOpt(g_cngplp_data, id, NULL);
			if(NULL != curr){
				if(type != NULL){
					if(conflict->value != NULL){
						if((strcasecmp(conflict->value, curr) != 0) && (strcasecmp(type, "no") == 0)){
							while(update != NULL){
								SetWidgetStatus(update);
								update = update->next;
							}
						}
					}
				}else if(conflict->value != NULL){
					if(strcasecmp(conflict->value, curr) == 0){
						while(update != NULL){
							SetWidgetStatus(update);
							update = update->next;
						}
					}
				}else{
					while(update != NULL){
						SetWidgetStatus(update);
						update = update->next;
					}
				}
			}else{
				if(type != NULL){
					if((NULL == conflict->value) && (0 == strcasecmp(type, "no"))){
						while(update != NULL){
							SetWidgetStatus(update);
							update = update->next;
						}
					}
				}
			}
			memFree(curr);
		}
		conflict = conflict->next;
	}
}

void SetWidgetStatus(const WidgetInfo *widget_info)
{
	GtkWidget *widget = NULL;
	gboolean value = TRUE;
	PropInfo *property = NULL;
	char *type = NULL;
	int id;

	if(widget_info != NULL){
		widget = glade_xml_get_widget(g_cngplp_xml, widget_info->name);
		property = widget_info->prop_list;
		type = widget_info->type;
	}

	while(property != NULL){
		if(property->value != NULL){
			if(strcmp(property->value, "False") == 0){
				value = FALSE;
			}
			if(strcmp(property->value, "True") == 0){
				value = TRUE;
			}
		}
		if(strcmp(property->prop_name, "sensitive") == 0){
			gtk_widget_set_sensitive(widget, value);
		}
		if(strcmp(property->prop_name, "toggled") == 0){
			gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(widget), value);
		}
		if(strcmp(property->prop_name, "visible") == 0){
			if(strcmp(property->value, "True") == 0){
				gtk_widget_show(widget);
			}
			if(strcmp(property->value, "False") == 0){
				gtk_widget_hide(widget);
			}
		}
		if(strcmp(property->prop_name, "text") == 0){
			if(strcmp(type, "entry") == 0){
				gtk_entry_set_text(GTK_ENTRY(widget), property->value);
			}
			if(strcmp(type, "label") == 0){
				const char *text = NULL;
				text = NameToTextByName(property->res);
				if(text != NULL){
					SetTextToLabel(widget_info->name, text);
				}
			}
		}
		if(strcmp(property->prop_name, "update") == 0){
			if(strcmp(type, "combo") == 0){
				id = GetModID(property->id);
				UpdateCpcaComboWidget(id, widget_info->name);
			}
			if(strcmp(type, "entry") == 0){
				id = GetModID(property->id);
				UpdateEntryWidget(id, widget_info->name);
			}
			if(strcmp(type, "checkbutton") == 0){
				id = GetModID(property->id);
				SetCpcaWidgetSensitive(id, widget_info->name);
			}
		}
		property = property->next;
	}
}

void SaveTopWidgetData(const char *dlg_name)
{
	const int top_widget_num = g_list_length(g_topwidget_list);
	int i = 0;
	TopWidget* top_widget = NULL, *found = NULL;
	char *option = NULL;
	UIItemsList *tmp;
	const PPDOptions *ppd_opt = NULL;
	if(g_cngplp_data != NULL){
		ppd_opt = g_cngplp_data->ppd_opt;
	}

	for(; i < top_widget_num; i++){
		top_widget = (TopWidget*)g_list_nth_data(g_topwidget_list, i);
		if(top_widget != NULL){
			if(!strcmp(dlg_name, top_widget->name)){
				found = top_widget;
				break;
			}
		}
	}
	i = 0;
	if(found != NULL){
		const int len = g_list_length(found->save_data);
		TopWidgetSaveData* data = NULL;
		char *value;
		for(; i < len; i++){
			data = g_list_nth_data(found->save_data, i);
			if((data != NULL) && (data->key_value != NULL)){
				free(data->key_value);
				data->key_value = NULL;
			}
			if(data != NULL){
				option = IDtoPPDOption(data->id - 1);
			}
			if(NULL == option){
				if((ID_NUMBER_UP == data->id) || (ID_JOB_SHEETS_START == data->id) || (ID_JOB_SHEETS_END == data->id) || (ID_BOOKLET_DLG == data->id)){
					value = GetCurrOpt(g_cngplp_data, data->id, NULL);
				}else{
					value = GetOptionList(g_cngplp_data, data->id);
				}
				data->key_value = value;
			}else{
				tmp = ppd_opt->items_list;
				while(tmp->current_option != NULL){
					if(strcmp(option, tmp->name) == 0){
						data->key_value = strdup(tmp->current_option->name);
						break;
					}
					if(tmp->next == NULL){
						break;
					}
					tmp = tmp->next;
				}
			}
		}
	}
}

void RestoreTopWidgetData(const char *dlg_name)
{
	const int top_widget_num = g_list_length(g_topwidget_list);
	int i = 0;
	char *key = NULL;
	TopWidget* top_widget = NULL, *found = NULL;

	for(; i < top_widget_num; i++){
		top_widget = (TopWidget*)g_list_nth_data(g_topwidget_list, i);
		if(top_widget != NULL){
			if(strcmp(dlg_name, top_widget->name) == 0){
				found = top_widget;
				break;
			}
		}
	}
	i = 0;
	if(found != NULL){
		const int len = g_list_length(found->save_data);
		TopWidgetSaveData* data = NULL;
		for(; i < len; i++){
			data = g_list_nth_data(found->save_data, i);
			if((data != NULL) && (data->key_value != NULL)){
				if((ID_PPD_OPTION < (data->id)) && ((data->id) < ID_PPD_OPTION_BOTTOM)){
					key = cngplpIDtoKey(data->id);
					UpdatePPDDataForCancel(g_cngplp_data, key, data->key_value);
					MemFree(key);
				}else{
					if(ID_JOBACCOUNT == data->id){
						if(0 == strcmp(data->key_value, "1")){
							cngplpSetData(g_cngplp_data, data->id, "True");
						}else{
							cngplpSetData(g_cngplp_data, data->id, "False");
						}
					}else if(ID_SELECTBY == data->id){
						if((g_cngplp_data != NULL) && (g_cngplp_data->ppd_opt != NULL)){
							g_cngplp_data->ppd_opt->selectby = atoi(data->key_value);
						}
					}else if(ID_BOOKLET_DLG == data->id){
						UpdatePPDDataForCancel(g_cngplp_data, "Booklet", data->key_value);
					}else{
						cngplpSetData(g_cngplp_data, data->id, data->key_value);
					}
				}
			}
		}
		if((g_cngplp_data != NULL) && (g_cngplp_data->ppd_opt != NULL) && (g_cngplp_data->ppd_opt->multipunch != NULL)){
			memset(g_cngplp_data->ppd_opt->multipunch, '\0', 16);
		}
		RemarkOptValue(g_cngplp_data, "BindEdge");
		RemarkOptValue(g_cngplp_data, "");
	}
}

void RestoreDefault()
{
	cngplpData *data = g_cngplp_data;
	char *str = NULL;
	UIItemsList *tmp = NULL;
	if((data != NULL) && (data->ppd_opt != NULL)){
		tmp = data->ppd_opt->items_list;
	}else{
		return;
	}

	data->ppd_opt->gutter_value = 0;
	data->ppd_opt->gutter_value_d = 0.0;
	data->ppd_opt->startnum_value = 1;

	data->ppd_opt->guttershiftnum_value_d = 0.0;
	data->ppd_opt->tab_shift = 12.7;
	data->ppd_opt->ins_tab_shift = 12.7;
	InitAdjustTrimm(data->ppd_opt);
	data->ppd_opt->stack_copies_num = 1;
	data->ppd_opt->shift_right = 0;
	data->ppd_opt->detail_shift_right = 0.0;
	data->ppd_opt->shift_upwards = 0;
	data->ppd_opt->detail_shift_upwards = 0.0;
	data->ppd_opt->shift_front_long = 0;
	data->ppd_opt->shift_front_short = 0;
	data->ppd_opt->shift_back_long = 0;
	data->ppd_opt->shift_back_short = 0;
	data->ppd_opt->detail_shift_front_long = 0.0;
	data->ppd_opt->detail_shift_front_short = 0.0;
	data->ppd_opt->detail_shift_back_long = 0.0;
	data->ppd_opt->detail_shift_back_short = 0.0;
	data->ppd_opt->offset_num = 1;

	while(1){
		if(tmp->name != NULL){
			UpdatePPDDataForDefault(data, tmp->name);
		}
		if(tmp->next == NULL){
			break;
		}
		tmp = tmp->next;
	}

	ResetCupsOptions(data);
	RemarkOptValue(data, "BindEdge");
	RemarkOptValue(data, "");
	if(data->ppd_opt->selectby != 0){
		data->ppd_opt->selectby = SELECTBY_INPUTSLOT;
	}

	UpdatePropGeneralWidgets(ID_PAGESIZE);
	str = cngplpGetData(g_cngplp_data, ID_PPD_OPTION);
	UpdateAllPPDWidgets(str);
}

void FreeTopWidgetSaveData(const char *dlg_name)
{
	const int top_widget_num = g_list_length(g_topwidget_list);
	int i = 0;
	TopWidget* top_widget = NULL, *found = NULL;
	for(; i < top_widget_num; i++){
		top_widget = (TopWidget*)g_list_nth_data(g_topwidget_list, i);
		if((top_widget != NULL) && (top_widget->name != NULL)){
			if(!strcmp(dlg_name, top_widget->name)){
				found = top_widget;
				break;
			}
		}
	}
	i = 0;
	if(found != NULL){
		const int len = g_list_length(found->save_data);
		TopWidgetSaveData* data = NULL;
		for(; i < len; i++){
			data = g_list_nth_data(found->save_data, i);
			if((data != NULL) && (data->key_value != NULL)){
				free(data->key_value);
				data->key_value = NULL;
			}
		}
	}
}

void SavePrinterData()
{
	exec_lpr(g_cngplp_data, 0);
}

void PrintFile()
{
	exec_lpr(g_cngplp_data, 1);
}

void HideDialog(const char *dlg_name, const gboolean flag)
{
	GtkWidget *widget;
	GtkWidget *top;
	char *text;
	SpecialInfo* special = NULL;

	if(g_config_file_data != NULL){
		special = g_config_file_data->special_list;
	}
	while(special != NULL){
		if(0 == strcasecmp(special->name, dlg_name)){
			break;
		}
		special = special->next;
	}
	widget = glade_xml_get_widget(g_cngplp_xml, dlg_name);
	if(NULL == widget){
		return;
	}
	InitUpdateOption(g_cngplp_data);
	if(FALSE == flag){
		special->print = 0;
		RestoreTopWidgetData(dlg_name);
	}else{
		if(special->print == 1){
			if(0 == strcasecmp(dlg_name, "IdPassWdDlg")){
				const char *ps = NULL;
				const char *usr = NULL;

				ps = GetTextEntry("PassWd_entry");
				usr = GetTextEntry("ID_entry");
				if((0 == (strlen(ps))) || (0 == (strlen(usr)))){
					return;
				}
			}
			if(0 == strcasecmp(dlg_name, "JobAccountDlg")){
				const char *jobusr = NULL;
				jobusr = GetTextEntry("JobAccountID_entry");
				if(0 == strlen(jobusr)){
					return;
				}
			}
		}
	}
	FreeTopWidgetSaveData(dlg_name);
	text = ExitUpdateOption(g_cngplp_data);
	UpdateWidget(ID_CNSKIPBLANK, text);

	top = gtk_widget_get_toplevel(widget);
	gtk_widget_hide(top);
	gtk_main_quit();
}

void SetMainDlgInfo(GtkWidget* main_dlg, const char* main_dlg_name)
{
	g_main_dlg = main_dlg;
	g_main_dlg_name = main_dlg_name;
}

void UpdateTopWidget(const char* dlg_name)
{
	const int top_widget_num = g_list_length(g_topwidget_list);
	int i = 0;
	TopWidget* top_widget = NULL, *found = NULL;

	for(; i < top_widget_num; i++){
		top_widget = (TopWidget*)g_list_nth_data(g_topwidget_list, i);
		if((top_widget != NULL) && (top_widget->name != NULL)){
			if(strcmp(dlg_name, top_widget->name) == 0){
				found = top_widget;
				break;
			}
		}
	}
	i = 0;
	if(found != NULL){
		const int len = g_list_length(found->save_data);
		TopWidgetSaveData* data = NULL;
		for(; i < len; i++){
				data = g_list_nth_data(found->save_data, i);
				if(data != NULL){
					UpdatePropPPDWidgets(data->id);
				}
		}
	}
}

int ExecJobMode()
{
	char *job;
	int print = 1;
	SpecialInfo* special = NULL;

	if(g_config_file_data != NULL){
		special = g_config_file_data->special_list;
	}
	job = GetCurrOpt(g_cngplp_data, ID_CNJOBEXECMODE, NULL);
	if(job != NULL){
		if(strcmp(job, "print") == 0){
			print = 1;
		}else if(strcmp(job, "store") == 0){
			print = 1;
		}else if(strcmp(job, "secured") == 0){
			if((g_cngplp_data != NULL) && (NULL == g_cngplp_data->file_name)){
				HideWidget("DocName_label");
				HideWidget("DocName_entry");
			}else{
				char *file = NULL;

				file = GetOptionList(g_cngplp_data, ID_SECURED_DOCNAME);
				ShowWidget("DocName_label");
				ShowWidget("DocName_entry");
				if(file != NULL){
					SetTextEntry("DocName_entry", file);
					free(file);
				}
			}
			ShowDialog("IdPassWdDlg", 1);
			while(special != NULL){
				if(0 == strcasecmp(special->name, "IdPassWdDlg")){
					if(!special->print){
						memFree(job);
						return 0;
					}
					break;
				}
				special = special->next;
			}
		}else if(strcmp(job, "hold") == 0){
			print = 1;
		}
		memFree(job);
	}

	const int special_func = GetCurrOptInt(ID_SPECIAL_FUNC, 0);
	if(special_func != 0){
		int job_account;
		int active_job;
		int is_color = 0;
		char *active_color;
		job_account = GetCurrOptInt(ID_JOBACCOUNT, 0);
		if(job_account != 0){
			active_job = GetCurrOptInt(ID_DISABLE_JOBACCOUNT_BW, 0);
			active_color = GetCurrOpt(g_cngplp_data, ID_CNCOLORMODE, NULL);
			if(active_color != NULL){
				if(strcmp(active_color, "mono") != 0){
					is_color = 1;
				}
				memFree(active_color);
			}
			if(!((active_job == 1) && (is_color == 0))){
				ShowWidget("JobAccountPassWD_label");
				ShowWidget("JobAccountPassWD_entry");
				ShowDialog("JobAccountDlg", 1);
				while(special != NULL){
					if(0 == strcasecmp(special->name, "JobAccountDlg")){
						if(!special->print){
							return 0;
						}else{
							return 1;
						}
					}
					special = special->next;
				}
			}
		}
	}

	return print;
}

#if 0
GList *GetGList(cngplpData* data,const int id)
{
	GList *glist = NULL;
	char *list, *plist, value[MAXSIZE], *pvalue, *curr = NULL;
	const char *text = NULL;
	char tmp[MAXSIZE];
	char *str;
	const char *cur;

	list = cngplpGetData(g_cngplp_data,id);
	if(list == NULL){
		return NULL;
	}
	plist = list;
	pvalue = value;

	while(1){
		if(*plist == '\0'){
			int disable;
			*pvalue = '\0';
			memset(tmp, 0, MAXSIZE);
			disable = GetValue(id, value, tmp);
			if(disable == 0){
				text = NameToText(id, tmp);
				if(text != NULL){
					glist = g_list_append(glist, (char*)text);
				}else{
					str = strdup(tmp);
					glist = g_list_append(glist, str);
				}
			}
			break;
		}
		if(*plist == ','){
			int disable;
			*pvalue = '\0';
			memset(tmp, 0, MAXSIZE);
			disable = GetValue(id, value, tmp);
			if(disable == 0){
				text = NameToText(id, tmp);
				if(text != NULL){
					glist = g_list_append(glist, (char*)text);
				}else{
					str = strdup(tmp);
					glist = g_list_append(glist, str);
				}
			}
			plist++;
			pvalue = value;
		}
		if(*plist == ':'){
			*pvalue = '\0';
			cur = NameToText(id, value);
			if(cur != NULL){
				curr = strdup(cur);
			}else{
				curr = strdup(value);
			}
			plist++;
			pvalue = value;
		}
		*pvalue = *plist;
		pvalue++;
		plist++;
	}
	return glist;
}

void ConvPointToMM_Inch(int point, char *text, int locale)
{
	if(locale == 0){
		float inch;
		inch = (float)(point * (float)(0.014));
		snprintf(text, 127, "[point]    %.3f[inch]", inch);
	}else{
		float mm;
		mm = (float)(point * (float)(0.35));
		snprintf(text, 127, "[point]    %.2f[mm]", mm);
	}
}

gchar* GetCurrComboText(gchar *combo_entry_name)
{
	GtkWidget *entry;
	char *text = NULL;

	entry = glade_xml_get_widget(g_cngplp_xml, combo_entry_name);
	if(entry != NULL){
		text = (gchar*)gtk_entry_get_text(GTK_ENTRY(entry));
	}
	return text;
}

void ShowFunctionWidget(const FuncInfo *funclist)
{
	FuncInfo *func = funclist;
	ShowWidgetInfo* show_widgets = NULL;
	GtkWidget *widget = NULL;
	while(func != NULL){
		show_widgets = func->show_widget_list;
		while(show_widgets != NULL){
			widget = glade_xml_get_widget(g_cngplp_xml, show_widgets->name);
			gtk_widget_show(widget);
			show_widgets = show_widgets->next;
		}
		func = func->next;
	}
}

#endif

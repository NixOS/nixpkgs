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
#include <stdlib.h>
#include <gtk/gtk.h>
#include <string.h>
#include <libxml/parser.h>
#include "widgets.h"
#include "localize.h"
#include "cngplpmod.h"
#include "config.h"
#include "combo.h"
#include "checkbutton.h"
#include "dialog.h"
#include "radiobutton.h"
#include "button.h"
#include "spinbutton.h"
#include "entry.h"
#include "label.h"
#include "textview.h"

#define MAX_PATH 256
#ifdef __FOR_UFR2__
#define GLADE_FILE_NAME 	"cngplp_ufr2.glade"
#define CONFIG_FILE_NAME	"func_config_ufr2.xml"
#elif defined __FOR_LIPS__
#define GLADE_FILE_NAME 	"cngplp_lips.glade"
#define CONFIG_FILE_NAME 	"func_config_lips.xml"
#elif defined __FOR_CAPT__
#define GLADE_FILE_NAME 	"cngplp_capt.glade"
#define CONFIG_FILE_NAME 	"func_config_capt.xml"
#elif defined __FOR_NCAP__
#define GLADE_FILE_NAME 	"cngplp_ncap.glade"
#define CONFIG_FILE_NAME 	"func_config_ncap.xml"
#else
#define GLADE_FILE_NAME 	"cngplp_ps.glade"
#define CONFIG_FILE_NAME 	"func_config_ps.xml"
#endif

GladeXML *g_cngplp_xml = NULL;
const char *g_main_dlg_name = NULL;
cngplpData *g_cngplp_data = NULL;
GList *g_notebook_list = NULL;
GList *g_topwidget_list = NULL;
ConfigFile *g_config_file_data = NULL;
FuncInfo *g_load_func = NULL;
char glade_file[MAX_PATH];
WidgetInformation *g_widget_table = NULL;

typedef struct{
	char *widget_type;
	char *module_name;
}WidgetLib;

typedef struct _notebook_tab{
	int index;
	int show;
}NotebookTab;

typedef struct _notebook{
	char *name;
	GList *tab_xml;
	GList *show_tabs;
}Notebook;

WidgetInformation widget_table[] = {
	{"button", NULL, ConnectButtonSignal, NULL},
	{"checkbutton", InitCheckbutton, ConnectCheckbuttonSignal, CheckbuttonSpecialFunction},
	{"combo", NULL, ConnectComboSignal, ComboSpecialFunction},
	{"dialog", NULL, ConnectDialogSignal, NULL},
	{"entry", InitEntry, ConnectEntrySignal, EntrySpecialFunction},
	{"label", InitLabel, NULL, NULL},
	{"radiobutton", NULL, ConnectRadiobuttonSignal, RadiobuttonSpecialFunction},
	{"spinbutton", InitSpinbutton, ConnectSpinbuttonSignal, SpinbuttonSpecialFunction},
	{"textview", InitTextview, ConnectTextviewSignal, NULL},
	{NULL, NULL, NULL, NULL}
};

int IsNeedLoadFunc(const FuncInfo *func)
{
	KeyInfo *key = NULL;
	gboolean load = TRUE;
	if((func != NULL) && (func->func_id != NULL)){
		load = FindKey(func->func_id, g_cngplp_data);
		if((func->func_id->type != NULL) && (0 == strcmp(func->func_id->type, "or"))){
			if(load == TRUE){
				return TRUE;
			}
		}else{
			if(load == TRUE){
				key = func->key_list;
				while(key != NULL){
					load = FindKey(key, g_cngplp_data);
					if((key->type != NULL) && (0 == strcmp(key->type, "or"))){
						if(load == TRUE){
							return TRUE;
						}
					}else{
						if(load != TRUE){
							return FALSE;
						}
					}
					key = key->next;
				}
			}else{
				load = FALSE;
			}
		}
	}else{
		key = func->key_list;
		while(key != NULL){
			load = FindKey(key, g_cngplp_data);
			if((key->type != NULL) && (0 == strcmp(key->type, "or"))){
				if(load == TRUE){
					return TRUE;
				}
			}else{
				if(load != TRUE){
					return FALSE;
				}
			}
			key = key->next;
		}
	}
	return load;
}

void ConnectSignals(const FuncInfo *func_list)
{
	const FuncInfo *func = func_list;
	WidgetInformation *lib = NULL;
	char *widget_type = NULL;
	WidgetInfo *widget = NULL;
	if(func != NULL){
		widget = func->widget_list;
	}else{
		return;
	}

	while(widget != NULL){
		widget_type = widget->type;
		lib = widget_table;
		if(widget_type != NULL){
			while(lib->widget_name != NULL){
				if(0 == strcmp(widget->type, lib->widget_name)){
					if(lib->ConnectSignal != NULL){
						lib->ConnectSignal(g_cngplp_xml, g_cngplp_data, (gpointer *)widget);
						break;
					}
				}
				lib++;
			}
		}
		widget = widget->next;
	}
}

void InitWidgetStatus(ConfigFile *config_file)
{
	FuncInfo *func = g_load_func;
	WidgetInfo *widget = NULL;
	WidgetInformation *lib = NULL;

	while(func != NULL){
		widget = func->widget_list;
		while(widget != NULL){
			char *widget_type = widget->type;
			lib = widget_table;
			if(widget_type != NULL){
				while(lib->widget_name != NULL){
					if(strcmp(widget_type, lib->widget_name) == 0){
						if(lib->InitWidget != NULL){
							lib->InitWidget(g_cngplp_xml, g_cngplp_data, (gpointer *)widget);
						}
						if(widget->func != NULL){
							lib->SpecialFunction(g_cngplp_data, widget->name);
						}
						break;
					}
					lib++;
				}
			}
			widget = widget->next;
		}
		func = func->next;
	}
}

void InitWidgetProperty(const ConfigFile *configfile)
{
	FuncInfo *funclist = g_load_func;
	WidgetInformation *lib = NULL;
	SpecialInfo *special = NULL;
	if(configfile != NULL){
		special = configfile->special_list;
	}else{
		return;
	}

	while(funclist != NULL){
		ConnectSignals(funclist);
		funclist = funclist->next;
	}
	if(special != NULL){
		lib = widget_table;
		while(lib->widget_name != NULL){
			if(0 == strcmp(lib->widget_name, "dialog")){
				break;
			}
			lib++;
		}
		if(lib->widget_name != NULL){
			while(special != NULL){
				if(special->type == 1){
					lib->ConnectSignal(g_cngplp_xml, g_cngplp_data, (gpointer *)special);
				}
				special = special->next;
			}
		}
	}
}

void AddNeedShowTab(Notebook *notebook, const int index)
{
	GList *show_tabs = NULL;
	if(notebook != NULL){
		show_tabs = notebook->show_tabs;
	}else{
		return;
	}
	const int len = g_list_length(show_tabs);
	int i = 0;
	NotebookTab *show_tab = NULL;
	if(len == 0){
		show_tab = malloc(sizeof(NotebookTab));
		if(show_tab != NULL){
			show_tab->index = index;
			show_tab->show = TRUE;
			notebook->show_tabs = g_list_append(notebook->show_tabs, show_tab);
		}
	}else{
		for(;i < len; i++){
			show_tab = (NotebookTab *)g_list_nth_data(notebook->show_tabs, i);
			if(show_tab != NULL){
				if(show_tab->index == index){
					break;
				}else{
					show_tab = malloc(sizeof(Notebook));
					if(show_tab != NULL){
						show_tab->index = index;
						show_tab->show = TRUE;
						notebook->show_tabs = g_list_append(notebook->show_tabs, show_tab);
       	 	       			}
				}
			}
		}
	}
}

void SetNotebookIndex(const char *child_name)
{
	const int len = g_list_length(g_notebook_list);
	Notebook *notebook;
	int i = 0;
	int index = 0;
	GladeXML *xml = NULL;
	GtkWidget* widget = NULL;
	int found = 0;

	for(; i < len; i++){
		notebook =(Notebook*)g_list_nth_data(g_notebook_list, i);
		index = 0;
		if(found != 0){
			break;
		}
		if(notebook != NULL){
			for(; index < g_list_length(notebook->tab_xml); index++){
				xml = (GladeXML*)g_list_nth_data(notebook->tab_xml, index);
				widget = glade_xml_get_widget(xml, child_name);
				if(widget != NULL){
					AddNeedShowTab(notebook, index);
					found = TRUE;
					break;
				}
			}
		}
	}
}

int ShowNotebookTabs()
{
	const int len = g_list_length(g_notebook_list);
        Notebook *notebook = NULL;
        int i = 0;
        int index = 0;
        NotebookTab *tab = NULL;
        GtkWidget* widget = NULL;

        for(; i < len; i++){
                notebook = (Notebook*)g_list_nth_data(g_notebook_list, i);
                index = 0;
		if(notebook != NULL){
			widget = glade_xml_get_widget(g_cngplp_xml, notebook->name);
		}
                for(; index < g_list_length(notebook->show_tabs); index++){
			tab = (NotebookTab*)g_list_nth_data(notebook->show_tabs, index);
                        if(widget != NULL){
				if(tab != NULL){
                			gtk_widget_show(gtk_notebook_get_nth_page((GtkNotebook*)widget, tab->index));
				}
                        }
                }
        }

	return 0;
}

#ifdef _UI_DEBUG
void PrintTime()
{
	int i = 0;
	struct timeval tms;
	time_t t;
	struct tm *tmm;
	t = time(NULL);
	tmm = localtime(&t);
	gettimeofday(&tms,NULL);
	if(tmm != NULL){
		UI_DEBUG("%d:%d:%d.%d\n",tmm->tm_hour,tmm->tm_min,tmm->tm_sec,tms.tv_usec/1000);
	}
}
#endif

void AddSaveData(const int id, TopWidget* const top_widget)
{
	TopWidgetSaveData* data = NULL;

	data = (TopWidgetSaveData*)malloc(sizeof(TopWidgetSaveData));
	if(data != NULL){
		memset(data, 0, sizeof(TopWidgetSaveData));
		data->id = id;
	}
	if(top_widget != NULL){
		top_widget->save_data = g_list_append(top_widget->save_data, data);
	}
}

void AddFuncToTopwidget(const FuncInfo* func)
{
	WidgetInfo *widget_info = NULL;
	TopWidget* top_widget = NULL;
	TopWidget* prop_topwidget = NULL;
	SpecialInfo* special = NULL;
	int len = 0;
	int found = 0;
	int i = 0;
	GtkWidget *widget = NULL;
	char* id = NULL;
	SignalInfo *signal = NULL;
	char* opt = NULL;

	len = g_list_length(g_topwidget_list);
	if(g_config_file_data != NULL){
		special = g_config_file_data->special_list;
	}else{
		return;
	}
	while(special != NULL){
		if((1 == special->type) && (0 == strcasecmp(special->parent, g_main_dlg_name))){
			break;
		}
		special = special->next;
	}
	for(i = 0; i < len; i++){
		top_widget = (TopWidget*)g_list_nth_data(g_topwidget_list, i);
		if(top_widget != NULL){
			if(0 == strcmp(top_widget->name, special->name)){
				prop_topwidget = top_widget;
				break;
			}
		}
	}
	if(func != NULL){
		if(func->func_id != NULL){
			id = func->func_id->name;
		}
		widget_info = func->widget_list;
	}
	while(widget_info != NULL){
		signal = widget_info->signal_list;
		if(signal != NULL){
			if(signal->condition != NULL){
				id = signal->condition->id;
			}else{
				id = signal->id;
			}
		}
		if(NULL == id){
			widget_info = widget_info->next;
			continue;
		}
		for(i = 0; i < len; i++){
			top_widget = (TopWidget*)g_list_nth_data(g_topwidget_list, i);
			if(top_widget != NULL){
				widget = glade_xml_get_widget(top_widget->xml, widget_info->name);
			}
			if(widget != NULL){
				TopWidgetSaveData* search = NULL;
				int savedata_len = 0;
				int j = 0;
				int tmp = GetModID(id);
				found = 0;
				if(top_widget != NULL){
					savedata_len = g_list_length(top_widget->save_data);
				}
				for(; j < savedata_len; j++){
					search = g_list_nth_data(top_widget->save_data, j);
					if(search != NULL){
						if(search->id == tmp){
							found = 1;
							break;
						}
					}
				}
				if(found == 1){
					break;
				}
				if(tmp == ID_CNPRINTSTYLE){
					opt = GetOptionList(g_cngplp_data, ID_DUPLEX);
					if(opt != NULL){
						AddSaveData(ID_DUPLEX, top_widget);
						memFree(opt);
					}
					opt = GetOptionList(g_cngplp_data, ID_BOOKLET);
					if(opt != NULL){
						AddSaveData(ID_BOOKLET, top_widget);
						memFree(opt);
					}
				}else if(tmp == ID_CNFOLDSETTING){
					opt = GetOptionList(g_cngplp_data, ID_CNZFOLDING);
					if(opt != NULL){
						AddSaveData(ID_CNZFOLDING, top_widget);
						memFree(opt);
					}
					opt = GetOptionList(g_cngplp_data, ID_CNCFOLDING);
					if(opt != NULL){
						AddSaveData(ID_CNCFOLDING, top_widget);
						memFree(opt);
					}
					opt = GetOptionList(g_cngplp_data, ID_CNHALFFOLDING);
					if(opt != NULL){
						AddSaveData(ID_CNHALFFOLDING, top_widget);
						memFree(opt);
					}
					opt = GetOptionList(g_cngplp_data, ID_CNACCORDIONZFOLDING);
					if(opt != NULL){
						AddSaveData(ID_CNACCORDIONZFOLDING, top_widget);
						memFree(opt);
					}
					opt = GetOptionList(g_cngplp_data, ID_CNDOUBLEPARALLELFOLDING);
					if(opt != NULL){
						AddSaveData(ID_CNDOUBLEPARALLELFOLDING, top_widget);
						memFree(opt);
					}
				}else if(tmp == ID_CNFOLDDETAIL){
					opt = GetOptionList(g_cngplp_data, ID_CNCFOLDSETTING);
					if(opt != NULL){
						AddSaveData(ID_CNCFOLDSETTING, top_widget);
						memFree(opt);
					}
					opt = GetOptionList(g_cngplp_data, ID_CNHALFFOLDSETTING);
					if(opt != NULL){
						AddSaveData(ID_CNHALFFOLDSETTING, top_widget);
						memFree(opt);
					}
					opt = GetOptionList(g_cngplp_data, ID_CNACCORDIONZFOLDSETTING);
					if(opt != NULL){
						AddSaveData(ID_CNACCORDIONZFOLDSETTING, top_widget);
						memFree(opt);
					}
					opt = GetOptionList(g_cngplp_data, ID_CNDOUBLEPARALLELFOLDSETTING);
					if(opt != NULL){
						AddSaveData(ID_CNDOUBLEPARALLELFOLDSETTING, top_widget);
						memFree(opt);
					}
				}else if(tmp == ID_CNSADDLESETTING){
					opt = GetOptionList(g_cngplp_data, ID_CNVFOLDING);
					if(opt != NULL){
						AddSaveData(ID_CNVFOLDING, top_widget);
						memFree(opt);
					}
					opt = GetOptionList(g_cngplp_data, ID_CNVFOLDINGTRIMMING);
					if(opt != NULL){
						AddSaveData(ID_CNVFOLDINGTRIMMING, top_widget);
						memFree(opt);
					}
					opt = GetOptionList(g_cngplp_data, ID_CNSADDLESTITCH);
					if(opt != NULL){
						AddSaveData(ID_CNSADDLESTITCH, top_widget);
						memFree(opt);
					}
					opt = GetOptionList(g_cngplp_data, ID_CNTRIMMING);
					if(opt != NULL){
						AddSaveData(ID_CNTRIMMING, top_widget);
						memFree(opt);
					}
				}else{
					TopWidgetSaveData* data = (TopWidgetSaveData*)malloc(sizeof(TopWidgetSaveData));
					if(data != NULL){
						memset(data, 0, sizeof(TopWidgetSaveData));
						data->id = GetModID(id);
					}
					if(top_widget != NULL){
						if(0 != strcmp(top_widget->name, special->name)){
							TopWidgetSaveData* prop_data = (TopWidgetSaveData*)malloc(sizeof(TopWidgetSaveData));
							if(prop_data != NULL){
								memset(prop_data, 0, sizeof(TopWidgetSaveData));
								prop_data->id = GetModID(id);
							}
							if(prop_topwidget != NULL){
								prop_topwidget->save_data = g_list_append(prop_topwidget->save_data, prop_data);
							}
						}
						top_widget->save_data = g_list_append(top_widget->save_data, data);
					}
					break;
				}
			}
		}
		widget_info = widget_info->next;
	}
}

void DeleteTopWidgetSaveData(TopWidgetSaveData * data)
{
	if(NULL == data){
		return;
	}
	if(data->key_value != NULL){
		free(data->key_value);
		data->key_value = NULL;
	}
	free(data);
	data = NULL;
}

void FreeTopWidget(TopWidget *top_widget)
{
	int len, i;
	if(top_widget == NULL){
		return;
	}
	if(top_widget->xml != NULL){
		if(top_widget->name != NULL){
			GtkWidget* window = glade_xml_get_widget(top_widget->xml, top_widget->name);
			if(window != NULL){
				gtk_widget_destroy(window);
			}
			free(top_widget->name);
			top_widget->name = NULL;
		}
		g_object_unref(G_OBJECT(top_widget->xml));
		top_widget->xml = NULL;
	}
	len = g_list_length(top_widget->save_data);
	for(i = 0; i < len; i++){
		TopWidgetSaveData *data = (TopWidgetSaveData *)g_list_nth_data(top_widget->save_data, i);
		DeleteTopWidgetSaveData(data);
	}
	g_list_free(top_widget->save_data);
	free(top_widget);
	top_widget = NULL;
}

void FreeTopWidgetList(GList *top_widget_list)
{
	TopWidget *cur;
	int len, i;

	len = g_list_length(top_widget_list);
	for(i = 0; i < len; i++){
		cur = (TopWidget *)g_list_nth_data(top_widget_list, i);
		FreeTopWidget(cur);
		cur = NULL;
	}
	g_list_free(top_widget_list);
	top_widget_list = NULL;
}

int DealSpecialWidget(const SpecialInfo* special_list)
{
	const SpecialInfo *special = NULL;
	GtkNotebook *notebook = NULL;

	special = special_list;
	while(special != NULL){
		if(special->type == 1){
			TopWidget *top_widget = malloc(sizeof(TopWidget));
			if(top_widget != NULL){
				memset(top_widget, 0, sizeof(TopWidget));
				top_widget->name = strdup(special->name);
				GladeXML *top_xml = glade_xml_new(glade_file, top_widget->name, NULL);
				top_widget->xml = top_xml;
				g_topwidget_list=g_list_append(g_topwidget_list, top_widget);
			}
		}else if(special->type == 0){
			Notebook *self_notebook = malloc(sizeof(Notebook));
			memset(self_notebook, 0, sizeof(Notebook));
			if(self_notebook != NULL){
				self_notebook->name = strdup(special->name);
				g_notebook_list = g_list_append(g_notebook_list, self_notebook);

        			GtkWidget *widget;
				notebook = (GtkNotebook*)glade_xml_get_widget(g_cngplp_xml,special->name);
		        	int notebook_page_num;
				int i = 0;
	                	notebook_page_num = gtk_notebook_get_n_pages(GTK_NOTEBOOK(notebook));
				for(; i < notebook_page_num; i++){
                                	widget = gtk_notebook_get_nth_page(notebook, i);
					const gchar *name = gtk_widget_get_name(widget);
                                	GladeXML* tmp = glade_xml_new(glade_file, name, NULL);
					if(tmp != NULL){
                                		self_notebook->tab_xml = g_list_append(self_notebook->tab_xml, tmp);
					}
                                	gtk_widget_hide(gtk_notebook_get_nth_page(notebook, i));
                        	}
                	}
		}
		special=special->next;
	}
	return 0;
}


void FreeNotebook(Notebook *note)
{
	GList *cur;
	GtkNotebook *notebook = NULL;
	GtkWidget *widget = NULL;
	GtkWidget *widget_tab = NULL;
	int notebook_page_num;
	int i = 0;

	if(note == NULL){
		return;
	}

	cur = note->tab_xml;
	notebook = (GtkNotebook*)glade_xml_get_widget(g_cngplp_xml, note->name);
	if(notebook != NULL){
		notebook_page_num = gtk_notebook_get_n_pages(GTK_NOTEBOOK(notebook));
		for(; i < notebook_page_num; i++){
			widget = gtk_notebook_get_nth_page(notebook, i);
			const gchar *name = gtk_widget_get_name(widget);
			if(cur != NULL){
				widget_tab = glade_xml_get_widget((GladeXML *)(cur->data), name);
				if(widget_tab != NULL){
					gtk_widget_destroy(widget_tab);
				}
				g_object_unref(G_OBJECT((GladeXML *)(cur->data)));
			}
			cur = cur->next;
		}
	}

	if(note->name != NULL){
		free(note->name);
		note->name = NULL;
	}
	g_list_free(note->tab_xml);
	cur = note->show_tabs;
	while(cur != NULL){
		free((NotebookTab *)(cur->data));
		cur = cur->next;
	}
	g_list_free(note->show_tabs);
	free(note);
	note = NULL;
}

void FreeNotebookList(GList *note_list)
{
	GList *cur;

	if(note_list == NULL){
		return;
	}
	cur = note_list;
	while(cur != NULL){
		FreeNotebook((Notebook *)(cur->data));
		cur = cur->next;
	}
	g_list_free(note_list);
	note_list = NULL;
}

int LoadFunctions(const gboolean first_load)
{
	GtkWidget *widget = NULL;
	FuncInfo *cur_func = NULL, *new_func = NULL, *last_func = NULL;
	ShowWidgetInfo *show_widgets = NULL;
	FuncInfo *common_list = NULL;
	if(g_config_file_data != NULL){
		common_list = g_config_file_data->common_list;
		cur_func = g_config_file_data->func_list;
	}else{
		return -1;
	}
	g_load_func = NULL;
	while(cur_func != NULL){
		if(!IsNeedLoadFunc(cur_func)){
			cur_func = cur_func->next;
		}else{
			show_widgets = cur_func->show_widget_list;
			while(show_widgets != NULL){
				widget = glade_xml_get_widget(g_cngplp_xml, show_widgets->name);
				if(widget){
					gtk_widget_show(widget);
					SetNotebookIndex(show_widgets->name);
				}
				show_widgets = show_widgets->next;
			}
			new_func = (FuncInfo*)malloc(sizeof(FuncInfo));
			if(NULL == new_func){
				fprintf(stderr, "malloc failed in function %s(line:%d)\n", __FUNCTION__, __LINE__);
				exit(1);
			}
			memset(new_func, 0, sizeof(FuncInfo));
			memcpy(new_func, cur_func, sizeof(FuncInfo));
			if(new_func != NULL){
				new_func->next = NULL;
			}
			if(NULL == g_load_func){
				g_load_func = new_func;
				last_func = new_func;
			}else{
				if(last_func != NULL){
					last_func->next = new_func;
				}
				last_func = new_func;
			}
			cur_func = cur_func->next;
		}
	}
	if(g_config_file_data != NULL){
		cur_func = g_config_file_data->common_list;
	}
	while(cur_func != NULL){
		new_func = (FuncInfo*)malloc(sizeof(FuncInfo));
		memset(new_func, 0, sizeof(FuncInfo));
		memcpy(new_func, cur_func, sizeof(FuncInfo));
		if(new_func != NULL){
			new_func->next = NULL;
		}
		if(NULL == g_load_func){
			g_load_func = new_func;
			last_func = new_func;
		}else{
			if(last_func != NULL){
				last_func->next = new_func;
			}
			last_func = new_func;
		}
		cur_func = cur_func->next;
	}
	cur_func = g_load_func;
	while(cur_func != NULL){
		AddFuncToTopwidget(cur_func);
		cur_func = cur_func->next;
	}
	ShowNotebookTabs();
	if(first_load == TRUE){
		InitWidgetProperty(g_config_file_data);
	}
	InitWidgetStatus(g_config_file_data);
	return 0;
}

int LoadPropFuncByConfigfile(const gboolean first_load)
{
#ifdef _UI_DEBUG
	PrintTime();
#endif
	if(g_config_file_data != NULL){
		DealSpecialWidget(g_config_file_data->special_list);
	}
#ifdef _UI_DEBUG
	PrintTime();
#endif
        LoadFunctions(first_load);
	return 0;
}

int InitAllFiles()
{
	char config_file[MAX_PATH];
	char res_path[MAX_PATH];
	xmlKeepBlanksDefault(0);
	memset(config_file, 0, sizeof(config_file));
	memset(glade_file, 0, sizeof(glade_file));
	memset(res_path, 0, sizeof(res_path));
	strcat(config_file, PACKAGE_CONFIG_DIR);
	strcat(config_file, CONFIG_FILE_NAME);
	strcat(glade_file, PACKAGE_CONFIG_DIR);
	strcat(glade_file, GLADE_FILE_NAME);
	strcat(res_path, PACKAGE_CONFIG_DIR);
	g_config_file_data = NULL;
	g_cngplp_xml = NULL;
	if(g_cngplp_data != NULL){
		InitKeyTextList(res_path, g_cngplp_data->ppd_opt->pcfile_name);
	}
	if(-1 == access(config_file, F_OK)){
		UI_DEBUG("The configure file doesn't exist! \n");
	}
	g_config_file_data = ParseConfigureFile(config_file);
	if(NULL == g_config_file_data){
		UI_DEBUG("The configure file is wrong!\n");
		return -1;
	}
	bindtextdomain(GETTEXT_PACKAGE, PACKAGE_LOCALE_DIR);
	bind_textdomain_codeset(GETTEXT_PACKAGE, "UTF-8");
	textdomain(GETTEXT_PACKAGE);
	gtk_set_locale();
	g_cngplp_xml = glade_xml_new(glade_file, NULL, GETTEXT_PACKAGE);
       	if(NULL == g_cngplp_xml){
		g_warning("the glade file is wrong\n");
		return -1;
	}
	return 0;
}


gboolean InitController(GtkWidget* main_dlg, char *printer_name, char *print_file_name, const gboolean first_load)
{
	const gboolean ret = TRUE;
	char *tmp = NULL;
	SigInit();

	g_widget_table = widget_table;
	g_cngplp_data = cngplpNew(print_file_name);
	if(NULL == g_cngplp_data){
		return FALSE;
	}
	cngplpSetData(g_cngplp_data, ID_PRINTERNAME, printer_name);
	if(g_cngplp_data->file_name != NULL){
		tmp = cngplpGetData(g_cngplp_data, ID_DATANAME);
		if(tmp != NULL){
			cngplpSetData(g_cngplp_data, ID_DATANAME, "1");
			memFree(tmp);
		}
		tmp = cngplpGetData(g_cngplp_data, ID_HOLDQUEUE_DATANAME);
	   	if(tmp != NULL){
			cngplpSetData(g_cngplp_data, ID_HOLDQUEUE_DATANAME, "1");
			memFree(tmp);
		}
		tmp = cngplpGetData(g_cngplp_data, ID_SECURED_DOCNAME);
	   	if(tmp != NULL){
	   		char *file = strrchr(g_cngplp_data->file_name, '/');
			if(file != NULL){
				file++;
			}else{
				file = g_cngplp_data->file_name;
			}
			cngplpSetData(g_cngplp_data, ID_SECURED_DOCNAME, file);
			memFree(tmp);
		}
	}
	if(first_load != FALSE){
		if(InitAllFiles() < 0){
			CloseController();
			return FALSE;
		}
		const gchar* name = gtk_widget_get_name(main_dlg);
		SetMainDlgInfo(main_dlg, name);
	}else{
		char res_path[MAX_PATH];
		Notebook *note = NULL;

		if(g_notebook_list != NULL){
			note = (Notebook *)(g_notebook_list->data);
		}
		GList *tab_cur;
		tab_cur = note->show_tabs;
		while(tab_cur != NULL){
			free((NotebookTab *)(tab_cur->data));
			tab_cur = tab_cur->next;
		}
		g_list_free(note->show_tabs);
		note->show_tabs = NULL;

		int TopWidget_len = 0, SaveData_len = 0, i = 0, j = 0;
		TopWidget *TopWidget_cur = NULL;
		TopWidgetSaveData *savedata = NULL;
		TopWidget_len = g_list_length(g_topwidget_list);
		for(i = 0; i < TopWidget_len; i++){
			TopWidget_cur = (TopWidget *)g_list_nth_data(g_topwidget_list, i);
			if(TopWidget_cur != NULL){
				SaveData_len = g_list_length(TopWidget_cur->save_data);
			}
			for(j = 0; j < SaveData_len; j++){
				savedata = (TopWidgetSaveData *)g_list_nth_data(TopWidget_cur->save_data, j);
				DeleteTopWidgetSaveData(savedata);
			}
			g_list_free(TopWidget_cur->save_data);
			TopWidget_cur->save_data = NULL;
		}

		FreeResource();

		memset(res_path, 0, sizeof(res_path));
		strcat(res_path, PACKAGE_CONFIG_DIR);
		if(g_cngplp_data != NULL){
			InitKeyTextList(res_path, g_cngplp_data->ppd_opt->pcfile_name);
		}

		FuncInfo* cur_func = g_load_func;
		FuncInfo* next_func = cur_func;
		while(cur_func != NULL){
			next_func = cur_func->next;
			free(cur_func);
			cur_func = NULL;
			cur_func = next_func;
		}
		g_load_func = NULL;
	}
	LoadPropFuncByConfigfile(first_load);
	return ret;
}

void CloseFunctions()
{
	FreeNotebookList(g_notebook_list);
	g_notebook_list = NULL;
	FreeTopWidgetList(g_topwidget_list);
	g_topwidget_list = NULL;
	FreeResource();
	xmlCleanupParser();
}

void CloseController()
{
	GtkWidget *window = NULL;

	CloseFunctions();
	if(g_cngplp_xml != NULL){
		SpecialInfo *special = g_config_file_data->special_list;
		while(special != NULL){
			if(special->type == 1){
				window = glade_xml_get_widget(g_cngplp_xml, special->name);
				if(window != NULL){
					gtk_widget_destroy(window);
				}
			}
			special = special->next;
		}
		g_object_unref(G_OBJECT(g_cngplp_xml));
		g_cngplp_xml = NULL;
	}
	FreeConfigfileData(g_config_file_data);
	g_config_file_data = NULL;
	cngplpDestroy(g_cngplp_data);
	FuncInfo* cur_func = g_load_func;
	FuncInfo* next_func = cur_func;
	while(cur_func != NULL){
		next_func = cur_func->next;
		free(cur_func);
		cur_func = NULL;
		cur_func = next_func;
	}
	g_load_func = NULL;
}

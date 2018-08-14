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


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <glade/glade.h>
#include <gmodule.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <gdk/gdkkeysyms.h>
#include <unistd.h>
#include <sys/wait.h>
#include "printerinfo.h"
#include "mainwnd.h"
#include "load.h"

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#ifdef ENABLE_NLS
#  include <libintl.h>
#  undef _
#  define _(String) dgettext (PACKAGE, String)
#  define Q_(String) g_strip_context ((String), gettext (String))
#  ifdef gettext_noop
#    define N_(String) gettext_noop (String)
#  else
#    define N_(String) (String)
#  endif
#else
#  define textdomain(String) (String)
#  define gettext(String) (String)
#  define dgettext(Domain,Message) (Message)
#  define dcgettext(Domain,Message,Type) (Message)
#  define bindtextdomain(Domain,Directory) (Domain)
#  define _(String) (String)
#  define Q_(String) g_strip_context ((String), (String))
#  define N_(String) (String)
#endif

const char *g_print_file = NULL;
gboolean g_load_lib_success = FALSE;
void UpdateMainDlg();
GladeXML *g_main_xml = NULL;
static int g_main_signal = 0;
static gboolean g_PrinterName_mapped = FALSE;

#define EXEC_PATH	"/usr/bin"
#define	EXEC_FILE_LPOPTIONS	"lpoptions"
#define DEFAULT_PRINTER_CMD_OPTION_NUM 		4
#define DEFAULT_PRINTER_CMD_INDEX		0
#define DEFAULT_PRINTER_CMD_OPTION_INDEX	1
#define DEFAULT_PRINTER_CMD_PRINTER_NAME_INDEX	2
#define DEFAULT_PRINTER_CMD_LAST_INDEX		3
#define EXEC_PATH_MAX				128
#define ID_MAX_COPIES				1017
#define CAPT_DEFAULT_COPIES_MAX			999
#define OTHER_DEFAULT_COPIES_MAX		2000

static int g_stdout_fd;

void DisposeMainDlg()
{
	int i = 0;
	PrinterInfo* info = NULL;
	if(g_main_xml != NULL){
		g_object_unref(G_OBJECT(g_main_xml));
		g_main_xml = NULL;
	}
	if(g_printers != NULL){
		if(g_printers->printer_list != NULL){
			for(i = 0; i < g_list_length(g_printers->printer_list); i++){
				info = g_list_nth_data(g_printers->printer_list, i);
				if(info != NULL){
					free(info->name);
					info->name = NULL;
					free(info->lib);
					info->lib = NULL;
					free(info);
				}
			}
			g_list_free(g_printers->printer_list);
			g_printers->printer_list = NULL;
		}
	}
	free(g_printers);
	g_printers = NULL;

#ifndef _UI_DEBUG
	close(g_stdout_fd);
#endif
}

gboolean SigMainEnable(void)
{
	gboolean enable = TRUE;
	if(g_main_signal > 0){
		g_main_signal--;
		enable = FALSE;
	}
	return enable;
}

gboolean SigMainDisable(void)
{
	gboolean enable = TRUE;
	if(g_main_signal > 0){
		enable = FALSE;
	}
	g_main_signal++;
	return enable;
}

void SetDefaultPrinter()
{
	char **param_list = NULL;

	param_list = (char **)malloc(sizeof(char *) * DEFAULT_PRINTER_CMD_OPTION_NUM);
	if(param_list != NULL){
		int pid = 0, i = 0;

		param_list[DEFAULT_PRINTER_CMD_INDEX] = strdup("lpoptions");
		param_list[DEFAULT_PRINTER_CMD_OPTION_INDEX] = strdup("-d");
		param_list[DEFAULT_PRINTER_CMD_PRINTER_NAME_INDEX] = strdup(g_printers->curr_printer->name);
		param_list[DEFAULT_PRINTER_CMD_LAST_INDEX] = NULL;
		pid = fork();
		if(pid != -1){
			if(pid == 0){
				char path[EXEC_PATH_MAX];
				memset(path, 0, EXEC_PATH_MAX);
				strncpy(path, EXEC_PATH, EXEC_PATH_MAX - 1);
				strncat(path, "/", EXEC_PATH_MAX - 1 - strlen(path));
				strncat(path, EXEC_FILE_LPOPTIONS, EXEC_PATH_MAX - 1 - strlen(path));
				execv(path, param_list);
			}else{
				waitpid(pid, NULL, 0);
			}
		}
		for(i = 0; i < DEFAULT_PRINTER_CMD_OPTION_NUM; i++){
			free(param_list[i]);
		}
		free(param_list);
	}
}

void
on_PrinterName_combo_entry_changed     (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(TRUE == SigMainDisable()){
		if(FALSE == g_PrinterName_mapped){
			const gchar *text = NULL;
			const GtkWidget* entry = glade_xml_get_widget(g_main_xml, "PrinterName_combo_entry");
			if(entry != NULL){
				text = gtk_entry_get_text(GTK_ENTRY(entry));
				if(strcmp(text, g_printers->curr_printer->name) != 0){
					SetCurrPrinter(text);
					if(0 < LoadPDL(g_main_xml, g_print_file)){
						g_load_lib_success = TRUE;
					}else{
						g_load_lib_success = FALSE;
					}
					UpdateMainDlg();
				}
			}
		}
	}
	SigMainEnable();
}

gboolean
on_PrinterName_combo_popwin_event	(GtkWidget     *widget,
                                        GdkEvent       *event,
                                        gpointer       user_data)
{
	if(event->type == GDK_MAP){
		g_PrinterName_mapped = TRUE;
	}else if(GDK_UNMAP == event->type){
		g_PrinterName_mapped = FALSE;
		if(TRUE == SigMainDisable()){
			const gchar *text = NULL;
			const GtkWidget* entry = glade_xml_get_widget(g_main_xml, "PrinterName_combo_entry");
			if(entry != NULL){
				text = gtk_entry_get_text(GTK_ENTRY(entry));
				if(strcmp(text, g_printers->curr_printer->name) != 0){
					SetCurrPrinter(text);
					if(0 < LoadPDL(g_main_xml, g_print_file)){
						g_load_lib_success = TRUE;
					}else{
						g_load_lib_success = FALSE;
					}
					UpdateMainDlg();
				}
			}
		}
		SigMainEnable();
	}
	return FALSE;
}

gboolean
on_PrinterName_combo_down_up_event	(GtkWidget     *widget,
                                        GdkEvent       *event,
                                        gpointer       user_data)
{
	if((GDK_Down == (event->key).keyval) || (GDK_KP_Down == (event->key).keyval) ||
	   (GDK_Up == (event->key).keyval) || (GDK_KP_Up == (event->key).keyval)){
		g_PrinterName_mapped = TRUE;
		if(TRUE == SigMainDisable()){
			const gchar *text = NULL;
			const GtkWidget* entry = glade_xml_get_widget(g_main_xml, "PrinterName_combo_entry");
			if(entry != NULL){
				text = gtk_entry_get_text(GTK_ENTRY(entry));
				if(strcmp(text, g_printers->curr_printer->name) != 0){
					SetCurrPrinter(text);
					if(0 < LoadPDL(g_main_xml, g_print_file)){
						g_load_lib_success = TRUE;
					}else{
						g_load_lib_success = FALSE;
					}
					UpdateMainDlg();
				}
			}
		}
		SigMainEnable();
	}
	return FALSE;
}

void
on_SetAllPage_radiobutton_toggled         (GtkToggleButton *togglebutton,
                                        gpointer         user_data)
{
	if(TRUE == SigMainDisable()){
		if(TRUE == togglebutton->active){
			if(g_load_lib_success != FALSE){
				UpdatePDLData(ID_PAGE_SET, "all");
			}
		}
	}
	SigMainEnable();
}


void
on_OddPages_radiobutton_toggled        (GtkToggleButton *togglebutton,
                                        gpointer         user_data)
{
	if(TRUE == SigMainDisable()){
		if(TRUE == togglebutton->active){
			if(g_load_lib_success != FALSE){
				UpdatePDLData(ID_PAGE_SET, "odd");
			}
		}
	}
	SigMainEnable();
}


void
on_EvenPages_radiobutton_toggled       (GtkToggleButton *togglebutton,
                                        gpointer         user_data)
{
	if(TRUE == SigMainDisable()){
		if(TRUE == togglebutton->active){
			if(g_load_lib_success != FALSE){
				UpdatePDLData(ID_PAGE_SET, "even");
			}
		}
	}
	SigMainEnable();
}

void
on_RangeAllPage_radiobutton_toggled        (GtkToggleButton *togglebutton,
					gpointer         user_data)
{
	if(TRUE == SigMainDisable()){
		GtkWidget *PageRange_entry = NULL;
		PageRange_entry = glade_xml_get_widget(g_main_xml, "PageSelection_entry");
		gtk_widget_set_sensitive(PageRange_entry, FALSE);
		if(TRUE == togglebutton->active){
			if(g_load_lib_success != FALSE){
				UpdatePDLData(ID_PAGE_RANGES, "1-");
			}
		}
	}
	SigMainEnable();
}

void
on_SelPages_radiobutton_toggled        (GtkToggleButton *togglebutton,
                                        gpointer         user_data)
{
	if(TRUE == SigMainDisable()){
		GtkWidget *PageRange_entry = NULL;
		const gchar *text = NULL;
		PageRange_entry = glade_xml_get_widget(g_main_xml, "PageSelection_entry");
		text = gtk_entry_get_text(GTK_ENTRY(PageRange_entry));
		gtk_widget_set_sensitive(PageRange_entry, TRUE);
		if(TRUE == togglebutton->active){
			if(g_load_lib_success != FALSE){
				if(0 == strcmp(text, "")){
					UpdatePDLData(ID_PAGE_RANGES, "1-");
				}else{
					UpdatePDLData(ID_PAGE_RANGES, text);
				}
			}
		}
	}
	SigMainEnable();
}

void
on_PageSelection_entry_changed         (GtkEditable     *editable,
                                        gpointer         user_data)
{
}

gboolean
on_PageSelection_entry_focus_out_event (GtkWidget       *widget,
                                        GdkEventFocus   *event,
                                        gpointer         user_data)
{
	if(TRUE == SigMainDisable()){
		const gchar *text = NULL;
		const GtkWidget* entry = glade_xml_get_widget(g_main_xml, "PageSelection_entry");
		if(entry != NULL){
			text = gtk_entry_get_text(GTK_ENTRY(entry));
			if(g_load_lib_success != FALSE){
				if(0 == strcmp(text, "")){
					UpdatePDLData(ID_PAGE_RANGES, "1-");
				}else{
					UpdatePDLData(ID_PAGE_RANGES, text);
				}
			}
		}
	}
	SigMainEnable();
	return FALSE;
}

void
on_Copies_spinbutton_changed           (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(TRUE == SigMainDisable()){
		int value = 0;
		const GtkWidget* spin_button = glade_xml_get_widget(g_main_xml, "Copies_spinbutton");
		if(spin_button != NULL){
			value = gtk_spin_button_get_value_as_int(GTK_SPIN_BUTTON(spin_button));
			if(g_load_lib_success != FALSE){
				UpdatePDLDataInt(ID_CNCOPIES, value);
			}
		}
	}
	SigMainEnable();
}

void
on_ReverseOrder_checkbutton_toggled    (GtkToggleButton *togglebutton,
                                        gpointer         user_data)
{
	if(TRUE == SigMainDisable()){
		if(TRUE == togglebutton->active){
			if(g_load_lib_success != FALSE){
				UpdatePDLData(ID_OUTPUTORDER, "reverse");
			}
		}else{
			if(g_load_lib_success != FALSE){
				UpdatePDLData(ID_OUTPUTORDER, "normal");
			}
		}
	}
	SigMainEnable();
}

void on_Property_button_clicked(GtkButton *button, gpointer user_data)
{
	if(TRUE == SigMainDisable()){
		if(g_load_lib_success != FALSE){
			ShowPDLDialog("PropertiesDlg", 0);
		}
	}
	SigMainEnable();
}

void on_SetDefault_button_clicked(GtkButton *button, gpointer user_data)
{
	if(TRUE == SigMainDisable()){
		if(g_load_lib_success != FALSE){
			UpdatePDLData(ID_SETDEFAULT, NULL);
		}else{
			SetDefaultPrinter();
		}
	}
	SigMainEnable();
}

void on_MainCancel_button_clicked(GtkButton *button, gpointer user_data)
{
	UnLoadPDL();
	DisposeMainDlg();
	gtk_main_quit();
}

void on_MainOK_button_clicked               (GtkButton       *button,
                                        gpointer         user_data)
{
	if(g_load_lib_success != FALSE){
		if(ExecPDLJobMode() > 0){
			PrintPDLFile();
		}
	}
	UnLoadPDL();
	DisposeMainDlg();
	gtk_main_quit();
}

void on_MainSave_button_clicked             (GtkButton       *button,
                                        gpointer         user_data)
{
	if(g_load_lib_success != FALSE){
		if(ExecPDLJobMode() > 0){
			SavePDLPrinterData();
			if(g_print_file != NULL){
				PrintPDLFile();
			}
		}
	}
	UnLoadPDL();
	DisposeMainDlg();
	gtk_main_quit();
}

gboolean
on_MainDlg_delete_event                (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data)
{
	UnLoadPDL();
	DisposeMainDlg();
	gtk_main_quit();
	return FALSE;
}

void UpdateMainDlg()
{
	GtkWidget *Property_button = NULL;
	GtkWidget *MainOK_button = NULL;
	GtkWidget *MainSave_button = NULL;
	GtkWidget *SetDefault_button = NULL;
	GtkWidget *MainCancel_button = NULL;
	GtkWidget *PageSet_All_button = NULL;
	GtkWidget *PageSet_Even_button = NULL;
	GtkWidget *PageSet_Odd_button = NULL;
	GtkWidget *PageRange_All_button = NULL;
	GtkWidget *PageRange_Pages_button = NULL;
	GtkWidget *PageRange_entry = NULL;
	GtkWidget *Copies_spinbutton = NULL;
	GtkWidget *Copies_label = NULL;
	GtkObject *Copies_adj = NULL;
	GtkWidget *Reverse_checkbutton = NULL;
	char *page_set = NULL;
	char *page_range = NULL;
	char *reverse = NULL;
	gint copies;
	int max_copies;
	int printer_type = PRINTER_TYPE_OTHER;
	gboolean enable = TRUE;

	GetPrinterToGList("PrinterName_combo");
	printer_type = GetCurrPrinterType();
	Property_button = glade_xml_get_widget(g_main_xml, "Property_button");
	MainOK_button = glade_xml_get_widget(g_main_xml, "MainOK_button");
	MainSave_button = glade_xml_get_widget(g_main_xml, "MainSave_button");
	SetDefault_button = glade_xml_get_widget(g_main_xml, "SetDefault_button");
	MainCancel_button = glade_xml_get_widget(g_main_xml, "MainCancel_button");
	PageSet_All_button = glade_xml_get_widget(g_main_xml, "SetAllPage_radiobutton");
	PageSet_Even_button = glade_xml_get_widget(g_main_xml, "EvenPages_radiobutton");
	PageSet_Odd_button = glade_xml_get_widget(g_main_xml, "OddPages_radiobutton");
	PageRange_All_button = glade_xml_get_widget(g_main_xml, "RangesAllPage_radiobutton");
	PageRange_Pages_button = glade_xml_get_widget(g_main_xml, "SelPages_radiobutton");
	PageRange_entry = glade_xml_get_widget(g_main_xml, "PageSelection_entry");
	Copies_spinbutton = glade_xml_get_widget(g_main_xml, "Copies_spinbutton");
	Copies_label = glade_xml_get_widget(g_main_xml, "Copies_label");
	Copies_adj = GTK_OBJECT(gtk_spin_button_get_adjustment(GTK_SPIN_BUTTON(Copies_spinbutton)));
	Reverse_checkbutton = glade_xml_get_widget(g_main_xml, "ReverseOrder_checkbutton");

	if(FALSE == g_load_lib_success){
		gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(PageSet_All_button), 1);
		gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(PageRange_All_button), 1);
		gtk_widget_set_sensitive(PageRange_entry, FALSE);
		gtk_entry_set_text(GTK_ENTRY(PageRange_entry), "");
		max_copies = 1;
		if(Copies_adj != NULL){
			GTK_ADJUSTMENT(Copies_adj)->upper = max_copies;
		}
		gtk_spin_button_set_adjustment(GTK_SPIN_BUTTON(Copies_spinbutton), GTK_ADJUSTMENT(Copies_adj));
		gtk_label_set_text(GTK_LABEL(Copies_label), " ");
		gtk_spin_button_set_value(GTK_SPIN_BUTTON(Copies_spinbutton), 1);
		enable = FALSE;
	}else{
		page_set = GetPDLData(ID_PAGE_SET);
		if(page_set != NULL){
			if(0 == strcmp(page_set, "all")){
				gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(PageSet_All_button), 1);
			}else if(0 == strcmp(page_set, "even")){
				gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(PageSet_Even_button), 1);
			}else if(0 == strcmp(page_set, "odd")){
				gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(PageSet_Odd_button), 1);
			}
			free(page_set);
			page_set = NULL;
		}

		page_range = GetPDLData(ID_PAGE_RANGES);
		if(page_range != NULL){
			if(0 == strcmp(page_range, "1-")){
				gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(PageRange_All_button), 1);
				gtk_widget_set_sensitive(PageRange_entry, FALSE);
				gtk_editable_delete_text(GTK_EDITABLE(PageRange_entry), 0, -1);
			}else {
				gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(PageRange_Pages_button), 1);
				gtk_widget_set_sensitive(PageRange_entry, TRUE);
				if(NULL != page_range){
					gtk_entry_set_text(GTK_ENTRY(PageRange_entry), page_range);
				}
			}
			free(page_range);
			page_range = NULL;
		}

		max_copies = GetPDLDataInt(ID_MAX_COPIES, 0);
		if(Copies_adj != NULL){
			if(max_copies != 0){
				GTK_ADJUSTMENT(Copies_adj)->upper = max_copies;
				gtk_spin_button_set_adjustment(GTK_SPIN_BUTTON(Copies_spinbutton), GTK_ADJUSTMENT(Copies_adj));
			}else{
				if((printer_type == PRINTER_TYPE_CAPT) || (printer_type == PRINTER_TYPE_CAPT_BIND)){
					max_copies = CAPT_DEFAULT_COPIES_MAX;
				}else{
					max_copies = OTHER_DEFAULT_COPIES_MAX;
				}
				GTK_ADJUSTMENT(Copies_adj)->upper = max_copies;
				gtk_spin_button_set_adjustment(GTK_SPIN_BUTTON(Copies_spinbutton), GTK_ADJUSTMENT(Copies_adj));
			}
		}
		gtk_label_set_text(GTK_LABEL(Copies_label), " ");
		copies = GetPDLDataInt(ID_CNCOPIES, 1);
		gtk_spin_button_set_value(GTK_SPIN_BUTTON(Copies_spinbutton), copies);

		reverse = GetPDLData(ID_OUTPUTORDER);
		if(reverse != NULL){
			if(strcmp(reverse, "reverse") == 0){
				gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(Reverse_checkbutton), TRUE);
			}else{
				gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(Reverse_checkbutton), FALSE);
			}
			free(reverse);
			reverse = NULL;
		}
	}

	if(g_print_file != NULL){
#ifdef OLD_GTK
		gtk_label_set_text(GTK_LABEL(GTK_BUTTON(MainSave_button)->child), _("Print and Save Settings"));
#else
		gtk_button_set_label(GTK_BUTTON(MainSave_button), _("Print and Save Settings"));
#endif
	}else{
#ifdef OLD_GTK
		gtk_label_set_text(GTK_LABEL(GTK_BUTTON(MainSave_button)->child), _("Save Settings"));
#else
		gtk_button_set_label(GTK_BUTTON(MainSave_button), _("Save Settings"));
#endif
	}
	gtk_widget_set_sensitive(Property_button, enable);
	gtk_widget_set_sensitive(MainSave_button, enable);
	if(enable && (NULL == g_print_file)){
		enable = FALSE;
	}
	gtk_widget_set_sensitive(MainOK_button, enable);
}

int CreateMainDlg(const char* print_file, const char *domain)
{
	GtkWidget *MainDlg = NULL;
	GtkWidget *PrinterName_combo = NULL;
	GtkWidget *PrinterName_combo_entry = NULL;
	GtkWidget *Property_button = NULL;
	GtkWidget *SetAllPage_radiobutton = NULL;
	GtkWidget *OddPages_radiobutton = NULL;
	GtkWidget *EvenPages_radiobutton = NULL;
	GtkWidget *RangeAllPage_radiobutton = NULL;
	GtkWidget *SelPages_radiobutton = NULL;
	GtkWidget *PageSelection_entry = NULL;
	GtkWidget *Copies_spinbutton = NULL;
	GtkWidget *ReverseOrder_checkbutton = NULL;
	GtkWidget *MainOK_button = NULL;
	GtkWidget *MainSave_button = NULL;
	GtkWidget *SetDefault_button = NULL;
	GtkWidget *MainCancel_button = NULL;
	char path[MAX_PATH];

#ifndef _UI_DEBUG
	close(1);
	g_stdout_fd = open("/dev/null", O_RDWR);
#endif

	if(GetAllPrinters() < 0){
		fprintf(stderr, "get printer failed.\n");
		DisposeMainDlg();
		return -1;
	}
	memset(path, 0, MAX_PATH);
	strcat(path, PACKAGE_CONFIG_DIR);
	strcat(path, GLADE_FILE);
	g_main_xml = glade_xml_new(path, "MainDlg", domain);
	MainDlg = glade_xml_get_widget(g_main_xml, "MainDlg");
	PrinterName_combo = glade_xml_get_widget(g_main_xml, "PrinterName_combo");
	PrinterName_combo_entry = glade_xml_get_widget(g_main_xml, "PrinterName_combo_entry");
	Property_button = glade_xml_get_widget(g_main_xml, "Property_button");
	SetDefault_button = glade_xml_get_widget(g_main_xml, "SetDefault_button");
	SetAllPage_radiobutton = glade_xml_get_widget(g_main_xml, "SetAllPage_radiobutton");
	OddPages_radiobutton = glade_xml_get_widget(g_main_xml, "OddPages_radiobutton");
	EvenPages_radiobutton = glade_xml_get_widget(g_main_xml, "EvenPages_radiobutton");
	RangeAllPage_radiobutton = glade_xml_get_widget(g_main_xml, "RangesAllPage_radiobutton");
	SelPages_radiobutton = glade_xml_get_widget(g_main_xml, "SelPages_radiobutton");
	PageSelection_entry = glade_xml_get_widget(g_main_xml, "PageSelection_entry");
	Copies_spinbutton = glade_xml_get_widget(g_main_xml, "Copies_spinbutton");
	ReverseOrder_checkbutton = glade_xml_get_widget(g_main_xml, "ReverseOrder_checkbutton");
	MainOK_button = glade_xml_get_widget(g_main_xml, "MainOK_button");
	MainSave_button = glade_xml_get_widget(g_main_xml, "MainSave_button");
	MainCancel_button = glade_xml_get_widget(g_main_xml, "MainCancel_button");

	g_print_file = print_file;
	if(0 < LoadPDL(g_main_xml, print_file)){
		g_load_lib_success = TRUE;
	}else{
		g_load_lib_success = FALSE;
	}

	SigMainDisable();
	UpdateMainDlg();
	SigMainEnable();

	g_signal_connect((gpointer)PrinterName_combo_entry, "changed", G_CALLBACK(on_PrinterName_combo_entry_changed), NULL);
	if(PrinterName_combo != NULL){
		g_signal_connect(G_OBJECT(GTK_COMBO(PrinterName_combo)->popwin), "event", GTK_SIGNAL_FUNC(on_PrinterName_combo_popwin_event), NULL);
	}
	g_signal_connect((gpointer)PrinterName_combo_entry, "event", GTK_SIGNAL_FUNC(on_PrinterName_combo_down_up_event), NULL);
	g_signal_connect((gpointer)Property_button, "clicked", G_CALLBACK(on_Property_button_clicked), NULL);
	g_signal_connect((gpointer)SetDefault_button, "clicked", G_CALLBACK(on_SetDefault_button_clicked), NULL);
	g_signal_connect((gpointer)MainOK_button, "clicked", G_CALLBACK(on_MainOK_button_clicked), NULL);
	g_signal_connect((gpointer)MainSave_button, "clicked", G_CALLBACK(on_MainSave_button_clicked), NULL);
	g_signal_connect((gpointer)SetAllPage_radiobutton, "toggled", G_CALLBACK(on_SetAllPage_radiobutton_toggled), NULL);
	g_signal_connect((gpointer)OddPages_radiobutton, "toggled", G_CALLBACK(on_OddPages_radiobutton_toggled), NULL);
	g_signal_connect((gpointer) EvenPages_radiobutton, "toggled", G_CALLBACK(on_EvenPages_radiobutton_toggled), NULL);
	g_signal_connect((gpointer)RangeAllPage_radiobutton, "toggled", G_CALLBACK(on_RangeAllPage_radiobutton_toggled), NULL);
	g_signal_connect((gpointer) SelPages_radiobutton, "toggled", G_CALLBACK(on_SelPages_radiobutton_toggled), NULL);
	g_signal_connect((gpointer) PageSelection_entry, "changed", G_CALLBACK (on_PageSelection_entry_changed), NULL);
	g_signal_connect((gpointer) PageSelection_entry, "focus_out_event", G_CALLBACK (on_PageSelection_entry_focus_out_event), NULL);
	g_signal_connect ((gpointer) Copies_spinbutton, "value_changed", G_CALLBACK (on_Copies_spinbutton_changed), NULL);
	g_signal_connect ((gpointer) ReverseOrder_checkbutton, "toggled", G_CALLBACK (on_ReverseOrder_checkbutton_toggled), NULL);
	g_signal_connect((gpointer)MainCancel_button, "clicked", G_CALLBACK(on_MainCancel_button_clicked), NULL);
	g_signal_connect ((gpointer) MainDlg, "delete_event", G_CALLBACK (on_MainDlg_delete_event), NULL);
	g_signal_connect ((gpointer) MainDlg, "destroy", G_CALLBACK (gtk_main_quit), NULL);

	gtk_widget_show (MainDlg);
	return 0;
}

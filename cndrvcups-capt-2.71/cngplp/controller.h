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


#ifndef _CONTROLLER
#define _CONTROLLER

#include <glade/glade.h>
#include <gmodule.h>
#include "cngplpmod.h"
#include "configurefile.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#define MAXWORDSIZE 512

#ifdef ENABLE_NLS
#  include <libintl.h>
#  undef _
#  define _(String) dgettext (GETTEXT_PACKAGE, String)
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

typedef struct top_widget_save_data{
	int id;
	char *key_value;
}TopWidgetSaveData;

typedef struct top_widget{
	char *name;
	GladeXML *xml;
	GList *save_data;
}TopWidget;

typedef struct{
	char *widget_name;
	void (*InitWidget)(GladeXML *xml, cngplpData *data, const gpointer *widget);
	void (*ConnectSignal)(GladeXML *xml, cngplpData *data, gpointer *widget);
	void (*SpecialFunction)(cngplpData *data, const char *widget_name);
}WidgetInformation;

int InitFunctions();
gboolean InitController(GtkWidget *main_dlg, char *printer_name, char *print_file_name, const gboolean first_load);
void CloseController();
char *GetData(int id);
int GetDataInt(int id, int def);
char *GetData2(const int id);
extern GladeXML *g_cngplp_xml;
extern cngplpData *g_cngplp_data;
extern ConfigFile *g_config_file_data;
extern GList *g_topwidget_list;
extern const char *g_main_dlg_name;
extern FuncInfo *g_load_func;
extern WidgetInformation *g_widget_table;

#ifdef __cplusplus
}
#endif

#endif

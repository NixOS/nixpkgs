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


#ifndef __MAINWND
#define __MAINWND

#include <gtk/gtk.h>
#include <glade/glade.h>

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

extern GladeXML* g_main_xml;
int CreateMainDlg(const char* print_file, const char *domain);

enum{
	ID_COMMON_OPTION = 2000,
	ID_CNCOPIES,
	ID_PAGE_SET,
	ID_PAGE_RANGES,
	ID_OUTPUTORDER,
	ID_NUMBER_UP,
	ID_ORIENTATION_REQUESTED,
	ID_BRIGHTNESS,
	ID_GAMMA,
	ID_JOB_SHEETS_START,
	ID_JOB_SHEETS_END,
	ID_PRINTERNAME,
	ID_FILTER,
	ID_MEDIA,
	ID_CNQUEUEDESCRIPTION,
	ID_CNHOSTADDRESIPV4,
	ID_CNHOSTADDRESIPV6,
	ID_COMMON_OPTION_BOTTOM
};

enum{
	ID_BOTTON_EVENT = 2500,
	ID_SETDEFAULT,
	ID_EXECLPR,
	ID_SHOWDLG,
	ID_OK,
	ID_CANCEL,
	ID_PRINTERINFO,
	ID_RESTOREDEFAULT,

	ID_BOTTON_EVENT_BOTTOM
};

#endif

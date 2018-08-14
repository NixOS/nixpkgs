confdir = /usr/share/cngplp

lib_LTLIBRARIES=libuictlcapt.la
SUBDIRS=po cngplpmod controls files

INCLUDES=-DPACKAGE_CONFIG_DIR=\""$(confdir)/"\"\
	 -DPACKAGE_LOCALE_DIR=\""$(prefix)/$(DATADIRNAME)/locale"\" \
	 -I$(top_srcdir)/cngplpmod\
	 -I$(top_srcdir)/controls/combo\
	 -I$(top_srcdir)/controls/checkbutton\
	 -I$(top_srcdir)/controls/dialog\
	 -I$(top_srcdir)/controls/radiobutton\
	 -I$(top_srcdir)/controls/button\
	 -I$(top_srcdir)/controls/spinbutton\
	 -I$(top_srcdir)/controls/entry\
	 -I$(top_srcdir)/controls/label\
	 -I$(top_srcdir)/controls/textview\
	 @PACKAGE_CFLAGS@  @GLADE_PACKAGE_CFLAGS@

libuictlcapt_la_LDFLAGS = \
	-shared \
	-version-info 1:0:0

libuictlcapt_la_SOURCES=configurefile.c configurefile.h\
			   controller.c controller.h\
			   localize.c localize.h\
			   widgets.c widgets.h\
			   cngplpmodIF.h cngplpmodIF.c

AM_CFLAGS=-O2 -Wall -fPIC
libuictlcapt_la_LIBADD =  -lglade-2.0 -lcups\
			$(top_srcdir)/cngplpmod/libcngplpmod.la\
			$(top_srcdir)/controls/button/libcaptbutton.la\
			$(top_srcdir)/controls/combo/libcaptcombo.la\
			$(top_srcdir)/controls/entry/libcaptentry.la\
			$(top_srcdir)/controls/spinbutton/libcaptspinbutton.la\
			$(top_srcdir)/controls/checkbutton/libcaptcheckbutton.la\
			$(top_srcdir)/controls/dialog/libcaptdialog.la\
			$(top_srcdir)/controls/label/libcaptlabel.la\
			$(top_srcdir)/controls/radiobutton/libcaptradiobutton.la\
			$(top_srcdir)/controls/textview/libcapttextview.la

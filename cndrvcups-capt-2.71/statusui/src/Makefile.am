## Process this file with automake to produce Makefile.in

INCLUDES = \
	-DPACKAGE_DATA_DIR=\""$(datadir)"\" \
	-DPACKAGE_LOCALE_DIR=\""$(prefix)/$(DATADIRNAME)/locale"\" \
	-I/usr/include/libxml2\
	-I../cnsktmodule\
	@PACKAGE_CFLAGS@

#AM_CFLAGS = -Wall -O2 -g -D_UI_DEBUG
AM_CFLAGS = -Wall -O2 -fPIC

bin_PROGRAMS = captstatusui


captstatusui_SOURCES = \
	main.c \
	support.c support.h \
	interface.c interface.h \
	callbacks.c callbacks.h \
	dialog.c dialog.h \
	widgets.c widgets.h \
	uimain.c uimain.h \
	ppapdlg.c ppapdlg.h \
	devdlg.c devdlg.h \
	msgdlg.c msgdlg.h \
	data_process.c data_process.h \
	ppapdata.c ppapdata.h \
	ccinfodlg.c ccinfodlg.h \
	regipaperdlg.c regipaperdlg.h \
	sleepsdlg.c sleepsdlg.h \
	networksdlg.c networksdlg.h \
	cancelkeydlg.c cancelkeydlg.h \
	asstprtsdlg.c asstprtsdlg.h \
	startupsettingsdlg.c startupsettingsdlg.h \
	cassetteset2dlg.c cassetteset2dlg.h \
	multitraydlg.c multitraydlg.h \
	ppavhdlg.c ppavhdlg.h \
	resetunitdlg.c resetunitdlg.h \
	tonerreplacementdlg.c tonerreplacementdlg.h \
	cleaningdlg.c cleaningdlg.h \
	calibrationsettingsdlg.c calibrationsettingsdlg.h


captstatusui_LDADD = -lgtk-x11-2.0   -lxml2 -lcups ../cnsktmodule/libcnsktmodule.la


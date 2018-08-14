noinst_LTLIBRARIES=libcaptdialog.la

libcaptdialog_la_SOURCES=dialog.c dialog.h

INCLUDES=-I$(top_srcdir)/cngplpmod\
	 -I$(top_srcdir)\
         @PACKAGE_CFLAGS@\
         @GLADE_PACKAGE_CFLAGS@

AM_CFLAGS=-Wall -O2 -fPIC
libcaptdialog_la_LIBADD= -lglade-2.0

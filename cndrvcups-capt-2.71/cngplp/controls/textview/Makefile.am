noinst_LTLIBRARIES=libcapttextview.la

libcapttextview_la_SOURCES=textview.c textview.h

INCLUDES=-I$(top_srcdir)/cngplpmod\
	 -I$(top_srcdir)\
         @PACKAGE_CFLAGS@\
         @GLADE_PACKAGE_CFLAGS@

AM_CFLAGS=-Wall -O2 -fPIC
libcapttextview_la_LIBADD= -lglade-2.0

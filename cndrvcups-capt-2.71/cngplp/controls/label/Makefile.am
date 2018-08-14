noinst_LTLIBRARIES=libcaptlabel.la

libcaptlabel_la_SOURCES=label.c label.h

INCLUDES=-I$(top_srcdir)/cngplpmod\
	 -I$(top_srcdir)\
         @PACKAGE_CFLAGS@\
         @GLADE_PACKAGE_CFLAGS@

AM_CFLAGS=-Wall -O2 -fPIC
libcaptlabel_la_LIBADD= -lglade-2.0

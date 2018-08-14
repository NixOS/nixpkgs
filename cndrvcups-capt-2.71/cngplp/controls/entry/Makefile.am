noinst_LTLIBRARIES=libcaptentry.la

libcaptentry_la_SOURCES=entry.c entry.h

INCLUDES=-I$(top_srcdir)/cngplpmod\
	 -I$(top_srcdir)\
         @PACKAGE_CFLAGS@\
         @GLADE_PACKAGE_CFLAGS@

AM_CFLAGS=-Wall -O2 -fPIC
libcaptentry_la_LIBADD= -lglade-2.0

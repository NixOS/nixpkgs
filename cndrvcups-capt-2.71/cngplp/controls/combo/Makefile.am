noinst_LTLIBRARIES=libcaptcombo.la

libcaptcombo_la_SOURCES=combo.c combo.h

INCLUDES=-I$(top_srcdir)/cngplpmod\
	 -I$(top_srcdir)\
         @PACKAGE_CFLAGS@\
         @GLADE_PACKAGE_CFLAGS@

AM_CFLAGS=-Wall -O2 -fPIC
libcaptcombo_la_LIBADD= -lglade-2.0

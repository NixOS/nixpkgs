noinst_LTLIBRARIES=libcaptbutton.la
libcaptbutton_la_SOURCES=button.c button.h

INCLUDES=-I$(top_srcdir)/cngplpmod\
	 -I$(top_srcdir)\
         @PACKAGE_CFLAGS@\
         @GLADE_PACKAGE_CFLAGS@

AM_CFLAGS= -Wall -O2 -fPIC

libcaptbutton_la_LIBADD= -lglade-2.0

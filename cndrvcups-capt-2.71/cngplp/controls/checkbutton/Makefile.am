noinst_LTLIBRARIES=libcaptcheckbutton.la

libcaptcheckbutton_la_SOURCES=checkbutton.c checkbutton.h

INCLUDES=-I$(top_srcdir)/cngplpmod\
	 -I$(top_srcdir)\
         @PACKAGE_CFLAGS@\
         @GLADE_PACKAGE_CFLAGS@

AM_CFLAGS=-Wall -O2 -fPIC

libcaptcheckbutton_la_LIBADD= -lglade-2.0

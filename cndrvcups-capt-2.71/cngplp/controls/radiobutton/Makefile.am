noinst_LTLIBRARIES=libcaptradiobutton.la

libcaptradiobutton_la_SOURCES=radiobutton.c radiobutton.h

INCLUDES=-I$(top_srcdir)/cngplpmod\
	 -I$(top_srcdir)\
         @PACKAGE_CFLAGS@\
         @GLADE_PACKAGE_CFLAGS@

AM_CFLAGS=-Wall -O2 -fPIC
libcaptradiobutton_la_LIBADD= -lglade-2.0

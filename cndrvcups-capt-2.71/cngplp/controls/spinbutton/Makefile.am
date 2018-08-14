noinst_LTLIBRARIES=libcaptspinbutton.la

libcaptspinbutton_la_SOURCES=spinbutton.c spinbutton.h

INCLUDES=-I$(top_srcdir)/cngplpmod\
	 -I$(top_srcdir)\
         @PACKAGE_CFLAGS@\
         @GLADE_PACKAGE_CFLAGS@

AM_CFLAGS=-Wall -O2 -fPIC
libcaptspinbutton_la_LIBADD= -lglade-2.0

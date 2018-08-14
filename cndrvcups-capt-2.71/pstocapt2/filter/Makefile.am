filterdir = $(libdir)/cups/filter

filter_PROGRAMS = pstocapt2

pstocapt2_SOURCES = \
	pstocapt2.c paramlist.c paramlist.h

pstocapt2_LDADD = -lbuftool -lcups 

AM_CFLAGS = -O2 -Wall -fPIC

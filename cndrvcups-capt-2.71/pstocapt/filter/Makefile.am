filterdir = $(libdir)/cups/filter

filter_PROGRAMS = pstocapt

pstocapt_SOURCES = \
	pstocapt.c paramlist.c paramlist.h

pstocapt_LDADD = -lbuftool -lcups 

AM_CFLAGS = -O2 -Wall -fPIC

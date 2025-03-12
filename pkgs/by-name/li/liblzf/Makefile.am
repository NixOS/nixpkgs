lib_LTLIBRARIES = liblzf.la
liblzf_la_SOURCES = lzf_c.c lzf_d.c
liblzf_la_LDFLAGS = -no-undefined -version-info @LZF_LT_VERSION_INFO@

include_HEADERS = lzf.h lzfP.h

bin_PROGRAMS = lzf
lzf_SOURCES = lzf.c
lzf_LDADD = liblzf.la

# skip lzcat since it conflicts with lzma tool
install-exec-hook:
	cd $(DESTDIR)$(bindir) && $(LN_S) -f lzf unlzf

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = liblzf.pc

EXTRA_DIST = README LICENSE Changes

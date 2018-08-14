###################################################
#                                           	  #
#  Vector Driver API Generi C3PL Driver)          #
#          Makefile 				  			  #
#                                           	  #
###################################################

##### Macro #####
# Compiler Definition
CC=gcc

# Directories
CLIBDIR=$(LIBDIR)
CLIENT_INSTALLDIR = $(DESTDIR)$(CLIBDIR)
IPCLIBDIR = ./ipclib

# Compile/Link Options
#LINKOPTIONS_R=-o
LINKOPTIONS_R=-g -o
#CPOPTIONS_R=-c
CPOPTIONS_R=-g -c

INCLUDE=-I. -I$(IPCLIBDIR) -I/usr/include

#CFLAGS_R=-Wall -g -fPIC -DDEBUG  -DDEBUG_SLEEP
#CFLAGS_R=-Wall -g -fPIC -DDEBUG
CFLAGS_R=-Wall -fPIC -O2

### Edit Below According to each Libraries ###

# Library File Name
LIBNAME=canonc3pl
VERSION_MAJOR=1
VERSION_MINOR=0.0
LIBNAME_LINKER=lib$(LIBNAME).so
LIBNAME_SO=lib$(LIBNAME).so.$(VERSION_MAJOR)
LIBNAME_REAL=lib$(LIBNAME).so.$(VERSION_MAJOR).$(VERSION_MINOR)

# Link Options (library name to link with)
CLIENT_LIBS =

##### Target Files for Client Library #####
# Target Source Files for Client Library
CLIENT_SRCS=\
	$(IPCLIBDIR)/opvp_rpc_client.c\
	$(IPCLIBDIR)/opvp_rpc_client_02.c\
	$(IPCLIBDIR)/opvp_rpc_core.c
	
# Target Object Files for Client Library
CLIENT_OBJS=\
	$(IPCLIBDIR)/opvp_rpc_client.o\
	$(IPCLIBDIR)/opvp_rpc_client_02.o\
	$(IPCLIBDIR)/opvp_rpc_core.o

# Depending Header Files for Client Library
CLIENT_DEPENDENT_HEADERS=\
	$(IPCLIBDIR)/opvp_rpc_client.h\
	$(IPCLIBDIR)/opvp_rpc_client_02.h\
	$(IPCLIBDIR)/opvp.h\
	$(IPCLIBDIR)/opvp_02.h\
	$(IPCLIBDIR)/opvp_rpc_core.h\
	$(IPCLIBDIR)/opvp_rpc_reqno.h\
	$(IPCLIBDIR)/opvp_rpc_reqno_02.h


##### Command #####
.SILENT:


##### Main Targe #####
.PHONY : all, client
all : $(LIBNAME_REAL)
client : $(LIBNAME_REAL)

### Link : Client Library ###
$(LIBNAME_REAL): $(CLIENT_OBJS)
	@echo Linking library $(LIBNAME_REAL) ...
	$(CC) $(LINKOPTIONS_R) $@ $(CLIENT_OBJS) -shared -Wl,-soname,$(LIBNAME_REAL) $(LIBFLAGS_R) $(CLIENT_LIBS)


### Compile : No Editing is necessary ###
%.o: %.c
	@echo Compiling $< ...
	$(CC) $(CPOPTIONS_R) $< $(CFLAGS_R) $(INCLUDE) -o $@


### Specifying Depending Header FilesFNo Editing is necessary ###
$(CLIENT_OBJS) : $(CLIENT_DEPENDENT_HEADERS)


### Other Depending Files ###
$(CLIENT_OBJS) : Makefile


### Install : No Editing is necessary ###
# for Release
install:
	strip $(LIBNAME_REAL)
	@echo cp $(LIBNAME_REAL) $(CLIENT_INSTALLDIR)
	cp $(LIBNAME_REAL) $(CLIENT_INSTALLDIR)


### Clean-up : No Editing is necessary ###
clean:
	@echo rm -rf $(LIBNAME_REAL) $(CLIENT_OBJS) *~ core
	rm -rf $(LIBNAME_REAL) $(CLIENT_OBJS) *~ core


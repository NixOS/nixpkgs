#################################################
# CAPT Driver for PDAPI                         #
#   Integrated Makefile                         #
#################################################

### Macros ###
DRIVERDIR  = driver
FILTERDIR  = pstocapt
FILTERDIR2 = pstocapt2
FILTERDIR3 = pstocapt3
PPDDIR     = ppd
BACKENDDIR = backend
CNGPLPDIR  = cngplp
STATUSDIR  = statusui
SRCDIRS =\
	$(DRIVERDIR)\
	$(BACKENDDIR)\
	$(FILTERDIR)\
	$(FILTERDIR2)\
	$(FILTERDIR3)\
	$(STATUSDIR)\
	$(PPDDIR)\
	$(CNGPLPDIR)

### Make modules ###
all:
	for dir in $(SRCDIRS); do\
		echo Making modules $$dir ...;\
		(cd $$dir; make) || exit 1;\
	done
	echo Make completed.

### Install modules ###
install:
	for dir in $(SRCDIRS); do\
		echo Installing modules $$dir ...;\
		(cd $$dir; make install) || exit 1;\
	done

### Uninstall modules ###
uninstall:
	for dir in $(SRCDIRS); do\
		echo Uninstalling modules $$dir ...;\
		(cd $$dir; make uninstall) || exit 1;\
	done

### Clean-up objects files ###
clean:
	for dir in $(SRCDIRS); do\
		echo Cleaning $$dir ...;\
		(cd $$dir; make clean) || exit 1;\
	done

### Clean-up objects and configure files ###
distclean:
	for dir in $(SRCDIRS); do\
		echo distclean $$dir ...;\
		(cd $$dir; make distclean) || exit 1;\
	done

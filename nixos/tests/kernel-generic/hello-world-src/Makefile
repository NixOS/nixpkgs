ifneq ($(KERNELRELEASE),)
# kbuild part of makefile
obj-m := hello.o
else
# normal makefile
KDIR ?= /lib/modules/`uname -r`/build

.PHONY: modules
modules:
	$(MAKE) -C $(KDIR) M=$$PWD modules

.PHONY: modules_install
modules_install:
	$(MAKE) -C $(KDIR) M=$$PWD modules_install
endif

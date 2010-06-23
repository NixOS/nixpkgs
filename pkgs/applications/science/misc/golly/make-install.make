
install_file = echo "\#! /bin/sh" > "$(out)/bin/$(binfile)"; echo "$(out)/share/golly/$(binfile)" >> "$(out)/bin/$(binfile)"; chmod a+x "$(out)/bin/$(binfile)";

install:
	mkdir -p "$(out)/share/golly"
	mkdir -p "$(out)/bin"
	cp -r $(BINFILES) $(SHAREDFILES) "$(out)/share/golly"
	$(foreach binfile,$(BINFILES),$(install_file))


.PHONY: clean iso all

clean:
	rm -rf result

iso:
	nix build '.#iso'

install:
	sudo cp result/iso/nixos.iso ~/Downloads/nixos.iso

all: clean iso

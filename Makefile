.PHONY: clean iso all

clean:
	rm -rf result

iso:
	nix --extra-experimental-features nix-command --extra-experimental-features flakes build '.#iso'

install:
	sudo cp result/iso/nixos.iso ~/Downloads/nixos.iso

all: clean iso

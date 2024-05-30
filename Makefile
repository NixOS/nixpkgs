.PHONY: clean iso ipxe install all default

default:
	echo 'you must choose one of: clean, iso, or netboot'

clean:
	rm -rf result

iso:
	nix build --extra-experimental-features nix-command --extra-experimental-features flakes -L --print-out-paths '.#iso'

netboot:
	nix build --extra-experimental-features nix-command --extra-experimental-features flakes -L --print-out-paths '.#netboot'

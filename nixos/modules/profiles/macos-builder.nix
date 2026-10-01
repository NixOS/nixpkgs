let
  lib = import ../../../lib;
in
lib.warnIf (lib.isInOldestRelease 2411)
  "nixos/modules/profiles/macos-builder.nix has moved to nixos/modules/profiles/nix-builder-vm.nix; please update your NixOS imports."
  ./nix-builder-vm.nix

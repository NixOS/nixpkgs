{ bash }:
let
  # WARNING: this attribute is used by nix-shell so it shouldn't be removed/renamed
  bashInteractive = bash;
in
bashInteractive

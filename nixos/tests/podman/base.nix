{ system ? builtins.currentSystem, pkgs ? import ../../.. { inherit system; } }:

pkgs.lib.recurseIntoAttrs {
  default = import ./default.nix { inherit system pkgs; };
  dnsname = import ./dnsname.nix { inherit system pkgs; };
  tls-ghostunnel = import ./tls-ghostunnel.nix { inherit system pkgs; };
}

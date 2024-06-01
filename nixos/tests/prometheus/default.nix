{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
}:

{
  federation = import ./federation.nix { inherit system pkgs; };
  prometheus-pair = import ./prometheus-pair.nix { inherit system pkgs; };
  pushgateway = import ./pushgateway.nix { inherit system pkgs; };
  remote-write = import ./remote-write.nix { inherit system pkgs; };
}

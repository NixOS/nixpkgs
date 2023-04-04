{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
}:

{
  basic = import ./basic.nix { inherit system pkgs; };
  config-activation = import ./config-activation.nix { inherit system pkgs; };
  daemon-mount = import ./daemon-mount.nix { inherit system pkgs; };
  imperative = import ./imperative.nix { inherit system pkgs; };
  macvlan = import ./macvlan.nix { inherit system pkgs; };
  migration = import ./migration.nix { inherit system pkgs; };
  nat = import ./nat.nix { inherit system pkgs; };
  wireguard = import ./wireguard.nix { inherit system pkgs; };
}

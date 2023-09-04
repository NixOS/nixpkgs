{
  system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../../.. {inherit system config;},
}: {
  container = import ./container.nix {inherit system pkgs;};
  nftables = import ./nftables.nix {inherit system pkgs;};
  ui = import ./ui.nix {inherit system pkgs;};
  virtual-machine = import ./virtual-machine.nix { inherit system pkgs; };
}

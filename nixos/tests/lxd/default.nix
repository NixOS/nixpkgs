{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
  handleTestOn,
}:
{
  container = import ./container.nix { inherit system pkgs; };
  nftables = import ./nftables.nix { inherit system pkgs; };
  preseed = import ./preseed.nix { inherit system pkgs; };
  ui = import ./ui.nix { inherit system pkgs; };
  virtual-machine = handleTestOn [ "x86_64-linux" ] ./virtual-machine.nix { inherit system pkgs; };
}

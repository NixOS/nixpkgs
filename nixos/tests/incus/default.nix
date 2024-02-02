{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
  handleTestOn,
}:
{
  container = import ./container.nix { inherit system pkgs; };
  lxd-to-incus = import ./lxd-to-incus.nix { inherit system pkgs; };
  preseed = import ./preseed.nix { inherit system pkgs; };
  socket-activated = import ./socket-activated.nix { inherit system pkgs; };
  virtual-machine = handleTestOn [ "x86_64-linux" ] ./virtual-machine.nix { inherit system pkgs; };
}

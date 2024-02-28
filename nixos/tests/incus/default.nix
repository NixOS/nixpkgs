{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
  handleTestOn,
}:
{
  container-old-init = import ./container.nix { inherit system pkgs; };
  container-new-init = import ./container.nix { inherit system pkgs; extra = {
    # Enable new systemd init
    boot.initrd.systemd.enable = true;
  }; };
  lxd-to-incus = import ./lxd-to-incus.nix { inherit system pkgs; };
  preseed = import ./preseed.nix { inherit system pkgs; };
  socket-activated = import ./socket-activated.nix { inherit system pkgs; };
  ui = import ./ui.nix {inherit system pkgs;};
  virtual-machine = handleTestOn [ "x86_64-linux" ] ./virtual-machine.nix { inherit system pkgs; };
}

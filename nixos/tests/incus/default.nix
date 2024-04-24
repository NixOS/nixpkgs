{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
  handleTestOn,
}:
{
  container-legacy-init = import ./container.nix {
    name = "container-legacy-init";
    inherit system pkgs;
  };
  container-systemd-init = import ./container.nix {
    name = "container-systemd-init";
    inherit system pkgs;
    extra = {
      boot.initrd.systemd.enable = true;
    };
  };
  lxd-to-incus = import ./lxd-to-incus.nix { inherit system pkgs; };
  openvswitch = import ./openvswitch.nix { inherit system pkgs; };
  preseed = import ./preseed.nix { inherit system pkgs; };
  socket-activated = import ./socket-activated.nix { inherit system pkgs; };
  storage = import ./storage.nix { inherit system pkgs; };
  ui = import ./ui.nix { inherit system pkgs; };
  virtual-machine = handleTestOn [ "x86_64-linux" ] ./virtual-machine.nix { inherit system pkgs; };
}

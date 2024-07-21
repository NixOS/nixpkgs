{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
  handleTestOn,
  incus ? pkgs.incus-lts,
}:
{
  container-legacy-init = import ./container.nix {
    name = "container-legacy-init";
    inherit incus system pkgs;
  };
  container-systemd-init = import ./container.nix {
    name = "container-systemd-init";
    inherit incus system pkgs;
    extra = {
      boot.initrd.systemd.enable = true;
    };
  };
  incusd-options = import ./incusd-options.nix { inherit incus system pkgs; };
  lxd-to-incus = import ./lxd-to-incus.nix { inherit incus system pkgs; };
  openvswitch = import ./openvswitch.nix { inherit incus system pkgs; };
  socket-activated = import ./socket-activated.nix { inherit incus system pkgs; };
  storage = import ./storage.nix { inherit incus system pkgs; };
  ui = import ./ui.nix { inherit incus system pkgs; };
  virtual-machine = handleTestOn [ "x86_64-linux" ] ./virtual-machine.nix {
    inherit incus system pkgs;
  };
}

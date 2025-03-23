{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
  lts ? true,
  ...
}:
let
  incusTest = import ./incus-tests.nix;
in
{
  all = incusTest {
    inherit lts pkgs system;
    allTests = true;
  };

  container = incusTest {
    inherit lts pkgs system;
    instanceContainer = true;
  };

  lvm = incusTest {
    inherit lts pkgs system;
    storageLvm = true;
  };

  lxd-to-incus = import ./lxd-to-incus.nix {
    inherit lts pkgs system;
  };

  openvswitch = incusTest {
    inherit lts pkgs system;
    networkOvs = true;
  };

  ui = import ./ui.nix {
    inherit lts pkgs system;
  };

  virtual-machine = incusTest {
    inherit lts pkgs system;
    instanceVm = true;
  };

  zfs = incusTest {
    inherit lts pkgs system;
    storageLvm = true;
  };
}

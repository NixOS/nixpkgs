{
  lts ? true,
  ...
}:
let
  incusTest = import ./incus-tests.nix;
in
{
  all = incusTest {
    inherit lts;
    allTests = true;
  };

  container = incusTest {
    inherit lts;
    instanceContainer = true;
  };

  lvm = incusTest {
    inherit lts;
    storageLvm = true;
  };

  lxd-to-incus = import ./lxd-to-incus.nix { };

  openvswitch = incusTest {
    inherit lts;
    networkOvs = true;
  };

  ui = import ./ui.nix { };

  virtual-machine = incusTest {
    inherit lts;
    instanceVm = true;
  };

  zfs = incusTest {
    inherit lts;
    storageLvm = true;
  };
}

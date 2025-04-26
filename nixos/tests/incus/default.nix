{
  runTest,
  lts ? true,
  ...
}:
let
  incusTest =
    config:
    runTest {
      imports = [
        ./incus-tests-module.nix
        ./incus-tests.nix
      ];

      tests.incus = {
        inherit lts;
      }
      // config;
    };
in
{
  all = incusTest { all = true; };

  appArmor = incusTest {
    all = true;
    appArmor = true;
  };

  container = incusTest { instance.container = true; };

  lvm = incusTest { storage.lvm = true; };

  openvswitch = incusTest { network.ovs = true; };

  ui = runTest {
    imports = [ ./ui.nix ];

    _module.args = { inherit lts; };
  };

  virtual-machine = incusTest { instance.virtual-machine = true; };

  zfs = incusTest { storage.zfs = true; };
}

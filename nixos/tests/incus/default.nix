{
  runTest,
  lts ? true,
}:
let
  incusRunTest =
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
  all = incusRunTest { all = true; };

  appArmor = incusRunTest {
    all = true;
    appArmor = true;
  };

  container = incusRunTest { instance.container = true; };

  lvm = incusRunTest { storage.lvm = true; };

  openvswitch = incusRunTest { network.ovs = true; };

  ui = runTest {
    imports = [ ./ui.nix ];

    _module.args = { inherit lts; };
  };

  virtual-machine = incusRunTest { instance.virtual-machine = true; };

  zfs = incusRunTest { storage.zfs = true; };
}

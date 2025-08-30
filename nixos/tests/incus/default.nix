{
  package,
  runTest,
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
        inherit package;
      }
      // config;
    };
in
{
  # appArmor = incusRunTest {
  #   all = true;
  #   appArmor = true;
  # };

  container = incusRunTest {
    instances.c1 = {
      type = "container";
    };
  };

  # lvm = incusRunTest { storage.lvm = true; };
  #
  # openvswitch = incusRunTest { network.ovs = true; };

  ui = runTest {
    imports = [ ./ui.nix ];

    _module.args = { inherit package; };
  };

  virtual-machine = incusRunTest {
    instances = {
      vm1 = {
        type = "virtual-machine";
      };
    };
  };

  zfs = incusRunTest { storage.zfs = true; };
}

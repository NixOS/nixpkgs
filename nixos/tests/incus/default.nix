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
  all = incusRunTest {
    feature.user = true;

    instances = {
      c1 = {
        type = "container";
      };

      vm1 = {
        type = "virtual-machine";
      };
    };

    network = {
      ovs = true;
    };

    storage = {
      lvm = true;
      zfs = true;
    };
  };

  # appArmor = incusRunTest {
  #   all = true;
  #   appArmor = true;
  # };

  container = incusRunTest {
    instances.c1 = {
      type = "container";
    };
  };

  lvm = incusRunTest { storage.lvm = true; };

  openvswitch = incusRunTest { network.ovs = true; };

  ui = runTest {
    imports = [ ./ui.nix ];

    _module.args = { inherit package; };
  };

  virtual-machine = incusRunTest {
    instances = {
      vm1 = {
        type = "virtual-machine";
      };

      # TODO never becomes available
      # csm = {
      #   type = "virtual-machine";
      #   incusConfig.config = {
      #     "security.csm" = true;
      #   };
      # };
    };
  };

  zfs = incusRunTest { storage.zfs = true; };
}

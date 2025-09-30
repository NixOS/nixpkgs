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
    name = "all";
    appArmor = true;
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

  container = incusRunTest {
    name = "container";

    instances.c1 = {
      type = "container";
    };
  };

  lvm = incusRunTest {
    name = "lvm";

    storage.lvm = true;
  };

  openvswitch = incusRunTest {
    name = "openvswitch";

    network.ovs = true;
  };

  ui = runTest {
    imports = [ ./ui.nix ];

    _module.args = { inherit package; };
  };

  virtual-machine = incusRunTest {
    name = "virtual-machine";

    instances = {
      vm1 = {
        type = "virtual-machine";
      };

      # disabled because never becomes available
      # csm = {
      #   type = "virtual-machine";
      #   incusConfig.config = {
      #     "security.csm" = true;
      #   };
      # };
    };
  };

  zfs = incusRunTest {
    name = "zfs";

    storage.zfs = true;
  };
}

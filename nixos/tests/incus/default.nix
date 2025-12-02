{
  package,
  runTestOn,
}:
let
  incusRunTest =
    config:
    runTestOn [ "x86_64-linux" "aarch64-linux" ] {
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
  # this is the main test which will test as much as possible
  # run this for testing incus upgrades, also available in incus package tests
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

  # used in lxc tests to verify container functionality
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

  ui = runTestOn [ "x86_64-linux" "aarch64-linux" ] {
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

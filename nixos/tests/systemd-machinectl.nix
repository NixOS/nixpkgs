import ./make-test.nix (let

  container = { ... }: {
    boot.isContainer = true;

    # use networkd to obtain systemd network setup
    networking.useNetworkd = true;

    # systemd-nspawn expects /sbin/init
    boot.loader.initScript.enable = true;

    imports = [ ../modules/profiles/minimal.nix ];
  };

  containerSystem = (import ../lib/eval-config.nix {
    modules = [ container ];
  }).config.system.build.toplevel;

  containerName = "container";
  containerRoot = "/var/lib/machines/${containerName}";

in {
  name = "systemd-machinectl";

  machine = { lib, ... }: {
    # use networkd to obtain systemd network setup
    networking.useNetworkd = true;

    # open DHCP server on interface to container
    networking.firewall.trustedInterfaces = [ "ve-+" ];

    # do not try to access cache.nixos.org
    nix.binaryCaches = lib.mkForce [];

    virtualisation.pathsInNixDB = [ containerSystem ];
  };

  testScript = ''
    startAll;

    $machine->waitForUnit("default.target");
    $machine->succeed("mkdir -p ${containerRoot}");
    $machine->succeed("nixos-install --root ${containerRoot} --system ${containerSystem} --no-channel-copy --no-root-passwd --no-bootloader");

    $machine->succeed("machinectl start ${containerName}");
    $machine->waitUntilSucceeds("systemctl -M ${containerName} is-active default.target");
    $machine->succeed("ping -n -c 1 ${containerName}");
    $machine->succeed("test `stat ${containerRoot}/var/empty -c %u%g` != 00");

    $machine->succeed("machinectl stop ${containerName}");
  '';
})

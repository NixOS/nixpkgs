import ./make-test-python.nix (
  let

    container = {
      # We re-use the NixOS container option ...
      boot.isContainer = true;
      # ... and revert unwanted defaults
      networking.useHostResolvConf = false;

      # use networkd to obtain systemd network setup
      networking.useNetworkd = true;
      networking.useDHCP = false;

      # systemd-nspawn expects /sbin/init
      boot.loader.initScript.enable = true;

      imports = [ ../modules/profiles/minimal.nix ];
    };

    containerSystem = (import ../lib/eval-config.nix {
      modules = [ container ];
    }).config.system.build.toplevel;

    containerName = "container";
    containerRoot = "/var/lib/machines/${containerName}";

  in
  {
    name = "systemd-machinectl";

    machine = { lib, ... }: {
      # use networkd to obtain systemd network setup
      networking.useNetworkd = true;
      networking.useDHCP = false;
      services.resolved.enable = false;

      # open DHCP server on interface to container
      networking.firewall.trustedInterfaces = [ "ve-+" ];

      # do not try to access cache.nixos.org
      nix.settings.substituters = lib.mkForce [ ];

      virtualisation.additionalPaths = [ containerSystem ];
    };

    testScript = ''
      start_all()
      machine.wait_for_unit("default.target");

      # Install container
      machine.succeed("mkdir -p ${containerRoot}");
      # Workaround for nixos-install
      machine.succeed("chmod o+rx /var/lib/machines");
      machine.succeed("nixos-install --root ${containerRoot} --system ${containerSystem} --no-channel-copy --no-root-passwd");

      # Allow systemd-nspawn to apply user namespace on immutable files
      machine.succeed("chattr -i ${containerRoot}/var/empty");

      # Test machinectl start
      machine.succeed("machinectl start ${containerName}");
      machine.wait_until_succeeds("systemctl -M ${containerName} is-active default.target");

      # Test systemd-nspawn network configuration
      machine.succeed("ping -n -c 1 ${containerName}");

      # Test systemd-nspawn uses a user namespace
      machine.succeed("test `stat ${containerRoot}/var/empty -c %u%g` != 00");

      # Test systemd-nspawn reboot
      machine.succeed("machinectl shell ${containerName} /run/current-system/sw/bin/reboot");
      machine.wait_until_succeeds("systemctl -M ${containerName} is-active default.target");

      # Test machinectl reboot
      machine.succeed("machinectl reboot ${containerName}");
      machine.wait_until_succeeds("systemctl -M ${containerName} is-active default.target");

      # Test machinectl stop
      machine.succeed("machinectl stop ${containerName}");

      # Show to to delete the container
      machine.succeed("chattr -i ${containerRoot}/var/empty");
      machine.succeed("rm -rf ${containerRoot}");
    '';
  }
)

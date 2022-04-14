# Test whether fast reboots via kexec work.

import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "kexec";
  meta = with lib.maintainers; {
    maintainers = [ flokli lassulus ];
  };

  nodes = {
    node1 = { ... }: {
      virtualisation.vlans = [ ];
      virtualisation.memorySize = 4 * 1024;
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    };

    node2 = { modulesPath, ... }: {
      virtualisation.vlans = [ ];
      imports = [
        "${modulesPath}/installer/kexec/kexec-boot.nix"
      ];
    };
  };

  testScript = { nodes, ... }: ''
    node1.wait_for_unit("multi-user.target")
    node1.succeed('kexec --load /run/current-system/kernel --initrd /run/current-system/initrd --command-line "$(</proc/cmdline)"')
    node1.execute("systemctl kexec >&2 &", check_return=False)
    node1.connected = False
    node1.connect()
    node1.wait_for_unit("multi-user.target")

    # Check the machine with kexec-boot.nix profile boots up
    node2.wait_for_unit("multi-user.target")
    node2.shutdown()

    # Kexec node1 to the toplevel of node2 via the kexec-boot script
    node1.succeed('touch /run/foo')
    node1.execute('${nodes.node2.config.system.build.kexecBoot}/kexec-boot', check_return=False)
    node1.succeed('! test -e /run/foo')

    node1.shutdown()
  '';
})

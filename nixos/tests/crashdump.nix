import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "crashdump";

  nodes.machine = { config, ... }: {
    boot.crashDump = {
      enable = true;
      kernelParams = config.boot.kernelParams ++ ["1"];
    };
  };

  testScript = ''
    machine.wait_for_unit("sysinit.target")

    # /var/lib/nixos/ files get corrupted if you crash before changes
    # from the users-groups activation script sync
    machine.succeed("sync")

    machine.execute("echo c > /proc/sysrq-trigger &", check_output=False)
    machine.connected = False
    machine.connect()
    machine.wait_for_unit("rescue.target")
    machine.succeed("stat /proc/vmcore")
  '';
})

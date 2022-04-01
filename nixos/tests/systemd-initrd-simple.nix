import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "systemd-initrd-simple";

  machine = { pkgs, ... }: {
    boot.initrd.systemd = {
      enable = true;
      emergencyAccess = true;
    };
    fileSystems = lib.mkVMOverride {
      "/".autoResize = true;
    };
  };

  testScript = ''
    import subprocess

    oldAvail = machine.succeed("df --output=avail / | sed 1d")
    machine.shutdown()

    subprocess.check_call(["qemu-img", "resize", "vm-state-machine/machine.qcow2", "+1G"])

    machine.start()
    newAvail = machine.succeed("df --output=avail / | sed 1d")

    assert int(oldAvail) < int(newAvail), "File system did not grow"
  '';
})

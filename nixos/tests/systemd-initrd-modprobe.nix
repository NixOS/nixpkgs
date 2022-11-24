import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "systemd-initrd-modprobe";

  nodes.machine = { pkgs, ... }: {
    boot.initrd.systemd.enable = true;
    boot.initrd.kernelModules = [ "loop" ]; # Load module in initrd.
    boot.extraModprobeConfig = ''
      options loop max_loop=42
    '';
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    max_loop = machine.succeed("cat /sys/module/loop/parameters/max_loop")
    assert int(max_loop) == 42, "Parameter should be respected for initrd kernel modules"
  '';
})

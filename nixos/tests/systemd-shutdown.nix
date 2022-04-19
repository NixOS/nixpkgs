import ./make-test-python.nix ({ pkgs, systemdStage1 ? false, ...} : {
  name = "systemd-shutdown";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ das_j ];
  };

  nodes.machine = {
    imports = [ ../modules/profiles/minimal.nix ];
    boot.initrd.systemd.enable = systemdStage1;
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    # .shutdown() would wait for the machine to power off
    machine.succeed("systemctl poweroff")
    # Message printed by systemd-shutdown
    machine.wait_for_console_text("All filesystems, swaps, loop devices, MD devices and DM devices detached.")
    # Don't try to sync filesystems
    machine.booted = False
  '';
})

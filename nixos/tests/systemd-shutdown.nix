import ./make-test-python.nix ({ pkgs, systemdStage1 ? false, ...} : let
  msg = "Shutting down NixOS";
in {
  name = "systemd-shutdown";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ das_j ];
  };

  nodes.machine = {
    imports = [ ../modules/profiles/minimal.nix ];
    systemd.shutdownRamfs.contents."/etc/systemd/system-shutdown/shutdown-message".source = pkgs.writeShellScript "shutdown-message" ''
      echo "${msg}"
    '';
    boot.initrd.systemd.enable = systemdStage1;
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    # .shutdown() would wait for the machine to power off
    machine.succeed("systemctl poweroff")
    # Message printed by systemd-shutdown
    machine.wait_for_console_text("Unmounting '/oldroot'")
    machine.wait_for_console_text("${msg}")
    # Don't try to sync filesystems
    machine.booted = False
  '';
})

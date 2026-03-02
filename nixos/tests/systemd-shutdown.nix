{
  systemdStage1,
  lib,
  pkgs,
  ...
}:
let
  msg = "Shutting down NixOS";
in
{
  name = "systemd-shutdown";
  meta.maintainers = with lib.maintainers; [ das_j ];

  _module.args.systemdStage1 = lib.mkDefault false;

  nodes.machine = {
    imports = [ ../modules/profiles/minimal.nix ];
    systemd.shutdownRamfs.contents."/etc/systemd/system-shutdown/shutdown-message".source =
      pkgs.writeShellScript "shutdown-message" ''
        echo "${msg}" > /dev/kmsg
      '';
    boot.initrd.systemd.enable = systemdStage1;
  };

  testScript = ''
    # Check that 'generate-shutdown-ramfs.service' is started
    # automatically and that 'systemd-shutdown' runs our script.
    machine.wait_for_unit("multi-user.target")
    # .shutdown() would wait for the machine to power off
    machine.execute("systemctl poweroff", check_return=False)
    # Message printed by systemd-shutdown
    machine.wait_for_console_text("Unmounting '/oldroot'")
    machine.wait_for_console_text("${msg}")
    # Don't try to sync filesystems
    machine.wait_for_shutdown()

    # In a separate boot, start 'generate-shutdown-ramfs.service'
    # manually in order to check the permissions on '/run/initramfs'.
    machine.systemctl("start generate-shutdown-ramfs.service")
    stat = machine.succeed("stat --printf=%a:%u:%g /run/initramfs")
    assert stat == "700:0:0", f"Improper permissions on /run/initramfs: {stat}"
  '';
}

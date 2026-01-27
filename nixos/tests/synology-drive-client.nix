{ lib, pkgs, ... }:
{
  name = "synology-drive-client";
  meta.maintainers = with lib.maintainers; [ nivalux ];

  nodes.machine = {
    imports = [
      ./common/x11.nix
      ./common/user-account.nix
    ];

    test-support.displayManager.auto.user = "alice";

    environment.systemPackages = [
      pkgs.synology-drive-client
      pkgs.procps
    ];
    services.dbus.enable = true;

    systemd.user.services.synology-drive = {
      unitConfig = {
        Description = "Synology Drive Client";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      serviceConfig = {
        Type = "simple";
        RemainAfterExit = "yes";
        ExecStart = "${lib.getExe pkgs.synology-drive-client}";
        Restart = "no";
      };
    };
  };

  testScript = ''
    machine.wait_for_x()

    machine.succeed("systemctl --user -M alice@ start synology-drive")

    machine.sleep(10);
    machine.wait_until_succeeds("pgrep -u alice -f cloud-drive-ui", timeout=60)
    machine.wait_until_succeeds("pgrep -u alice -f cloud-drive-connect", timeout=30)
  '';

}

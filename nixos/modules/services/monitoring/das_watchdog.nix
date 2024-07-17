# A general watchdog for the linux operating system that should run in the
# background at all times to ensure a realtime process won't hang the machine
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  inherit (pkgs) das_watchdog;

in
{
  ###### interface

  options = {
    services.das_watchdog.enable = mkEnableOption "realtime watchdog";
  };

  ###### implementation

  config = mkIf config.services.das_watchdog.enable {
    environment.systemPackages = [ das_watchdog ];
    systemd.services.das_watchdog = {
      description = "Watchdog to ensure a realtime process won't hang the machine";
      after = [
        "multi-user.target"
        "sound.target"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "root";
        Type = "simple";
        ExecStart = "${das_watchdog}/bin/das_watchdog";
        RemainAfterExit = true;
      };
    };
  };
}

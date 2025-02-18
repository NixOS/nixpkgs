# A general watchdog for the linux operating system that should run in the
# background at all times to ensure a realtime process won't hang the machine
{
  config,
  lib,
  pkgs,
  ...
}:
let

  inherit (pkgs) das_watchdog;

in
{
  ###### interface

  options = {
    services.das_watchdog.enable = lib.mkEnableOption "realtime watchdog";
  };

  ###### implementation

  config = lib.mkIf config.services.das_watchdog.enable {
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

{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.psd;
in
{
  options.services.psd = with lib.types; {
    enable = lib.mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to enable the Profile Sync daemon.
      '';
    };
    resyncTimer = lib.mkOption {
      type = str;
      default = "1h";
      example = "1h 30min";
      description = ''
        The amount of time to wait before syncing browser profiles back to the
        disk.

        Takes a systemd.unit time span. The time unit defaults to seconds if
        omitted.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.profile-sync-daemon ];

    systemd.packages = [ pkgs.profile-sync-daemon ];

    systemd.user = {
      services.psd = {
        wantedBy = [ "default.target" ];
        enableDefaultPath = false;
      };
      timers.psd-resync.timerConfig = {
        OnCalendar = "";
        OnUnitActiveSec = cfg.resyncTimer;
      };
    };
  };
}

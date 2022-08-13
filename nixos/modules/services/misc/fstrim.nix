{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.fstrim;

in {

  options = {

    services.fstrim = {
      enable = mkEnableOption "periodic SSD TRIM of mounted partitions in background";

      interval = mkOption {
        type = types.str;
        default = "weekly";
        description = lib.mdDoc ''
          How often we run fstrim. For most desktop and server systems
          a sufficient trimming frequency is once a week.

          The format is described in
          {manpage}`systemd.time(7)`.
        '';
      };
    };

  };

  config = mkIf cfg.enable {

    systemd.packages = [ pkgs.util-linux ];

    systemd.timers.fstrim = {
      timerConfig = {
        OnCalendar = cfg.interval;
      };
      wantedBy = [ "timers.target" ];
    };

  };

  meta.maintainers = with maintainers; [ ];
}

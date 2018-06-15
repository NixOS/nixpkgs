{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.fstrim;

in {

  options = {

    services.fstrim = {
      enable = mkEnableOption "periodic SSD TRIM of mounted partitions in background";

      interval = mkOption {
        type = types.string;
        default = "weekly";
        description = ''
          How often we run fstrim. For most desktop and server systems
          a sufficient trimming frequency is once a week.

          The format is described in
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>.
        '';
      };
    };

  };

  config = mkIf cfg.enable {

    systemd.packages = [ pkgs.utillinux ];

    systemd.timers.fstrim = {
      timerConfig = {
        OnCalendar = cfg.interval;
      };
      wantedBy = [ "timers.target" ];
    };

  };

  meta.maintainers = with maintainers; [ gnidorah ];
}

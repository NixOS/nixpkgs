{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.fstrim;

in
{

  options = {

    services.fstrim = {
      enable = (
        lib.mkEnableOption "periodic SSD TRIM of mounted partitions in background"
        // {
          default = true;
        }
      );

      interval = lib.mkOption {
        type = lib.types.str;
        default = "weekly";
        description = ''
          How often we run fstrim. For most desktop and server systems
          a sufficient trimming frequency is once a week.

          The format is described in
          {manpage}`systemd.time(7)`.
        '';
      };

      persistent = lib.mkOption {
        default = true;
        type = lib.types.bool;
        example = false;
        description = ''
          Takes a boolean argument. If true, the time when the service
          unit was last triggered is stored on disk. When the timer is
          activated, the service unit is triggered immediately if it
          would have been triggered at least once during the time when
          the timer was inactive. Such triggering is nonetheless
          subject to the delay imposed by RandomizedDelaySec=. This is
          useful to catch up on missed runs of the service when the
          system was powered down.
        '';
      };

      randomizedDelaySec = lib.mkOption {
        default = "0";
        type = lib.types.singleLineStr;
        example = "45min";
        description = ''
          Add a randomized delay before each fstrim operation.
          The delay will be chosen between zero and this value.
          This value must be a time span in the format specified by
          {manpage}`systemd.time(7)`
        '';
      };

    };

  };

  config = lib.mkIf cfg.enable {

    systemd.packages = [ pkgs.util-linux ];

    systemd.timers.fstrim = {
      timerConfig = {
        OnCalendar = [
          ""
          cfg.interval
        ];
        Persistent = cfg.persistent;
        RandomizedDelaySec = cfg.randomizedDelaySec;
      };
      wantedBy = [ "timers.target" ];
    };

  };

  meta.maintainers = [ ];
}

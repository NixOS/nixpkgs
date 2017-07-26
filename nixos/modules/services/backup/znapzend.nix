{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.znapzend;
in
{
  options = {
    services.znapzend = {
      enable = mkEnableOption "ZnapZend daemon";

      logLevel = mkOption {
        default = "debug";
        example = "warning";
        type = lib.types.enum ["debug" "info" "warning" "err" "alert"];
        description = "The log level when logging to file. Any of debug, info, warning, err, alert. Default in daemonized form is debug.";
      };

      logTo = mkOption {
        type = types.str;
        default = "syslog::daemon";
        example = "/var/log/znapzend.log";
        description = "Where to log to (syslog::&lt;facility&gt; or &lt;filepath&gt;).";
      };

      noDestroy = mkOption {
        type = types.bool;
        default = false;
        description = "Does all changes to the filesystem except destroy";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.znapzend ];

    systemd.services = {
      "znapzend" = {
        description = "ZnapZend - ZFS Backup System";
        wantedBy    = [ "zfs.target" ];
        after       = [ "zfs.target" ];

        path = with pkgs; [ zfs mbuffer openssh ];

        serviceConfig = {
          ExecStart = "${pkgs.znapzend}/bin/znapzend --logto=${cfg.logTo} --loglevel=${cfg.logLevel} ${optionalString cfg.noDestroy "--nodestroy"}";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          Restart = "on-failure";
        };
      };
    };
  };
}

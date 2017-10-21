{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.xe-guest-utilities;
in {
  options = {
    services.xe-guest-utilities = {
      enable = mkEnableOption "Whether to enable the Xen guest utilities daemon.";
    };
  };
  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.xe-guest-utilities ];
    systemd.tmpfiles.rules = [ "d /run/xenstored 0755 - - -" ];

    systemd.services.xe-daemon = {
      description = "xen daemon file";
      wantedBy    = [ "multi-user.target" ];
      after = [ "xe-linux-distribution.service" ];
      requires = [ "proc-xen.mount" ];
      path = [ pkgs.coreutils pkgs.iproute ];
      serviceConfig = {
        PIDFile = "/run/xe-daemon.pid";
        ExecStart = "${pkgs.xe-guest-utilities}/bin/xe-daemon -p /run/xe-daemon.pid";
        ExecStop = "${pkgs.procps}/bin/pkill -TERM -F /run/xe-daemon.pid";
      };
    };

    systemd.services.xe-linux-distribution = {
      description = "xen linux distribution service";
      wantedBy    = [ "multi-user.target" ];
      before = [ "xend.service" ];
      path = [ pkgs.xe-guest-utilities pkgs.coreutils pkgs.gawk pkgs.gnused ];
      serviceConfig = {
        Type = "simple";
        RemainAfterExit = "yes";
        ExecStart = "${pkgs.xe-guest-utilities}/bin/xe-linux-distribution /var/cache/xe-linux-distribution";
      };
    };

    systemd.mounts = [
      { description = "Mount /proc/xen files";
        what = "xenfs";
        where = "/proc/xen";
        type = "xenfs";
        unitConfig = {
          ConditionPathExists = "/proc/xen";
          RefuseManualStop = "true";
        };
      }
    ];
  };
}

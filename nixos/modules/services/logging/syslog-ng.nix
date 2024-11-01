{ config, pkgs, lib, ... }:
let

  cfg = config.services.syslog-ng;

  syslogngConfig = pkgs.writeText "syslog-ng.conf" ''
    ${cfg.configHeader}
    ${cfg.extraConfig}
  '';

  ctrlSocket = "/run/syslog-ng/syslog-ng.ctl";
  pidFile = "/run/syslog-ng/syslog-ng.pid";
  persistFile = "/var/syslog-ng/syslog-ng.persist";

  syslogngOptions = [
    "--foreground"
    "--module-path=${lib.concatStringsSep ":" (["${cfg.package}/lib/syslog-ng"] ++ cfg.extraModulePaths)}"
    "--cfgfile=${syslogngConfig}"
    "--control=${ctrlSocket}"
    "--persist-file=${persistFile}"
    "--pidfile=${pidFile}"
  ];

in {
  imports = [
    (lib.mkRemovedOptionModule [ "services" "syslog-ng" "serviceName" ] "")
    (lib.mkRemovedOptionModule [ "services" "syslog-ng" "listenToJournal" ] "")
  ];

  options = {

    services.syslog-ng = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable the syslog-ng daemon.
        '';
      };
      package = lib.mkPackageOption pkgs "syslogng" { };
      extraModulePaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = ''
          A list of paths that should be included in syslog-ng's
          `--module-path` option. They should usually
          end in `/lib/syslog-ng`
        '';
      };
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Configuration added to the end of `syslog-ng.conf`.
        '';
      };
      configHeader = lib.mkOption {
        type = lib.types.lines;
        default = ''
          @version: 4.4
          @include "scl.conf"
        '';
        description = ''
          The very first lines of the configuration file. Should usually contain
          the syslog-ng version header.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.syslog-ng = {
      description = "syslog-ng daemon";
      preStart = "mkdir -p /{var,run}/syslog-ng";
      wantedBy = [ "multi-user.target" ];
      after = [ "multi-user.target" ]; # makes sure hostname etc is set
      serviceConfig = {
        Type = "notify";
        PIDFile = pidFile;
        StandardOutput = "null";
        Restart = "on-failure";
        ExecStart = "${cfg.package}/sbin/syslog-ng ${lib.concatStringsSep " " syslogngOptions}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };

}

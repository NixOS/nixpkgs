{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.syslog-ng;

  syslogngConfig = pkgs.writeText "syslog-ng.conf" ''
    @version: 3.5
    @include "scl.conf"
    ${cfg.extraConfig}
  '';

  ctrlSocket = "/run/syslog-ng/syslog-ng.ctl";
  pidFile = "/run/syslog-ng/syslog-ng.pid";
  persistFile = "/var/syslog-ng/syslog-ng.persist";

  syslogngOptions = [
    "--foreground"
    "--module-path=${concatStringsSep ":" (["${pkgs.syslogng}/lib/syslog-ng"] ++ cfg.extraModulePaths)}"
    "--cfgfile=${syslogngConfig}"
    "--control=${ctrlSocket}"
    "--persist-file=${persistFile}"
    "--pidfile=${pidFile}"
  ];

in {

  options = {

    services.syslog-ng = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the syslog-ng daemon.
        '';
      };
      serviceName = mkOption {
        type = types.str;
        default = "syslog-ng";
        description = ''
          The name of the systemd service that runs syslog-ng. Set this to
          <literal>syslog</literal> if you want journald to automatically
          forward all logs to syslog-ng.
        '';
      };
      extraModulePaths = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "${pkgs.syslogng_incubator}/lib/syslog-ng" ];
        description = ''
          A list of paths that should be included in syslog-ng's
          <literal>--module-path</literal> option. They should usually
          end in <literal>/lib/syslog-ng</literal>
        '';
      };
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Configuration added to the end of <literal>syslog-ng.conf</literal>.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services."${cfg.serviceName}" = {
      wantedBy = [ "multi-user.target" ];
      preStart = "mkdir -p /{var,run}/syslog-ng";
      serviceConfig = {
        Type = "notify";
        Sockets = "syslog.socket";
        StandardOutput = "null";
        Restart = "on-failure";
        ExecStart = "${pkgs.syslogng}/sbin/syslog-ng ${concatStringsSep " " syslogngOptions}";
      };
    };
  };

}

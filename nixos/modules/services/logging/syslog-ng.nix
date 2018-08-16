{ config, pkgs, lib, ... }:

with lib;

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
    "--module-path=${concatStringsSep ":" (["${cfg.package}/lib/syslog-ng"] ++ cfg.extraModulePaths)}"
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
      package = mkOption {
        type = types.package;
        default = pkgs.syslogng;
        defaultText = "pkgs.syslogng";
        description = ''
          The package providing syslog-ng binaries.
        '';
      };
      extraModulePaths = mkOption {
        type = types.listOf types.str;
        default = [];
        example = literalExample ''
          [ "''${pkgs.syslogng_incubator}/lib/syslog-ng" ]
        '';
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
      configHeader = mkOption {
        type = types.lines;
        default = ''
          @version: 3.6
          @include "scl.conf"
        '';
        description = ''
          The very first lines of the configuration file. Should usually contain
          the syslog-ng version header.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
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
        ExecStart = "${cfg.package}/sbin/syslog-ng ${concatStringsSep " " syslogngOptions}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };

}

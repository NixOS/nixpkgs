{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mail.freepopsd;
in

{
  options = {
    services.mail.freepopsd = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = ''
          Enables Freepops, a POP3 webmail wrapper.
        '';
      };

      port = mkOption {
        default = 2000;
        type = with types; uniq int;
        description = ''
          Port on which the pop server will listen.
        '';
      };

      threads = mkOption {
        default = 5;
        type = with types; uniq int;
        description = ''
          Max simultaneous connections.
        '';
      };

      bind = mkOption {
        default = "0.0.0.0";
        type = types.str;
        description = ''
          Bind over an IPv4 address instead of any.
        '';
      };

      logFile = mkOption {
        default = "/var/log/freepopsd";
        example = "syslog";
        type = types.str;
        description = ''
          Filename of the log file or syslog to rely on the logging daemon.
        '';
      };

      suid = {
        user = mkOption {
          default = "nobody";
          type = types.str;
          description = ''
            User name under which freepopsd will be after binding the port.
          '';
        };

        group = mkOption {
          default = "nogroup";
          type = types.str;
          description = ''
            Group under which freepopsd will be after binding the port.
          '';
        };
      };

    };
  };

  config = mkIf cfg.enable {
    systemd.services.freepopsd = {
      description = "Freepopsd (webmail over POP3)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${pkgs.freepops}/bin/freepopsd \
          -p ${toString cfg.port} \
          -t ${toString cfg.threads} \
          -b ${cfg.bind} \
          -vv -l ${cfg.logFile} \
          -s ${cfg.suid.user}.${cfg.suid.group}
      '';
    };
  };
}

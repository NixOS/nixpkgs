{config, pkgs, ...}:

with pkgs.lib;

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
        type = with types; uniq string;
        description = ''
          Bind over an IPv4 address instead of any.
        '';
      };

      logFile = mkOption {
        default = "/var/log/freepopsd";
        example = "syslog";
        type = with types; uniq string;
        description = ''
          Filename of the log file or syslog to rely on the logging daemon.
        '';
      };

      suid = {
        user = mkOption {
          default = "nobody";
          type = with types; uniq string;
          description = ''
            User name under which freepopsd will be after binding the port.
          '';
        };

        group = mkOption {
          default = "nogroup";
          type = with types; uniq string;
          description = ''
            Group under which freepopsd will be after binding the port.
          '';
        };
      };

    };
  };

  config = mkIf cfg.enable {
    jobs.freepopsd = {
      description = "Freepopsd (webmail over POP3)";
      startOn = "ip-up";
      exec = ''${pkgs.freepops}/bin/freepopsd \
        -p ${toString cfg.port} \
        -t ${toString cfg.threads} \
        -b ${cfg.bind} \
        -vv -l ${cfg.logFile} \
        -s ${cfg.suid.user}.${cfg.suid.group}
      '';
    };
  };
}

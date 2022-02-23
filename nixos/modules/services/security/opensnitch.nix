{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.opensnitch;
  format = pkgs.formats.json {};
  json = pkgs.formats.json {};
in {

  options = {
    services.opensnitch = {
      enable = mkEnableOption (lib.mdDoc "Opensnitch application firewall");

      settings = mkOption {
        type = types.submodule {
          freeformType = format.type;

          options = {
            Server = {

              Address = mkOption {
                type = types.str;
                description = lib.mdDoc ''
                  Unix socket path (unix:///tmp/osui.sock, the "unix:///" part is
                  mandatory) or TCP socket (192.168.1.100:50051).
                '';
              };

              LogFile = mkOption {
                type = types.path;
                description = lib.mdDoc ''
                  File to write logs to (use /dev/stdout to write logs to standard
                  output).
                '';
              };

            };

            DefaultAction = mkOption {
              type = types.enum [ "allow" "deny" ];
              description = lib.mdDoc ''
                Default action whether to block or allow application internet
                access.
              '';
            };

            DefaultDuration = mkOption {
              type = types.enum [
                "once" "always" "until restart" "30s" "5m" "15m" "30m" "1h"
              ];
              description = lib.mdDoc ''
                Default duration of firewall rule.
              '';
            };

            InterceptUnknown = mkOption {
              type = types.bool;
              description = lib.mdDoc ''
                Wheter to intercept spare connections.
              '';
            };

            ProcMonitorMethod = mkOption {
              type = types.enum [ "ebpf" "proc" "ftrace" "audit" ];
              description = lib.mdDoc ''
                Which process monitoring method to use.
              '';
            };

            LogLevel = mkOption {
              type = types.enum [ 0 1 2 3 4 ];
              description = lib.mdDoc ''
                Default log level from 0 to 4 (debug, info, important, warning,
                error).
              '';
            };

            Firewall = mkOption {
              type = types.enum [ "iptables" "nftables" ];
              description = lib.mdDoc ''
                Which firewall backend to use.
              '';
            };

            Stats = {

              MaxEvents = mkOption {
                type = types.int;
                description = lib.mdDoc ''
                  Max events to send to the GUI.
                '';
              };

              MaxStats = mkOption {
                type = types.int;
                description = lib.mdDoc ''
                  Max stats per item to keep in backlog.
                '';
              };

            };
          };
        };
        description = lib.mdDoc ''
          opensnitchd configuration. Refer to
          <https://github.com/evilsocket/opensnitch/wiki/Configurations>
          for details on supported values.
        '';
      };

      # Values follow upstream default
      # https://github.com/evilsocket/opensnitch/blob/master/daemon/default-config.json
      # Documentation: https://github.com/evilsocket/opensnitch/wiki/Configurations
      config = {

        Server = {

          Address = mkOption {
            type = types.str;
            default = "unix:///tmp/osui.sock";
            description = ''
              Unix socket path (unix:///tmp/osui.sock, the "unix:///" part is
              mandatory) or TCP socket (192.168.1.100:50051).
            '';
          };

          LogFile = mkOption {
            type = types.path;
            default = "/var/log/opensnitchd.log";
            description = ''
              File to write logs to (use /dev/stdout to write logs to standard
              output).
            '';
          };

        };

        DefaultAction = mkOption {
          type = types.enum [ "allow" "deny" ];
          default = "deny";
          description = ''
            Default action whether to block or allow application network
            access.
          '';
        };

        DefaultDuration = mkOption {
          type = types.enum [
            "once" "always" "until restart" "30s" "5m" "15m" "30m" "1h"
          ];
          default = "once";
          description = ''
            Default duration of firewall rule.
          '';
        };

        InterceptUnknown = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Wheter to intercept spare connections.
          '';
        };

        ProcMonitorMethod = mkOption {
          type = types.enum [ "ebpf" "proc" "ftrace" "audit" ];
          default = "proc";
          description = ''
            Which process monitoring method to use.
          '';
        };

        LogLevel = mkOption {
          type = types.enum [ 0 1 2 3 4 ];
          default = 1;
          description = ''
            Default log level from 0 to 4 (debug, info, important, warning,
            error).
          '';
        };

        Firewall = mkOption {
          type = types.enum [ "iptables" "nftables" ];
          default = "nftables";
          description = ''
            Which firewall backend to use.
          '';
        };

        Stats = {

          MaxEvents = mkOption {
            type = types.int;
            default = 150;
            description = ''
              Max events to send to the GUI.
            '';
          };

          MaxStats = mkOption {
            type = types.int;
            default = 25;
            description = ''
              Max stats per item to keep in backlog.
            '';
          };

        };

      };

      rules = mkOption {
        type = types.attrsOf (types.either types.path (types.submodule {
          options = {

            precedence = mkOption {
              type = types.bool;
              default = false;
              description = "Sets if a rule take precedence.";
            };

            action = mkOption {
              type = types.enum [ "allow" "deny" ];
              default = "allow";
              description = "Whether to allow or deny network access.";
            };

            duration = mkOption {
              type = types.enum [
                "once" "always" "until restart" "30s" "5m" "15m" "30m" "1h"
              ];
              default = "always";
              description = "Duration of firewall rule.";
            };

            operator = {

              type = mkOption {
                type = types.enum [ "simple" "regexp" ];
                default = "simple";
                description = ''
                  Can be simple, in which case a simple == comparison will be
                  performed, or regexp if the data field is a regular
                  expression to match.
                '';
              };

              operand = mkOption {
                type = types.enum [
                  "true" "process.path" "process.id" "process.command"
                  "provess.env.ENV_VAR_NAME" "user.id" "protocol" "dest.ip"
                  "dest.host" "dest.network" "dest.port" "lists.domains"
                  "lists.domains_regexp" "lists.ips" "lists.nets" ];
                default = "process.path";
                description = "What element of the connection to compare.";
              };

              data = mkOption {
                type = types.str;
                description = ''
                  The data to compare the operand to, can be a regular
                  expression if type is regexp, or a path to a directory with
                  list of IPs/domains in the case of lists.
                '';
                example = literalExpression ''"''${lib.getBin pkgs.firefox}/bin/firefox"'';
              };

            };

          };
        }));
        default = {};
        example = literalExpression ''
          {
            firefox = {
              action = "allow";
              duration = "until restart";
              operator = {
                data = "''${lib.getBin pkgs.firefox}/bin/firefox";
              };
            };
            mpv = {
              action = "deny";
              duration = "always";
              operator = {
                executable = "''${lib.getBin pkgs.mpv}/bin/mpv";
              };
            };
          }
        '';
        description = ''
          Define set of rules for applications, whether to allow or deny
          network acces for them.
        '';
      };

    };
  };

  config = mkIf cfg.enable {

    # pkg.opensnitch is referred to elsewhere in the module so we don't need to worry about it being garbage collected
    services.opensnitch.settings = mapAttrs (_: v: mkDefault v) (builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile "${pkgs.opensnitch}/etc/default-config.json")));

    systemd = {
      packages = [ pkgs.opensnitch ];
      services.opensnitchd = {
        restartTriggers = [ config.environment.etc."opensnitchd/default-config.json".source ];
        wantedBy = [ "multi-user.target" ];
      };
    };

    environment.etc."opensnitchd/default-config.json" = {
      source = json.generate "default-config.json" cfg.config;
    };

    environment.etc."opensnitchd/default-config.json".source = format.generate "default-config.json" cfg.settings;
    # Upstream documentation on rule file format
    # https://github.com/evilsocket/opensnitch/wiki/Rules

  };

  meta.maintainers = with maintainers; [ onny ];
}


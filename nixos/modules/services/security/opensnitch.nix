{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.opensnitch;
  format = pkgs.formats.json {};
in {
  options = {
    services.opensnitch = {
      enable = mkEnableOption "Opensnitch application firewall";
      settings = mkOption {
        type = types.submodule {
          freeformType = format.type;

          options = {
            Server = {

              Address = mkOption {
                type = types.str;
                description = ''
                  Unix socket path (unix:///tmp/osui.sock, the "unix:///" part is
                  mandatory) or TCP socket (192.168.1.100:50051).
                '';
              };

              LogFile = mkOption {
                type = types.path;
                description = ''
                  File to write logs to (use /dev/stdout to write logs to standard
                  output).
                '';
              };

            };

            DefaultAction = mkOption {
              type = types.enum [ "allow" "deny" ];
              description = ''
                Default action whether to block or allow application internet
                access.
              '';
            };

            DefaultDuration = mkOption {
              type = types.enum [
                "once" "always" "until restart" "30s" "5m" "15m" "30m" "1h"
              ];
              description = ''
                Default duration of firewall rule.
              '';
            };

            InterceptUnknown = mkOption {
              type = types.bool;
              description = ''
                Wheter to intercept spare connections.
              '';
            };

            ProcMonitorMethod = mkOption {
              type = types.enum [ "ebpf" "proc" "ftrace" "audit" ];
              description = ''
                Which process monitoring method to use.
              '';
            };

            LogLevel = mkOption {
              type = types.enum [ 0 1 2 3 4 ];
              description = ''
                Default log level from 0 to 4 (debug, info, important, warning,
                error).
              '';
            };

            Firewall = mkOption {
              type = types.enum [ "iptables" "nftables" ];
              description = ''
                Which firewall backend to use.
              '';
            };

            Stats = {

              MaxEvents = mkOption {
                type = types.int;
                description = ''
                  Max events to send to the GUI.
                '';
              };

              MaxStats = mkOption {
                type = types.int;
                description = ''
                  Max stats per item to keep in backlog.
                '';
              };

            };
          };
        };
        description = ''
          opensnitchd configuration. Refer to
          <link xlink:href="https://github.com/evilsocket/opensnitch/wiki/Configurations"/>
          for details on supported values.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    # pkg.opensnitch is referred to elsewhere in the module so we don't need to worry about it being garbage collected
    services.opensnitch.settings = mapAttrs (_: v: mkDefault v) (builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile "${pkgs.opensnitch}/etc/default-config.json")));

    systemd = {
      packages = [ pkgs.opensnitch ];
      services.opensnitchd.wantedBy = [ "multi-user.target" ];
    };

    environment.etc."opensnitchd/default-config.json".source = format.generate "default-config.json" cfg.settings;

  };
}


{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.opensnitch;
  format = pkgs.formats.json {};
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


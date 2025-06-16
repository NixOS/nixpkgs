{ config, lib, ... }:

let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    optionalAttrs
    mkMerge
    ;

  inherit (lib.types) str;

  cfg = config.services.netbird.server;
in

{
  meta = {
    maintainers = with lib.maintainers; [ patrickdag ];
    doc = ./server.md;
  };

  # Import the separate components
  imports = [
    ./coturn.nix
    ./dashboard.nix
    ./management.nix
    ./signal.nix
    ./relay.nix
    ./proxy.nix
  ];

  options.services.netbird.server = {
    enable = mkEnableOption "Netbird Server stack, comprising the dashboard, management API, relay and signal service";

    domain = mkOption {
      type = str;
      description = "The domain under which the netbird server runs.";
    };
  };

  config = mkIf cfg.enable {
    services.netbird.server = {
      dashboard = {
        domain = mkDefault cfg.domain;
        enable = mkDefault cfg.enable;

        managementServer = "https://${cfg.domain}";
      };

      management = mkMerge [
        {
          domain = mkDefault cfg.domain;
          enable = mkDefault cfg.enable;
        }
        (mkIf cfg.signal.enable {
          settings.Signal.URI = mkDefault "${cfg.domain}:${builtins.toString cfg.signal.port}";
        })
        (mkIf cfg.relay.enable {
          settings.Relay = {
            Addresses = [ cfg.relay.settings.NB_EXPOSED_ADDRESS ];
            Secret._secret = cfg.relay.authSecretFile;
          };
        })
        (mkIf cfg.coturn.enable rec {
          turnDomain = cfg.domain;
          turnPort = config.services.coturn.listening-port;
          # We cannot merge a list of attrsets so we have to redefine the whole list
          settings = {
            TURNConfig.Turns = mkDefault [
              {
                Proto = "udp";
                URI = "turn:${turnDomain}:${builtins.toString turnPort}";
                Username = "netbird";
                Password =
                  if (cfg.coturn.password != null) then
                    cfg.coturn.password
                  else
                    { _secret = cfg.coturn.passwordFile; };
              }
            ];
          };
        })
      ];

      signal = {
        enable = mkDefault cfg.enable;
      };

      relay = {
        settings.NB_EXPOSED_ADDRESS = mkDefault "rel://${cfg.domain}:${builtins.toString cfg.relay.port}";
        enable = mkDefault cfg.enable;
      };

      coturn = {
        domain = mkDefault cfg.domain;
      };
    };
  };
}

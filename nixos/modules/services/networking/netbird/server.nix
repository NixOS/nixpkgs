{ config, lib, ... }:

let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    optionalAttrs
    ;

  inherit (lib.types)
    nullOr
    path
    str
    ;

  cfg = config.services.netbird.server;
in

{
  meta = {
    maintainers = with lib.maintainers; [ shuuri-labs ];
    doc = ./server.md;
  };

  # Import the separate components
  imports = [
    ./coturn.nix
    ./dashboard.nix
    ./management.nix
    ./relay.nix
    ./signal.nix
  ];

  options.services.netbird.server = {
    enable = mkEnableOption "Netbird Server stack, comprising the dashboard, management API and signal service";

    enableNginx = mkEnableOption "Nginx reverse-proxy for the netbird server services";

    domain = mkOption {
      type = str;
      description = "The domain under which the netbird server runs.";
    };

    useRelay = mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Use the modern relay server instead of (or in addition to) Coturn.
        When enabled, the relay server will be configured automatically.
      '';
    };

    relayAuthSecretFile = mkOption {
      type = nullOr path;
      default = null;
      description = ''
        Path to the shared authentication secret for the relay server.
        This secret must be provided when useRelay is enabled.
        It will be used by both the relay server and management server.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.useRelay -> cfg.relayAuthSecretFile != null;
        message = "relayAuthSecretFile must be set when useRelay is enabled";
      }
    ];

    services.netbird.server = {
      dashboard = {
        domain = mkDefault cfg.domain;
        enable = mkDefault cfg.enable;
        enableNginx = mkDefault cfg.enableNginx;

        managementServer = mkDefault "https://${cfg.domain}";
      };

      management = {
        domain = mkDefault cfg.domain;
        enable = mkDefault cfg.enable;
        enableNginx = mkDefault cfg.enableNginx;
        # When using relay without coturn, turnDomain still needs a value.
        # Default to the server domain so the management config evaluates.
        turnDomain = mkDefault cfg.domain;
      }
      // (optionalAttrs cfg.coturn.enable rec {
        turnDomain = cfg.domain;
        turnPort = config.services.coturn.listening-port;
        # We cannot merge a list of attrsets so we have to redefine the whole list
        settings = {
          TURNConfig.Turns = mkDefault [
            {
              Proto = "udp";
              URI = "turn:${turnDomain}:${toString turnPort}";
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
      // (optionalAttrs cfg.useRelay {
        relayAddresses = mkDefault [ "rels://${cfg.domain}:443" ];
        relaySecretFile = mkDefault cfg.relayAuthSecretFile;
      });

      signal = {
        domain = mkDefault cfg.domain;
        enable = mkDefault cfg.enable;
        enableNginx = mkDefault cfg.enableNginx;
      };

      relay = mkIf cfg.useRelay {
        enable = mkDefault true;
        domain = mkDefault cfg.domain;
        enableNginx = mkDefault cfg.enableNginx;
        exposedAddress = mkDefault "rels://${cfg.domain}:443";
        authSecretFile = mkDefault cfg.relayAuthSecretFile;
      };

      coturn = {
        domain = mkDefault cfg.domain;
      };
    };
  };
}

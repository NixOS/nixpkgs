{ config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    optionalAttrs
    ;

  inherit (lib.types) str;

  cfg = config.services.netbird.server;
in

{
  meta = {
    maintainers = with lib.maintainers; [ thubrecht ];
    doc = ./server.md;
  };

  # Import the separate components
  imports = [
    ./coturn.nix
    ./dashboard.nix
    ./management.nix
    ./signal.nix
  ];

  options.services.netbird.server = {
    enable = mkEnableOption "Netbird Server stack, comprising the dashboard, management API and signal service";

    enableNginx = mkEnableOption "Nginx reverse-proxy for the netbird server services.";

    domain = mkOption {
      type = str;
      description = "The domain under which the netbird server runs.";
    };
  };

  config = mkIf cfg.enable {
    services.netbird.server = {
      dashboard = {
        inherit (cfg) enable domain enableNginx;

        managementServer = "https://${cfg.domain}";
      };

      management =
        {
          inherit (cfg) enable domain enableNginx;
        }
        // (optionalAttrs cfg.coturn.enable {
          turnDomain = cfg.domain;
          turnPort = config.services.coturn.tls-listening-port;
        });

      signal = {
        inherit (cfg) enable domain enableNginx;
      };

      coturn = {
        inherit (cfg) domain;
      };
    };
  };
}

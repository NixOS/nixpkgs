{ config, lib, ... }:

let
  inherit (lib)
    mkDefault
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
    maintainers = with lib.maintainers; [thubrecht patrickdag];
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
        domain = mkDefault cfg.domain;
        enable = mkDefault cfg.enable;
        enableNginx = mkDefault cfg.enableNginx;

        managementServer = "https://${cfg.domain}";
      };

      management =
        {
          domain = mkDefault cfg.domain;
          enable = mkDefault cfg.enable;
          enableNginx = mkDefault cfg.enableNginx;
        }
        // (optionalAttrs cfg.coturn.enable rec {
          turnDomain = cfg.domain;
          turnPort = config.services.coturn.tls-listening-port;
          # We cannot merge a list of attrsets so we have to redefine the whole list
          settings = {
            TURNConfig.Turns = mkDefault [
              {
                Proto = "udp";
                URI = "turn:${turnDomain}:${builtins.toString turnPort}";
                Username = "netbird";
                Password =
                  if (cfg.coturn.password != null)
                  then cfg.coturn.password
                  else {_secret = cfg.coturn.passwordFile;};
              }
            ];
          };
        });

      signal = {
        domain = mkDefault cfg.domain;
        enable = mkDefault cfg.enable;
        enableNginx = mkDefault cfg.enableNginx;
      };

      coturn = {
        domain = mkDefault cfg.domain;
      };
    };
  };
}

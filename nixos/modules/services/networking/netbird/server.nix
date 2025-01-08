{ config, lib, ... }:

let
  inherit (lib.types) str;

  cfg = config.services.netbird.server;
in

{
  meta = {
    maintainers = with lib.maintainers; [patrickdag];
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
    enable = lib.mkEnableOption "Netbird Server stack, comprising the dashboard, management API and signal service";

    enableNginx = lib.mkEnableOption "Nginx reverse-proxy for the netbird server services";

    domain = lib.mkOption {
      type = str;
      description = "The domain under which the netbird server runs.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.netbird.server = {
      dashboard = {
        domain = lib.mkDefault cfg.domain;
        enable = lib.mkDefault cfg.enable;
        enableNginx = lib.mkDefault cfg.enableNginx;

        managementServer = "https://${cfg.domain}";
      };

      management =
        {
          domain = lib.mkDefault cfg.domain;
          enable = lib.mkDefault cfg.enable;
          enableNginx = lib.mkDefault cfg.enableNginx;
        }
        // (lib.optionalAttrs cfg.coturn.enable rec {
          turnDomain = cfg.domain;
          turnPort = config.services.coturn.tls-listening-port;
          # We cannot merge a list of attrsets so we have to redefine the whole list
          settings = {
            TURNConfig.Turns = lib.mkDefault [
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
        domain = lib.mkDefault cfg.domain;
        enable = lib.mkDefault cfg.enable;
        enableNginx = lib.mkDefault cfg.enableNginx;
      };

      coturn = {
        domain = lib.mkDefault cfg.domain;
      };
    };
  };
}

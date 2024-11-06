{ lib, config, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    ;
  inherit (lib.types) str;
  cfg = config.services.netbird.server.proxy;
in
{
  options.services.netbird.server.proxy = {
    enable = mkEnableOption "A reverse proxy for netbirds' services";

    enableNginx = mkEnableOption "Nginx reverse-proxy for the netbird signal service";

    signalAddress = mkOption {
      type = str;
      description = "The external address to reach the signal service.";
    };

    relayAddress = mkOption {
      type = str;
      description = "The external address to reach the relay service.";
    };

    managementAddress = mkOption {
      type = str;
      description = "The external address to reach the dashboard.";
    };

    dashboardAddress = mkOption {
      type = str;
      description = "The external address to reach the dashboard.";
    };

    domain = mkOption {
      type = str;
      description = "The public domain to reach the proxy";
    };
  };
  config = mkIf cfg.enable {
    services.nginx = mkIf cfg.enableNginx {
      enable = true;

      virtualHosts.${cfg.domain} = {
        locations = {
          "/" = {
            proxyPass = "http://${cfg.dashboardAddress}";
            proxyWebSockets = true;
          };
          "/api".proxyPass = "http://${cfg.managementAddress}";

          "/management.ManagementService/".extraConfig = ''
            # This is necessary so that grpc connections do not get closed early
            # see https://stackoverflow.com/a/67805465
            client_body_timeout 1d;

            grpc_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

            grpc_pass grpc://${cfg.managementAddress};
            grpc_read_timeout 1d;
            grpc_send_timeout 1d;
            grpc_socket_keepalive on;
          '';
        };
        locations."/signalexchange.SignalExchange/".extraConfig = ''
          # This is necessary so that grpc connections do not get closed early
          # see https://stackoverflow.com/a/67805465
          client_body_timeout 1d;

          grpc_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

          grpc_pass grpc://${cfg.signalAddress};
          grpc_read_timeout 1d;
          grpc_send_timeout 1d;
          grpc_socket_keepalive on;
        '';
        locations."/relay".extraConfig = ''
          proxy_pass http://${cfg.relayAddress}/relay;

          # WebSocket support
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "Upgrade";

          # Forward headers
          proxy_set_header Host $http_host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;

          # Timeout settings
          proxy_read_timeout 3600s;
          proxy_send_timeout 3600s;
          proxy_connect_timeout 60s;

          # Handle upstream errors
          proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        '';
      };
    };
  };
}

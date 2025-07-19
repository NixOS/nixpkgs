{ lib, config, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkDefault
    ;
  inherit (lib.types) str nullOr;
  cfg = config.services.netbird.server.proxy;
in
{
  options.services.netbird.server.proxy = {

    enableNginx = mkEnableOption "the nginx reverse proxy as a complete, singular frontend for the server components of the Netbird overlay network";

    signalAddress = mkOption {
      type = str;
      description = "Address to reach the signal service.";
      example = "1.2.3.4:1764";
    };

    relayAddress = mkOption {
      type = str;
      description = "The external address to reach the relay service.";
    };

    managementAddress = mkOption {
      type = str;
      description = "Address to reach the management api.";
      example = "1.2.3.4:1766";
    };

    dashboardAddress = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        Address to reach the dashboard.
        If set to null, the default, it will not forward the dashboard,
        use this if you want to host the proxy on the same host as the dasboard.
      '';
      example = "1.2.3.4:1767";
    };

    domain = mkOption {
      type = str;
      description = "Domain that hosts the proxy";
      example = "netbird.selfhosted";
    };
  };
  config = {
    services.nginx = mkIf cfg.enableNginx {
      enable = true;

      virtualHosts.${cfg.domain} = {
        forceSSL = mkDefault true;
        extraConfig = ''
          proxy_set_header        X-Real-IP $remote_addr;
          proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header        X-Scheme $scheme;
          proxy_set_header        X-Forwarded-Proto https;
          proxy_set_header        X-Forwarded-Host $host;
          grpc_set_header         X-Forwarded-For $proxy_add_x_forwarded_for;
        '';
        locations = {
          "/" = mkIf (cfg.dashboardAddress != null) {
            proxyPass = "http://${cfg.dashboardAddress}";
            proxyWebsockets = true;
          };
          "/api".proxyPass = "http://${cfg.managementAddress}";

          "/management.ManagementService/".extraConfig = ''
            # This is necessary so that grpc connections do not get closed early
            # see https://stackoverflow.com/a/67805465
            client_body_timeout 1d;

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
  meta.maintainers = with lib.maintainers; [
    patrickdag
  ];
}

{ config, lib, pkgs, ... }:

with lib;

  let
    cfg = config.services.libreddit;

    args = concatStringsSep " " ([
      "--port ${toString cfg.port}"
      "--address ${cfg.address}"
    ] ++ optional cfg.redirect "--redirect-https");

in
{
  options = {
    services.libreddit = {
      enable = mkEnableOption "Private front-end for Reddit";

      address = mkOption {
        default = "0.0.0.0";
        example = "127.0.0.1";
        type =  types.str;
        description = "The address to listen on";
      };

      port = mkOption {
        default = 8080;
        example = 8000;
        type = types.port;
        description = "The port to listen on";
      };

      redirect = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the redirecting to HTTPS";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the libreddit web interface";
      };

    };
  };

  config = mkIf cfg.enable {
    systemd.services.libreddit = {
        description = "Private front-end for Reddit";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          DynamicUser = true;
          ExecStart = "${pkgs.libreddit}/bin/libreddit ${args}";
          AmbientCapabilities = lib.mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];
          Restart = "on-failure";
          RestartSec = "2s";
        };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}

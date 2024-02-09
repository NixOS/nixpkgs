{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.autobrr;
in
{
  options = {
    services.autobrr = {
      enable = mkEnableOption (lib.mdDoc "Autobrr");

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Open ports in the firewall for the Autobrr web interface.";
      };

      configureNginx = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = lib.mdDoc "Configure nginx as a reverse proxy for Autobrr-web and the Go service.";
      };

      package = mkPackageOption pkgs "autobrr" { };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.autobrr = {
      description = "Autobrr";
      after = [ "syslog.target" "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "autobrr";
        StateDirectoryMode = "0700";
        ExecStart = "${pkgs.autobrr}/bin/autobrr --config '${WorkingDirectory}'";
        Restart = "on-failure";
      };
    };

    services.nginx = lib.mkIf cfg.configureNginx {
      enable = true;
      virtualHosts."localhost" = {
        serverName = "localhost";
        listen = [
          { addr = "0.0.0.0"; port = 7575; }
        ];

        # Compiled NPM package
        locations."/" = {
          root = "${pkgs.autobrr}/autobrr-web";
          index = "index.html";
        };

        # Go service
        locations."/api" = {
          proxyPass = "http://127.0.0.1:7474";
        };
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 7575 ];
    };
  };
}

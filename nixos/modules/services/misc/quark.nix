{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.quark;

in

{
  options.services.quark = {
    enable = mkEnableOption (lib.mdDoc "Enable quark webserver");

    port = mkOption {
      type = types.port;
      default = 80;
      description = lib.mdDoc "Port to run webserver";
    };

    dir = mkOption {
      type = types.path;
      default = /var/www/html;
      description = lib.mdDoc "Directory to serve files";
    };
    host = mkOption {
      type = types.str;
      default = "localhost";
      description = lib.mdDoc ''
        Domain name/ip for the service
      '';
    };
    systemdServiceName = mkOption {
      type = types.str;
      default = "quark";
      description = lib.mdDoc ''
        Name for the systemd service
      '';
    };
    openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Open the default ports in the firewall for the media server. The
          HTTP/HTTPS ports can be changed in the Web UI, so this option should
          only be used if they are unchanged.
        '';
      };
    nginx = {
      enable = lib.mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to configure nginx as a reverse proxy for quark.

          It serves it under the domain specified in {option}`services.invidious
          Further configuration can be done through {option}`services.nginx.virt
          which can also be used to disable AMCE and TLS.
      '';
      };
      url= lib.mkOption {
        type = types.str;
        default = "localhost";
        description = ''
        Domain name/ip for nginx to find quark, if port has not been changed it is localhost
        (port 80) but if the port is modified or the ip is not localhost you should
        change this
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.quark ];
    systemd.packages = [ pkgs.quark ];

    systemd.services.${cfg.systemdServiceName} = {
      description = "Quark Webserver";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "network-online.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.quark}/bin/quark -p ${toString cfg.port} -d ${cfg.dir} -h ${cfg.host}";
      };
    };
    services.nginx = {
      enable = cfg.nginx.enable;
      virtualHosts.${cfg.nginx.url} = {
        locations."/".proxyPass = "http://${cfg.host}:${toString cfg.port}";
        enableACME = lib.mkDefault true;
        forceSSL = lib.mkDefault true;
      };

  };
    networking.firewall.allowedTCPPorts =
      lib.optional (cfg.enable && cfg.openFirewall) cfg.port;
  };

  meta = {
    maintainers = with lib.maintainers; [ talleyrand34 ];
  };
}

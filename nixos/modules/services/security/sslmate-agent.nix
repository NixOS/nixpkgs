{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sslmate-agent;

in {
  meta.maintainers = [ ];

  options = {
    services.sslmate-agent = {
      enable = mkEnableOption "sslmate-agent, a daemon for managing SSL/TLS certificates on a server";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ sslmate-agent ];

    systemd = {
      packages = [ pkgs.sslmate-agent ];
      services.sslmate-agent = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ConfigurationDirectory = "sslmate-agent";
          LogsDirectory = "sslmate-agent";
          StateDirectory = "sslmate-agent";
        };
      };
    };
  };
}

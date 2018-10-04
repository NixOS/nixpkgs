{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.racoon;
in {
  options.services.racoon = {
    enable = mkEnableOption "racoon";

    config = mkOption {
      description = "Contents of racoon configuration file.";
      default = "";
      type = types.str;
    };

    configPath = mkOption {
      description = "Location of racoon config if config is not provided.";
      default = "/etc/racoon/racoon.conf";
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.racoon = {
      description = "Racoon Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.ipsecTools}/bin/racoon -f ${
          if (cfg.config != "") then pkgs.writeText "racoon.conf" cfg.config
          else cfg.configPath
        }";
        ExecReload = "${pkgs.ipsecTools}/bin/racoonctl reload-config";
        PIDFile = "/run/racoon.pid";
        Type = "forking";
        Restart = "always";
      };
      preStart = ''
        rm /run/racoon.pid || true
        mkdir -p /var/racoon
      '';
    };
  };
}

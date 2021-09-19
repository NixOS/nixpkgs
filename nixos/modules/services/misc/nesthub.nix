{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nesthub;
in {
  options = {
    services.nesthub = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the Nesthub service.";
      };
      configPath = mkOption {
        type = types.str;
        default = "/var/lib/nesthub/config.json";
        description = "Path to the config file.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.nesthub = {
      description = "Nesthub Homekit bridge for Nest thermostats";
      serviceConfig = {
        ExecStart = "${pkgs.nesthub}/bin/nesthub -config ${config.services.nesthub.configPath}";
      };
      after = [ "network.online" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}


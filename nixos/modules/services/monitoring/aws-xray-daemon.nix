{ config, lib, pkgs, ... }:

with lib;

let

cfg = config.services.aws-xray-daemon;

configFile = pkgs.writeText "xray.yaml" cfg.configs;

in
{
  options.services.aws-xray-daemon = {
    enable = mkOption {
      description = "Whether to enable aws-xray-daemon service";
      default = false;
      type = types.bool;
    };

    package = mkOption {
      description = "Which aws-xray-daemon package to use";
      default = pkgs.aws-xray-daemon;
      type = types.package;
    };

    configs = mkOption {
      description = "Aws xray configurations json or yaml formatted.";
      default = "Version: 2";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.services.aws-xray-daemon = {
      description = "aws xray daemon service";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      serviceConfig = {
          ExecStart = "${cfg.package.bin}/bin/daemon --config ${configFile}";
          User = "xray";
      };
    };

    users.users.xray = {
      description = "xray user";
    };
  };
}
{ config, lib, pkgs, ... }:

with lib;

let

cfg = config.services.aws-xray-daemon;

configFile = pkgs.writeText "xray.yaml" cfg.config;

in
{
  options.services.aws-xray-daemon = {
    enable = mkEnableOption "Whether to enable aws-xray-daemon service";

    package = mkOption {
      description = "Which aws-xray-daemon package to use";
      default = pkgs.aws-xray-daemon;
      defaultText = "pkgs.aws-xray-daemon";
      type = types.package;
    };

    config = mkOption {
      description = "Aws xray configurations json or yaml formatted.";
      default = "Version: 2";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.aws-xray-daemon = {
      description = "aws xray daemon service";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      serviceConfig = {
          DynamicUser = true;
          ExecStart = "${cfg.package.bin}/bin/daemon --config ${configFile}";
      };
    };
  };
}
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.ssm-agent;
in {
  options.services.ssm-agent = {
    enable = mkEnableOption "AWS SSM agent";

    package = mkOption {
      type = types.path;
      description = "The SSM agent package to use";
      default = pkgs.ssm-agent;
      defaultText = "pkgs.ssm-agent";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.ssm-agent = {
      inherit (cfg.package.meta) description;
      after    = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.coreutils pkgs.lsb-release ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/amazon-ssm-agent";
        KillMode = "process";
        Restart = "on-failure";
        RestartSec = "15min";
      };
    };

    # Add user that Session Manager needs, and give it sudo.
    # This is consistent with Amazon Linux 2 images.
    security.sudo.extraRules = [
      {
        users = [ "ssm-user" ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
    # On Amazon Linux 2 images, the ssm-user user is pretty much a
    # normal user with its own group. We do the same.
    users.groups.ssm-user = {};
    users.users.ssm-user = {
      isNormalUser = true;
      group = "ssm-user";
    };
  };
}

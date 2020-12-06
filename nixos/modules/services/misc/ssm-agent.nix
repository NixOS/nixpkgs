{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.ssm-agent;

  # The SSM agent doesn't pay attention to our /etc/os-release yet, and the lsb-release tool
  # in nixpkgs doesn't seem to work properly on NixOS, so let's just fake the two fields SSM
  # looks for. See https://github.com/aws/amazon-ssm-agent/issues/38 for upstream fix.
  fake-lsb-release = pkgs.writeScriptBin "lsb_release" ''
    #!${pkgs.runtimeShell}

    case "$1" in
      -i) echo "nixos";;
      -r) echo "${config.system.nixos.version}";;
    esac
  '';
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

      path = [ fake-lsb-release pkgs.coreutils ];
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

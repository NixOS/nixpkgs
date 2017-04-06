{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.ssm-agent;

  # The SSM agent doesn't pay attention to our /etc/os-release yet, and the lsb-release tool
  # in nixpkgs doesn't seem to work properly on NixOS, so let's just fake the two fields SSM
  # looks for. See https://github.com/aws/amazon-ssm-agent/issues/38 for upstream fix.
  fake-lsb-release = pkgs.writeScriptBin "lsb_release" ''
    #!${pkgs.stdenv.shell}

    case "$1" in
      -i) echo "nixos";;
      -r) echo "${config.system.nixosVersion}";;
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

      path = [ fake-lsb-release ];
      serviceConfig = {
        ExecStart = "${cfg.package.bin}/bin/agent";
        KillMode = "process";
        Restart = "on-failure";
        RestartSec = "15min";
      };
    };
  };
}


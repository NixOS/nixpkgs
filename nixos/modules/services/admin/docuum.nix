{ config, pkgs, lib, utils, ... }:

let
  cfg = config.services.docuum;
  inherit (lib) mkIf mkEnableOption mkOption getExe types;
in
{
  options.services.docuum = {
    enable = mkEnableOption "docuum daemon";

    threshold = mkOption {
      description = "Threshold for deletion in bytes, like `10 GB`, `10 GiB`, `10GB` or percentage-based thresholds like `50%`";
      type = types.str;
      default = "10 GB";
      example = "50%";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.virtualisation.docker.enable;
        message = "docuum requires docker on the host";
      }
    ];

    systemd.services.docuum = {
      after = [ "docker.socket" ];
      requires = [ "docker.socket" ];
      wantedBy = [ "multi-user.target" ];
      path = [ config.virtualisation.docker.package ];
      environment.HOME = "/var/lib/docuum";

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "docuum";
        SupplementaryGroups = [ "docker" ];
        ExecStart = utils.escapeSystemdExecArgs [
          (getExe pkgs.docuum)
          "--threshold" cfg.threshold
        ];
      };
    };
  };
}

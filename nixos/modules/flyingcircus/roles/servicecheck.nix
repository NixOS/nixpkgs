# This node runs service checks as defined in directory.
# Requires ring 0 access.
{ config, lib, pkgs, ...}:

let
  cfg = config.flyingcircus;

in
{

  options = {
    flyingcircus.roles.servicecheck = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Flying Circus Service Check role.";
      };
    };
  };

  config = lib.mkIf config.flyingcircus.roles.servicecheck.enable {

    systemd.services.fc-servicecheck = {
      description = "Flying Circus global Service Checks";
      # Run this *before* fc-manage rebuilds the system. This service loads
      # off the sensu configuration for nixos to pick it up.
      wantedBy = [ "fc-manage.service" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      restartIfChanged = false;
      unitConfig.X-StopOnRemoval = false;
      serviceConfig.Type = "oneshot";
      environment = config.nix.envVars // {
        inherit (config.environment.sessionVariables) NIX_PATH SSL_CERT_FILE;
        HOME = "/root";
      };

      script = ''
        ${pkgs.fcmanage}/bin/fc-monitor \
          --enc ${config.flyingcircus.enc_path} \
          configure-checks
        '';
    };

  };

}

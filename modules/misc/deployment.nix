{ config, pkgs, ... }:

with pkgs.lib;

{
  options = {
    deployment.targetHost = mkOption {
      default = config.networking.hostName;
      description = ''
        This option specifies a hostname or IP address which can be used by nixos-deploy-network
        to execute remote deployment operations.
      '';
    };
  };
}

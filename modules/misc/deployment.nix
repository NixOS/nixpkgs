{ config, pkgs, ... }:

with pkgs.lib;

{
  options = {

    deployment = {
      targetHost = mkOption {
        description = ''
          This option specifies a hostname or IP address which can be used by nixos-deploy-network
	  to execute remote deployment operations.
        '';
      };
    };
  };
}

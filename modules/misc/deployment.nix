{ config, pkgs, ... }:

with pkgs.lib;

{
  options = {

    deployment = mkOption {
      description = ''
        This option captures various custom attributes related to the configuration of the system, which
        are not directly used for building a system configuration. Usually these attributes
        are used by external tooling, such as the nixos-deploy-network tool or the Disnix Avahi
        publisher.
      '';
      default = {};
      example = {
        description = "My production machine";
	hostname = "my.test.org";
	country = "NL";
      };
    };
  };
}

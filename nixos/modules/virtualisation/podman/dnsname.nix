{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkOption
    mkIf
    types
    ;

  cfg = config.virtualisation.podman;

in
{
  options = {
    virtualisation.podman = {

      defaultNetwork.dnsname.enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable DNS resolution in the default podman network.
        '';
      };

    };
  };

  config = {
    virtualisation.containers.containersConf.cniPlugins = mkIf cfg.defaultNetwork.dnsname.enable [ pkgs.dnsname-cni ];
    virtualisation.podman.defaultNetwork.extraPlugins =
      lib.optional cfg.defaultNetwork.dnsname.enable {
        type = "dnsname";
        domainName = "dns.podman";
        capabilities.aliases = true;
      };
  };
}

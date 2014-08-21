{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.vpnc;
  mkServiceDef = name: value:
    {
      source = builtins.toFile "${name}.conf" value;
      target = "vpnc/${name}.conf";
    };

in
{
  options = {
    networking.vpnc = {
      services = mkOption {
       type = types.attrsOf types.str;
       default = [];
       example = {
         test = 
          ''
           IPSec gateway 192.168.1.1 
           IPSec ID someID
           IPSec secret secretKey
           Xauth username name
           Xauth password pass
          '';
       };
       description = 
         ''
           The names of cisco VPNs and their associated definitions
         '';
      };
    };
  };

  config.environment.etc = mapAttrsToList mkServiceDef cfg.services;
}



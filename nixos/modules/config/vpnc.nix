{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.vpnc;
  mkServiceDef = name: value:
    {
      name = "vpnc/${name}.conf";
      value = { text = value; };
    };

in
{
  options = {
    networking.vpnc = {
      services = mkOption {
       type = types.attrsOf types.str;
       default = {};
       example = literalExample ''
         { test = '''
             IPSec gateway 192.168.1.1
             IPSec ID someID
             IPSec secret secretKey
             Xauth username name
             Xauth password pass
           ''';
         }
       '';
       description = 
         ''
           The names of cisco VPNs and their associated definitions
         '';
      };
    };
  };

  config.environment.etc = mapAttrs' mkServiceDef cfg.services;
}



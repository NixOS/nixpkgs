{ config, lib, pkgs, ... }: with lib;
let
    cfg = config.flyingcircus.roles.powerdns;

    local_path = /etc/local/powerdns;

in

{

  options = {

    flyingcircus.roles.powerdns = {

      enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable the Flying Circus Powerdns server role.";
      };
    };
  };


  config = mkIf cfg.enable {

    services.powerdns.enable = true;
    services.powerdns.configDir = local_path;

    system.activationScripts.fcio-powerdns = ''
      install -d -o  ${toString config.ids.uids.powerdns} -g service  -m 02775 /etc/local/powerdns
    '';

  };
}

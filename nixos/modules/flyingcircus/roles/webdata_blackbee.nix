{ config, lib, pkgs, ... }: with lib;
# Customer specific role

let
  cfg = config.flyingcircus.roles.webdata_blackbee;

in
{

  options = {

    flyingcircus.roles.webdata_blackbee = {

      enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable the customer specific role.";
      };

    };

  };


  config = mkIf cfg.enable {

    environment.etc.blackbee.source = "/srv/s-blackbee/etc";

    system.activationScripts.webdata_blackbee = ''
      test -L /home/pricing || ln -s /srv/s-blackbee/pricing /home/pricing
    '';

  };

}

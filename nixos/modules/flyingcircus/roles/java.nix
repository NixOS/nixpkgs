{ config, lib, pkgs, ... }: with lib;
let
  cfg = config.flyingcircus.roles.java;

in
{

  options = {

    flyingcircus.roles.java = {

      enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable the Flying Circus java role.";
      };

    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.jdk
    ];

};
}

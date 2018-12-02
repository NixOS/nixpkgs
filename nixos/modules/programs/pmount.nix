{ config, lib, pkgs, ... }:

{
  options.programs.pmount.enable = lib.mkEnableOption "pmount with setuid wrapper";

  config = lib.mkIf config.programs.pmount.enable {

    security.wrappers = {
      pmount.source = "${pkgs.pmount.out}/bin/pmount";
      pumount.source = "${pkgs.pmount.out}/bin/pumount";
    };

    system.activationScripts.pmount = "mkdir -p /media";

  };
}

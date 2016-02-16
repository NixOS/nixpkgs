{ config, pkgs, lib, ... }:

with lib;

let 
  cfg = config.i18n.inputMethod.nabi;
in
{
  options = {

    i18n.inputMethod.nabi = {
      enable = mkOption {
        type    = types.bool;
        default = false;
        example = true;
        description = ''
          Enable nabi input method.
          Nabi can be used to input Korean.
        '';
      };
    };

  };
{
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.nabi ];
    qtPlugins  = [ pkgs.nabi ];

    environment.variables = {
      GTK_IM_MODULE = "nabi";
      QT_IM_MODULE  = "nabi";
      XMODIFIERS    = "@im=nabi";
    };

    services.xserver.displayManager.sessionCommands = "${pkgs.nabi}/bin/nabi &";
  };
}

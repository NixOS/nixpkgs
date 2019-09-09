{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.desktopManager.xsession;

in

{
  options = {

    services.xserver.desktopManager.xsession.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable ~/.xsession as a desktop manager.";
    };

  };

  config = mkIf cfg.enable {

    services.xserver.desktopManager.session = singleton
      { name = "xsession";
        start = ''
          ${pkgs.gnome3.zenity}/bin/zenity --error --text 'The user must provide a ~/.xsession file containing session startup commands.' --no-wrap
        '';
      };

  };

}

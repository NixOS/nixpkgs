{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.xserver.wacom;

in

{

  options = {

    services.xserver.wacom = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the Wacom touchscreen/digitizer/tablet.
          If you ever have any issues such as, try switching to terminal (ctrl-alt-F1) and back
          which will make Xorg reconfigure the device ?

          If you're not satisfied by the default behaviour you can override
          {option}`environment.etc."X11/xorg.conf.d/70-wacom.conf"` in
          configuration.nix easily.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.xf86-input-wacom ]; # provides xsetwacom

    services.xserver.modules = [ pkgs.xf86-input-wacom ];

    services.udev.packages = [ pkgs.xf86-input-wacom ];

    environment.etc."X11/xorg.conf.d/70-wacom.conf".source =
      "${pkgs.xf86-input-wacom}/share/X11/xorg.conf.d/70-wacom.conf";

  };

}

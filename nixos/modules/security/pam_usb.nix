{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.security.pam.usb;

  anyUsbAuth = any (attrByPath ["usbAuth"] false) (attrValues config.security.pam.services);

in

{
  options = {

    security.pam.usb = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable USB login for all login systems that support it.  For
          more information, visit <https://github.com/aluzzardi/pam_usb/wiki/Getting-Started#setting-up-devices-and-users>.
        '';
      };

    };

  };

  config = mkIf (cfg.enable || anyUsbAuth) {

    # Make sure pmount and pumount are setuid wrapped.
    security.wrappers = {
      pmount =
        { setuid = true;
          owner = "root";
          group = "root";
          source = "${pkgs.pmount.out}/bin/pmount";
        };
      pumount =
        { setuid = true;
          owner = "root";
          group = "root";
          source = "${pkgs.pmount.out}/bin/pumount";
        };
    };

    environment.systemPackages = [ pkgs.pmount ];

  };
}

{ config, lib, pkgs, ... }:

with lib;

let

  inherit (pkgs) pam_usb;

  cfg = config.security.pam.usb;

  anyUsbAuth = any (attrByPath ["usbAuth"] false) (attrValues config.security.pam.services);

in

{
  options = {

    security.pam.usb = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable USB login for all login systems that support it.  For
          more information, visit <link
          xlink:href="http://pamusb.org/doc/quickstart#setting_up" />.
        '';
      };

    };

  };

  config = mkIf (cfg.enable || anyUsbAuth) {

    # Make sure pmount and pumount are setuid wrapped.
    security.wrappers = {
      pmount.source = "${pkgs.pmount.out}/bin/pmount";
      pumount.source = "${pkgs.pmount.out}/bin/pumount";
    };

    environment.systemPackages = [ pkgs.pmount ];

  };
}

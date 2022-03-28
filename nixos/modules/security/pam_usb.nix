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
        description = ''
          DEPRECATED, please use <literal>security.pam.services.*.usbAuth</literal>
          instead, as this option is very coarse-grained.
          I.e. <literal>security.pam.services.login.usbAuth = true</literal>

          Enable USB login for all login systems that support it.  For
          more information, visit <link
          xlink:href="https://github.com/aluzzardi/pam_usb/wiki/Getting-Started#setting-up-devices-and-users" />.
        '';
      };

    };

  };

  config = mkIf (cfg.enable || anyUsbAuth) {

    warnings =  optional config.security.pam.usb.enable ''
      DEPRECATED, please use `security.pam.services.<name>.usbAuth`
      instead, as this option is very coarse-grained.
      I.e. `security.pam.services.login.usbAuth = true`
    '';

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

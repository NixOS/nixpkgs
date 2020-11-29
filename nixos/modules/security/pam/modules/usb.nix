{ config, pkgs, lib, ... }:

with lib;

let
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.usb;

  anyEnable = any (attrByPath [ "modules" "usb" "enable" ] false) (attrValues pamCfg.services);

  moduleOptions = global: {
    enable = mkOption {
      type = types.bool;
      default = if global then false else cfg.enable;
      description = ''
        Enable USB login for all login systems that support it. For more
        information, visit <link
        xlink:href="https://github.com/aluzzardi/pam_usb/wiki/Getting-Started#setting-up-devices-and-users" />.
      '';
    };
  };
in
{
  options = {
    security.pam = {
      services = mkOption {
        type = with types; attrsOf (submodule
          ({ config, ... }: {
            options = {
              modules.usb = moduleOptions false;
            };

            config = mkIf config.modules.usb.enable {
              auth.usb = {
                control = "sufficient";
                path = "${pkgs.pam_usb}/lib/security/pam_usb.so";
                order = 18000;
              };
            };
          })
        );
      };

      modules.usb = moduleOptions true;
    };
  };

  config = mkIf (cfg.enable || anyEnable) {
    # Make sure pmount and pumount are setuid wrapped.
    security.wrappers = {
      pmount.source = "${pkgs.pmount.out}/bin/pmount";
      pumount.source = "${pkgs.pmount.out}/bin/pumount";
    };

    environment.systemPackages = [ pkgs.pmount ];
  };
}

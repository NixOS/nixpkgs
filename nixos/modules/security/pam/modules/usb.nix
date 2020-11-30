{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "usb";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      type = types.bool;
      default = if global then false else modCfg.enable;
      description = ''
        Enable USB login for all login systems that support it. For more
        information, visit <link
        xlink:href="https://github.com/aluzzardi/pam_usb/wiki/Getting-Started#setting-up-devices-and-users" />.
      '';
    };
  };

  mkAuthConfig = svcCfg: {
    ${name} = {
      control = "sufficient";
      path = "${pkgs.pam_usb}/lib/security/pam_usb.so";
      order = 18000;
    };
  };
in
{
  options = {
    security.pam = utils.pam.mkPamModule {
      inherit name mkModuleOptions mkAuthConfig;
      mkSvcConfigCondition = svcCfg: svcCfg.modules.${name}.enable;
    };
  };

  config = mkIf (modCfg.enable || (utils.pam.anyEnable pamCfg name)) {
    # Make sure pmount and pumount are setuid wrapped.
    security.wrappers = {
      pmount.source = "${pkgs.pmount.out}/bin/pmount";
      pumount.source = "${pkgs.pmount.out}/bin/pumount";
    };

    environment.systemPackages = [ pkgs.pmount ];
  };
}

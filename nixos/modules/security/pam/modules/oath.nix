{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "oath";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      type = types.bool;
      default = if global then false else modCfg.enable;
      description = ''
        Enable the OATH (one-time password) PAM module.
      '';
    };

    digits = mkOption {
      type = types.enum [ 6 7 8 ];
      default = if global then 6 else modCfg.digits;
      description = ''
        Specify the length of the one-time password in number of
        digits.
      '';
    };

    window = mkOption {
      type = types.int;
      default = if global then 5 else modCfg.window;
      description = ''
        Specify the number of one-time passwords to check in order
        to accommodate for situations where the system and the
        client are slightly out of sync (iteration for HOTP or time
        steps for TOTP).
      '';
    };

    usersFile = mkOption {
      type = types.path;
      default = if global then "/etc/users.oath" else modCfg.usersFile;
      description = ''
        Set the path to file where the user's credentials are
        stored. This file must not be world readable!
      '';
    };
  };

  mkAuthConfig = svcCfg: {
    ${name} = {
      control = "requisite";
      path = "${pkgs.oathToolkit}/lib/security/pam_oath.so";
      args = [
        "window=${toString svcCfg.modules.${name}.window}"
        "usersfile=${toString svcCfg.modules.${name}.usersFile}"
        "digits=${toString svcCfg.modules.${name}.digits}"
      ];
      order = 19000;
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
    environment.systemPackages = [ pkgs.oathToolkit ];
  };
}

{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "gnome-keyring";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      default = if global then false else modCfg.enable;
      type = types.bool;
      description = ''
        If enabled, pam_gnome_keyring will attempt to automatically unlock the
        user's default Gnome keyring upon login. If the user login password
        does not match their keyring password, Gnome Keyring will prompt
        separately after login.
      '';
    };
  };

  control = "optional";
  path = "${pkgs.gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so";

  mkAuthConfig = svcCfg: {
    ${name} = {
      inherit control path;
      order = 25000;
    };
  };

  mkPasswordConfig = svcCfg: {
    ${name} = {
      inherit control path;
      args = [ "use_authtok" ];
      order = 10000;
    };
  };

  mkSessionConfig = svcCfg: {
    ${name} = {
      inherit control path;
      args = [ "auto_start" ];
      order = 17000;
    };
  };
in
{
  options = {
    security.pam = utils.pam.mkPamModule {
      inherit name mkModuleOptions mkAuthConfig mkPasswordConfig mkSessionConfig;
      mkSvcConfigCondition = svcCfg: svcCfg.modules.${name}.enable;
    };
  };
}

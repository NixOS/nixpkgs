{ config, pkgs, lib, ... }:

with lib;

let
  topCfg = config;
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.gnomeKeyring;

  moduleOptions = global: {
    enable = mkOption {
      default = if global then false else cfg.enable;
      type = types.bool;
      description = ''
        If enabled, pam_gnome_keyring will attempt to automatically unlock the
        user's default Gnome keyring upon login. If the user login password
        does not match their keyring password, Gnome Keyring will prompt
        separately after login.
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
              modules.gnomeKeyring = moduleOptions false;
            };

            config = mkIf config.modules.gnomeKeyring.enable {
              auth.gnomeKeyring = {
                control = "optional";
                path = "${pkgs.gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so";
                order = 25000;
              };

              password.gnomeKeyring = {
                control = "optional";
                path = "${pkgs.gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so";
                args = [ "use_authtok" ];
                order = 10000;
              };

              session.gnomeKeyring = {
                control = "optional";
                path = "${pkgs.gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so";
                args = [ "auto_start" ];
                order = 17000;
              };
            };
          })
        );
      };

      modules.gnomeKeyring = moduleOptions true;
    };
  };
}

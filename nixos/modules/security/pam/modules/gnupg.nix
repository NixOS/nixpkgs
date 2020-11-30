{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "gnupg";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      type = types.bool;
      default = if global then false else modCfg.enable;
      description = ''
        If enabled, pam_gnupg will attempt to automatically unlock the
        user's GPG keys with the login password via
        <command>gpg-agent</command>. The keygrips of all keys to be
        unlocked should be written to <filename>~/.pam-gnupg</filename>,
        and can be queried with <command>gpg -K --with-keygrip</command>.
        Presetting passphrases must be enabled by adding
        <literal>allow-preset-passphrase</literal> in
        <filename>~/.gnupg/gpg-agent.conf</filename>.
      '';
    };

    noAutostart = mkOption {
      type = types.bool;
      default = if global then false else modCfg.noAutostart;
      description = ''
        Don't start <command>gpg-agent</command> if it is not running.
        Useful in conjunction with starting <command>gpg-agent</command> as
        a systemd user service.
      '';
    };

    storeOnly = mkOption {
      type = types.bool;
      default = if global then false else modCfg.storeOnly;
      description = ''
        Don't send the password immediately after login, but store for PAM
        <literal>session</literal>.
      '';
    };
  };

  control = "optional";
  path = "${pkgs.pam_gnupg}/lib/security/pam_gnupg.so";

  mkAuthConfig = svcCfg: {
    ${name} = {
      inherit control path;
      args = optional svcCfg.modules.${name}.storeOnly "store-only";
      order = 26000;
    };
  };

  mkSessionConfig = svcCfg: {
    ${name} = {
      inherit control path;
      args = optional config.modules.gnupg.noAutostart "no-autostart";
      order = 18000;
    };
  };
in
{
  options = {
    security.pam = utils.pam.mkPamModule {
      inherit name mkModuleOptions mkAuthConfig mkSessionConfig;
      mkSvcConfigCondition = svcCfg: svcCfg.modules.${name}.enable;
    };
  };
}

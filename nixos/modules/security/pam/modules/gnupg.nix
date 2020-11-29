{ config, pkgs, lib, ... }:

with lib;

let
  topCfg = config;
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.gnupg;

  moduleOptions = global: {
    enable = mkOption {
      type = types.bool;
      default = if global then false else cfg.enable;
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
      default = if global then false else cfg.noAutostart;
      description = ''
        Don't start <command>gpg-agent</command> if it is not running.
        Useful in conjunction with starting <command>gpg-agent</command> as
        a systemd user service.
      '';
    };

    storeOnly = mkOption {
      type = types.bool;
      default = if global then false else cfg.storeOnly;
      description = ''
        Don't send the password immediately after login, but store for PAM
        <literal>session</literal>.
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
              modules.gnupg = moduleOptions false;
            };

            config = mkIf config.modules.gnupg.enable {
              auth.gnupg = {
                control = "optional";
                path = "${pkgs.pam_gnupg}/lib/security/pam_gnupg.so";
                args = optional config.modules.gnupg.storeOnly "store-only";
                order = 26000;
              };

              session.gnupg = {
                control = "optional";
                path = "${pkgs.pam_gnupg}/lib/security/pam_gnupg.so";
                args = optional config.modules.gnupg.noAutostart "no-autostart";
                order = 18000;
              };
            };
          })
        );
      };

      modules.gnupg = moduleOptions true;
    };
  };
}

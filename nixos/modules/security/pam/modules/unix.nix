{ config, pkgs, lib, ... }:

with lib;

let
  topCfg = config;
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.unix;

  moduleOptions = global: {
    enableAuth = mkOption {
      default = if global then true else cfg.enableAuth;
      type = types.bool;
      description = ''
        Whether users can log in with passwords defined in
        <filename>/etc/shadow</filename>.
      '';
    };

    allowNullPassword = mkOption {
      default = if global then false else cfg.allowNullPassword;
      type = types.bool;
      description = ''
        Whether to allow logging into accounts that have no password
        set (i.e., have an empty password field in
        <filename>/etc/passwd</filename> or
        <filename>/etc/group</filename>).  This does not enable
        logging into disabled accounts (i.e., that have the password
        field set to <literal>!</literal>).  Note that regardless of
        what the pam_unix documentation says, accounts with hashed
        empty passwords are always allowed to log in.
      '';
    };

    nodelay = mkOption {
      default = if global then false else cfg.nodelay;
      type = types.bool;
      description = ''
        Whether the delay after typing a wrong password should be disabled.
      '';
    };
  };

  # Modules in this block require having the password set in PAM_AUTHTOK.
  # pam_unix is marked as 'sufficient' on NixOS which means nothing will run
  # after it succeeds. Certain modules need to run after pam_unix
  # prompts the user for password so we run it once with 'required' at an
  # earlier point and it will run again with 'sufficient' further down.
  # We use try_first_pass the second time to avoid prompting password twice
  needRequired = moduleCfg: moduleCfg.ecryptfs.enable
                         || moduleCfg.mount.enable
                         || moduleCfg.kwallet.enable
                         || moduleCfg.gnomeKeyring.enable
                         || moduleCfg.googleAuthenticator.enable
                         || moduleCfg.gnupg.enable
                         || moduleCfg.duoSecurity.enable;
in
{
  options = {
    security.pam = {
      services = mkOption {
        type = with types; attrsOf (submodule
          ({ config, ... }: {
            options = {
              modules.unix = moduleOptions false;
            };

            config = {
              account.unix = {
                control = "required";
                path = "pam_unix.so";
                order = 1000;
              };

              auth = mkIf config.modules.unix.enableAuth {
                unixRequired = mkIf (needRequired config.modules) {
                  control = "required";
                  path = "pam_unix.so";
                  args = flatten [
                    (optional config.modules.unix.allowNullPassword "nullok")
                    (optionalString config.modules.unix.nodelay "nodelay")
                    "likeauth"
                  ];
                  order = 21000;
                };
                unix = {
                  control = "sufficient";
                  path = "pam_unix.so";
                  args = flatten [
                    (optional config.modules.unix.allowNullPassword "nullok")
                    (optional config.modules.unix.nodelay "nodelay")
                    "likeauth"
                    "try_first_pass"
                  ];
                  order = 30000;
                };
              };

              password.unix = {
                control = "sufficient";
                path = "pam_unix.so";
                args = [ "nullok" "sha512" ];
                order = 1000;
              };

              session.unix = {
                control = "required";
                path = "pam_unix.so";
                order = 1000;
              };
            };
          })
        );
      };

      modules.unix = moduleOptions true;
    };
  };
}

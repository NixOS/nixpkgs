{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "unix";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enableAuth = mkOption {
      default = if global then true else modCfg.enableAuth;
      type = types.bool;
      description = ''
        Whether users can log in with passwords defined in
        <filename>/etc/shadow</filename>.
      '';
    };

    allowNullPassword = mkOption {
      default = if global then false else modCfg.allowNullPassword;
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
      default = if global then false else modCfg.nodelay;
      type = types.bool;
      description = ''
        Whether the delay after typing a wrong password should be disabled.
      '';
    };

    debug = mkOption {
      default = if global then false else modCfg.debug;
      type = types.bool;
      description = ''
        Whether to enable the "debug" option of the pam_unix.so module.
      '';
    };
  };

  # Modules in this block require having the password set in PAM_AUTHTOK.
  # pam_unix is marked as 'sufficient' on NixOS which means nothing will run
  # after it succeeds. Certain modules need to run after pam_unix
  # prompts the user for password so we run it once with 'required' at an
  # earlier point and it will run again with 'sufficient' further down.
  # We use try_first_pass the second time to avoid prompting password twice
  needRequired = modulesCfg: modulesCfg.ecryptfs.enable
                          || modulesCfg.pam_mount.enable
                          || modulesCfg.kwallet.enable
                          || modulesCfg.gnome-keyring.enable
                          || modulesCfg.googleAuthenticator.enable
                          || modulesCfg.gnupg.enable
                          || modulesCfg.duosec.enable;

  mkAuthConfig = svcCfg: let cond = svcCfg.modules.${name}.enableAuth; in {
    "${name}Required" = mkIf (cond && (needRequired svcCfg.modules)) {
      control = "required";
      path = "pam_unix.so";
      args = flatten [
        (optional svcCfg.modules.${name}.allowNullPassword "nullok")
        (optionalString svcCfg.modules.${name}.nodelay "nodelay")
        "likeauth"
        (optional svcCfg.modules.${name}.debug "debug")
      ];
      order = 21000;
    };

    ${name} = mkIf cond {
      control = "sufficient";
      path = "pam_unix.so";
      args = flatten [
        (optional svcCfg.modules.${name}.allowNullPassword "nullok")
        (optional svcCfg.modules.${name}.nodelay "nodelay")
        "likeauth"
        "try_first_pass"
        (optional svcCfg.modules.${name}.debug "debug")
      ];
      order = 30000;
    };
  };

  mkAccountConfig = svcCfg: {
    ${name} = {
      control = "required";
      path = "pam_unix.so";
      args = optional svcCfg.modules.${name}.debug "debug";
      order = 1000;
    };
  };

  mkPasswordConfig = svcCfg: {
    ${name} = {
      control = "sufficient";
      path = "pam_unix.so";
      args = flatten [
        "nullok"
        "sha512"
        (optional svcCfg.modules.${name}.debug "debug")
      ];
      order = 1000;
    };
  };

  mkSessionConfig = svcCfg: {
    ${name} = {
      control = "required";
      path = "pam_unix.so";
      args = optional svcCfg.modules.${name}.debug "debug";
      order = 1000;
    };
  };
in
{
  options = {
    security.pam = utils.pam.mkPamModule {
      inherit name mkModuleOptions
              mkAccountConfig mkAuthConfig mkPasswordConfig mkSessionConfig;
    };
  };
}

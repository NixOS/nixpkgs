{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.security.account-utils;
  format = pkgs.formats.ini { };
  isPrivilegedContext = lib.isPrivilegedContext or (config.boot.kernelParams ? "privileged" or false);
in
{
  options.security.account-utils = {
    enable = lib.mkEnableOption "the account-utils implementation of Unix user authentication and management";
    package = lib.mkPackageOption pkgs "account-utils" { };
    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.nonEmptyStr;
      default = [ ];
      example = [
        "--debug"
        "-v"
      ];
      description = ''
        List of arguments to pass to the socket activated service executables.
        ::: {.note}
        This is passed to both pwupdd and pwaccessd, which support identical flags.
        Requires privileged context to operate securely.
        :::
      '';
    };
    pwaccessd.settings = lib.mkOption {
      description = ''
        Options for pwaccessd.
        See {manpage}`pwaccessd.conf(5)` for available options.
      '';
      type = lib.types.submodule {
        freeformType = format.type;
      };
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.singleton {
      assertion = isPrivilegedContext;
      message = ''
        account-utils requires privileged context to operate securely.
        Either run in a privileged container or set kernel parameter "privileged=1".
      '';
    };

    # use account-utils reimplementation of pam_unix only in privileged contexts
    security.pam = lib.mkIf isPrivilegedContext {
      pam_unixModulePath = "${cfg.package}/lib/security/pam_unix_ng.so";
      enableLegacySettings = false;
    };

    systemd = lib.mkIf isPrivilegedContext {
      packages = [ cfg.package ];
      sockets.pwaccessd.wantedBy = [ "sockets.target" ];
      sockets.pwupdd.wantedBy = lib.optional config.users.mutableUsers "sockets.target";
      sockets.newidmapd.wantedBy = [ "sockets.target" ];
      services."pwupdd@".environment.PWUPDD_OPTS = lib.escapeShellArgs cfg.extraArgs;
      services."pwaccessd".environment.PWACCESSD_OPTS = lib.escapeShellArgs cfg.extraArgs;
    };

    environment.systemPackages = lib.mkIf isPrivilegedContext [ cfg.package ];
    environment.etc."account-utils/pwaccessd.conf".source =
      lib.mkIf isPrivilegedContext (format.generate "pwaccessd.conf" cfg.pwaccessd.settings);

    security.pam.services = lib.mkIf isPrivilegedContext {
      pwupd-passwd = { };
      pwupd-chsh = { };
      pwupd-chfn = { };
    };

    # covered by account-utils via socket-activated service
    security.wrappers = {
      # shadow suid binaries are no longer necessary, but disabling the entire shadow module is too intrusive
      newuidmap.enable = false;
      newgidmap.enable = false;
      chsh.enable = lib.mkIf isPrivilegedContext false;
      passwd.enable = lib.mkIf isPrivilegedContext false;

      unix_chkpwd.enable = lib.mkIf isPrivilegedContext false; # Not necessary when using pam_unix_ng.so
    };
  };
}
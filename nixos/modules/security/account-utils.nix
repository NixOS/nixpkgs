{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.security.account-utils;
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
        :::
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # use account-utils reimplementation of pam_unix
    security.pam = {
      pam_unixModulePath = "${cfg.package}/lib/security/pam_unix_ng.so";
      enableLegacySettings = false;
    };

    systemd = {
      packages = [ cfg.package ];
      sockets.pwaccessd.wantedBy = [ "sockets.target" ];
      sockets.pwupdd.wantedBy = lib.optional config.users.mutableUsers "sockets.target"; # immutable users do not need password updating
      sockets.newidmapd.wantedBy = [ "sockets.target" ];
      services."pwupdd@".environment.PWUPDD_OPTS = lib.escapeShellArgs cfg.extraArgs;
      services."pwaccessd".environment.PWACCESSD_OPTS = lib.escapeShellArgs cfg.extraArgs;
    };

    environment.systemPackages = [ cfg.package ];

    security.pam.services = {
      pwupd-passwd = { };
      pwupd-chsh = { };
      pwupd-chfn = { };
    };

    # covered by account-utils via socket-activated service
    security.wrappers = {
      # shadow suid binaries are no longer necessary, but disabling the entire shadow module is too intrusive
      newuidmap.enable = false;
      newgidmap.enable = false;
      chsh.enable = false;
      passwd.enable = false;

      unix_chkpwd.enable = false; # Not necessary when using pam_unix_ng.so
    };
  };
}

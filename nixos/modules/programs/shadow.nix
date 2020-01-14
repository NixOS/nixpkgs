# Configuration for the pwdutils suite of tools: passwd, useradd, etc.

{ config, lib, utils, pkgs, ... }:

with lib;

let

  /*
  There are three different sources for user/group id ranges, each of which gets
  used by different programs:
  - The login.defs file, used by the useradd, groupadd and newusers commands
  - The update-users-groups.pl file, used by NixOS in the activation phase to
    decide on which ids to use for declaratively defined users without a static
    id
  - Systemd compile time options -Dsystem-uid-max= and -Dsystem-gid-max=, used
    by systemd for features like ConditionUser=@system and systemd-sysusers
  */
  loginDefs =
    ''
      DEFAULT_HOME yes

      SYS_UID_MIN  400
      SYS_UID_MAX  999
      UID_MIN      1000
      UID_MAX      29999

      SYS_GID_MIN  400
      SYS_GID_MAX  999
      GID_MIN      1000
      GID_MAX      29999

      TTYGROUP     tty
      TTYPERM      0620

      # Ensure privacy for newly created home directories.
      UMASK        077

      # Uncomment this and install chfn SUID to allow non-root
      # users to change their account GECOS information.
      # This should be made configurable.
      #CHFN_RESTRICT frwh

    '';

in

{

  ###### interface

  options = {

    users.defaultUserShell = lib.mkOption {
      description = ''
        This option defines the default shell assigned to user
        accounts. This can be either a full system path or a shell package.

        This must not be a store path, since the path is
        used outside the store (in particular in /etc/passwd).
      '';
      example = literalExample "pkgs.zsh";
      type = types.either types.path types.shellPackage;
    };

  };


  ###### implementation

  config = {

    environment.systemPackages =
      lib.optional config.users.mutableUsers pkgs.shadow ++
      lib.optional (types.shellPackage.check config.users.defaultUserShell)
        config.users.defaultUserShell;

    environment.etc =
      { # /etc/login.defs: global configuration for pwdutils.  You
        # cannot login without it!
        "login.defs".source = pkgs.writeText "login.defs" loginDefs;

        # /etc/default/useradd: configuration for useradd.
        "default/useradd".source = pkgs.writeText "useradd"
          ''
            GROUP=100
            HOME=/home
            SHELL=${utils.toShellPath config.users.defaultUserShell}
          '';
      };

    security.pam.services =
      { chsh = { rootOK = true; };
        chfn = { rootOK = true; };
        su = { rootOK = true; forwardXAuth = true; logFailures = true; };
        passwd = {};
        # Note: useradd, groupadd etc. aren't setuid root, so it
        # doesn't really matter what the PAM config says as long as it
        # lets root in.
        useradd = { rootOK = true; };
        usermod = { rootOK = true; };
        userdel = { rootOK = true; };
        groupadd = { rootOK = true; };
        groupmod = { rootOK = true; };
        groupmems = { rootOK = true; };
        groupdel = { rootOK = true; };
        login = { startSession = true; allowNullPassword = true; showMotd = true; updateWtmp = true; };
        chpasswd = { rootOK = true; };
      };

    security.wrappers = {
      su.source        = "${pkgs.shadow.su}/bin/su";
      sg.source        = "${pkgs.shadow.out}/bin/sg";
      newgrp.source    = "${pkgs.shadow.out}/bin/newgrp";
      newuidmap.source = "${pkgs.shadow.out}/bin/newuidmap";
      newgidmap.source = "${pkgs.shadow.out}/bin/newgidmap";
    } // (if config.users.mutableUsers then {
      passwd.source    = "${pkgs.shadow.out}/bin/passwd";
    } else {});
  };
}

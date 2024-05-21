# Configuration for the pwdutils suite of tools: passwd, useradd, etc.
{ config, lib, utils, pkgs, ... }:
let
  cfg = config.security.loginDefs;
in
{
  options = with lib.types; {
    security.loginDefs = {
      package = lib.mkPackageOption pkgs "shadow" { };

      chfnRestrict = lib.mkOption {
        description = ''
          Use chfn SUID to allow non-root users to change their account GECOS information.
        '';
        type = nullOr str;
        default = null;
      };

      settings = lib.mkOption {
        description = ''
          Config options for the /etc/login.defs file, that defines
          the site-specific configuration for the shadow password suite.
          See login.defs(5) man page for available options.
        '';
        type = submodule {
          freeformType = (pkgs.formats.keyValue { }).type;
          /* There are three different sources for user/group id ranges, each of which gets
             used by different programs:
             - The login.defs file, used by the useradd, groupadd and newusers commands
             - The update-users-groups.pl file, used by NixOS in the activation phase to
               decide on which ids to use for declaratively defined users without a static
               id
             - Systemd compile time options -Dsystem-uid-max= and -Dsystem-gid-max=, used
               by systemd for features like ConditionUser=@system and systemd-sysusers
              */
          options = {
            DEFAULT_HOME = lib.mkOption {
              description = "Indicate if login is allowed if we can't cd to the home directory.";
              default = "yes";
              type = enum [ "yes" "no" ];
            };

            ENCRYPT_METHOD = lib.mkOption {
              description = "This defines the system default encryption algorithm for encrypting passwords.";
              # The default crypt() method, keep in sync with the PAM default
              default = "YESCRYPT";
              type = enum [ "YESCRYPT" "SHA512" "SHA256" "MD5" "DES"];
            };

            SYS_UID_MIN = lib.mkOption {
              description = "Range of user IDs used for the creation of system users by useradd or newusers.";
              default = 400;
              type = int;
            };

            SYS_UID_MAX = lib.mkOption {
              description = "Range of user IDs used for the creation of system users by useradd or newusers.";
              default = 999;
              type = int;
            };

            UID_MIN = lib.mkOption {
              description = "Range of user IDs used for the creation of regular users by useradd or newusers.";
              default = 1000;
              type = int;
            };

            UID_MAX = lib.mkOption {
              description = "Range of user IDs used for the creation of regular users by useradd or newusers.";
              default = 29999;
              type = int;
            };

            SYS_GID_MIN = lib.mkOption {
              description = "Range of group IDs used for the creation of system groups by useradd, groupadd, or newusers";
              default = 400;
              type = int;
            };

            SYS_GID_MAX = lib.mkOption {
              description = "Range of group IDs used for the creation of system groups by useradd, groupadd, or newusers";
              default = 999;
              type = int;
            };

            GID_MIN = lib.mkOption {
              description = "Range of group IDs used for the creation of regular groups by useradd, groupadd, or newusers.";
              default = 1000;
              type = int;
            };

            GID_MAX = lib.mkOption {
              description = "Range of group IDs used for the creation of regular groups by useradd, groupadd, or newusers.";
              default = 29999;
              type = int;
            };

            TTYGROUP = lib.mkOption {
              description = ''
                The terminal permissions: the login tty will be owned by the TTYGROUP group,
                and the permissions will be set to TTYPERM'';
              default = "tty";
              type = str;
            };

            TTYPERM = lib.mkOption {
              description = ''
                The terminal permissions: the login tty will be owned by the TTYGROUP group,
                and the permissions will be set to TTYPERM'';
              default = "0620";
              type = str;
            };

            # Ensure privacy for newly created home directories.
            UMASK = lib.mkOption {
              description = "The file mode creation mask is initialized to this value.";
              default = "077";
              type = str;
            };
          };
        };
        default = { };
      };
    };

    users.defaultUserShell = lib.mkOption {
      description = ''
        This option defines the default shell assigned to user
        accounts. This can be either a full system path or a shell package.

        This must not be a store path, since the path is
        used outside the store (in particular in /etc/passwd).
      '';
      example = lib.literalExpression "pkgs.zsh";
      type = either path shellPackage;
    };
  };

  ###### implementation

  config = {
    assertions = [
      {
        assertion = cfg.settings.SYS_UID_MIN <= cfg.settings.SYS_UID_MAX;
        message = "SYS_UID_MIN must be less than or equal to SYS_UID_MAX";
      }
      {
        assertion = cfg.settings.UID_MIN <= cfg.settings.UID_MAX;
        message = "UID_MIN must be less than or equal to UID_MAX";
      }
      {
        assertion = cfg.settings.SYS_GID_MIN <= cfg.settings.SYS_GID_MAX;
        message = "SYS_GID_MIN must be less than or equal to SYS_GID_MAX";
      }
      {
        assertion = cfg.settings.GID_MIN <= cfg.settings.GID_MAX;
        message = "GID_MIN must be less than or equal to GID_MAX";
      }
    ];

    security.loginDefs.settings.CHFN_RESTRICT =
      lib.mkIf (cfg.chfnRestrict != null) cfg.chfnRestrict;

    environment.systemPackages = lib.optional config.users.mutableUsers cfg.package
      ++ lib.optional (lib.types.shellPackage.check config.users.defaultUserShell) config.users.defaultUserShell
      ++ lib.optional (cfg.chfnRestrict != null) pkgs.util-linux;

    environment.etc =
      # Create custom toKeyValue generator
      # see https://man7.org/linux/man-pages/man5/login.defs.5.html for config specification
      let
        toKeyValue = lib.generators.toKeyValue {
          mkKeyValue = lib.generators.mkKeyValueDefault { } " ";
        };
      in
      {
        # /etc/login.defs: global configuration for pwdutils.
        # You cannot login without it!
        "login.defs".source = pkgs.writeText "login.defs" (toKeyValue cfg.settings);

        # /etc/default/useradd: configuration for useradd.
        "default/useradd".source = pkgs.writeText "useradd" ''
          GROUP=100
          HOME=/home
          SHELL=${utils.toShellPath config.users.defaultUserShell}
        '';
      };

    security.pam.services = {
      chsh = { rootOK = true; };
      chfn = { rootOK = true; };
      su = {
        rootOK = true;
        forwardXAuth = true;
        logFailures = true;
      };
      passwd = { };
      # Note: useradd, groupadd etc. aren't setuid root, so it
      # doesn't really matter what the PAM config says as long as it
      # lets root in.
      useradd.rootOK = true;
      usermod.rootOK = true;
      userdel.rootOK = true;
      groupadd.rootOK = true;
      groupmod.rootOK = true;
      groupmems.rootOK = true;
      groupdel.rootOK = true;
      login = {
        startSession = true;
        allowNullPassword = true;
        showMotd = true;
        updateWtmp = true;
      };
      chpasswd = { rootOK = true; };
    };

    security.wrappers =
      let
        mkSetuidRoot = source: {
          setuid = true;
          owner = "root";
          group = "root";
          inherit source;
        };
      in
      {
        su = mkSetuidRoot "${cfg.package.su}/bin/su";
        sg = mkSetuidRoot "${cfg.package.out}/bin/sg";
        newgrp = mkSetuidRoot "${cfg.package.out}/bin/newgrp";
        newuidmap = mkSetuidRoot "${cfg.package.out}/bin/newuidmap";
        newgidmap = mkSetuidRoot "${cfg.package.out}/bin/newgidmap";
      }
      // lib.optionalAttrs config.users.mutableUsers {
        chsh = mkSetuidRoot "${cfg.package.out}/bin/chsh";
        passwd = mkSetuidRoot "${cfg.package.out}/bin/passwd";
      };
  };
}

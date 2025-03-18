# This module provides configuration for the PAM (Pluggable
# Authentication Modules) system.

{ config, lib, pkgs, ... }:

with lib;

let

  moduleSettingsType = with types; attrsOf (nullOr (oneOf [ bool str int pathInStore ]));
  moduleSettingsDescription = ''
    Boolean values render just the key if true, and nothing if false.
    Null values are ignored.
    All other values are rendered as key-value pairs.
  '';

  mkRulesTypeOption = type: mkOption {
    # These options are experimental and subject to breaking changes without notice.
    description = ''
      PAM `${type}` rules for this service.

      Attribute keys are the name of each rule.
    '';
    type = types.attrsOf (types.submodule ({ name, config, ... }: {
      options = {
        name = mkOption {
          type = types.str;
          description = ''
            Name of this rule.
          '';
          internal = true;
          readOnly = true;
        };
        enable = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether this rule is added to the PAM service config file.
          '';
        };
        order = mkOption {
          type = types.int;
          description = ''
            Order of this rule in the service file. Rules are arranged in ascending order of this value.

            ::: {.warning}
            The `order` values for the built-in rules are subject to change. If you assign a constant value to this option, a system update could silently reorder your rule. You could be locked out of your system, or your system could be left wide open. When using this option, set it to a relative offset from another rule's `order` value:

            ```nix
            {
              security.pam.services.login.rules.auth.foo.order =
                config.security.pam.services.login.rules.auth.unix.order + 10;
            }
            ```
            :::
          '';
        };
        control = mkOption {
          type = types.str;
          description = ''
            Indicates the behavior of the PAM-API should the module fail to succeed in its authentication task. See `control` in {manpage}`pam.conf(5)` for details.
          '';
        };
        modulePath = mkOption {
          type = types.str;
          description = ''
            Either the full filename of the PAM to be used by the application (it begins with a '/'), or a relative pathname from the default module location. See `module-path` in {manpage}`pam.conf(5)` for details.
          '';
        };
        args = mkOption {
          type = types.listOf types.str;
          description = ''
            Tokens that can be used to modify the specific behavior of the given PAM. Such arguments will be documented for each individual module. See `module-arguments` in {manpage}`pam.conf(5)` for details.

            Escaping rules for spaces and square brackets are automatically applied.

            {option}`settings` are automatically added as {option}`args`. It's recommended to use the {option}`settings` option whenever possible so that arguments can be overridden.
          '';
        };
        settings = mkOption {
          type = moduleSettingsType;
          default = {};
          description = ''
            Settings to add as `module-arguments`.

            ${moduleSettingsDescription}
          '';
        };
      };
      config = {
        inherit name;
        # Formats an attrset of settings as args for use as `module-arguments`.
        args = concatLists (flip mapAttrsToList config.settings (name: value:
          if isBool value
          then optional value name
          else optional (value != null) "${name}=${toString value}"
        ));
      };
    }));
  };

  package = config.security.pam.package;
  parentConfig = config;

  pamOpts = { config, name, ... }: let cfg = config; in let config = parentConfig; in {

    imports = [
      (lib.mkRenamedOptionModule [ "enableKwallet" ] [ "kwallet" "enable" ])
    ];

    options = {

      name = mkOption {
        example = "sshd";
        type = types.str;
        description = "Name of the PAM service.";
      };

      rules = mkOption {
        # This option is experimental and subject to breaking changes without notice.
        visible = false;

        description = ''
          PAM rules for this service.

          ::: {.warning}
          This option and its suboptions are experimental and subject to breaking changes without notice.

          If you use this option in your system configuration, you will need to manually monitor this module for any changes. Otherwise, failure to adjust your configuration properly could lead to you being locked out of your system, or worse, your system could be left wide open to attackers.

          If you share configuration examples that use this option, you MUST include this warning so that users are informed.

          You may freely use this option within `nixpkgs`, and future changes will account for those use sites.
          :::
        '';
        type = types.submodule {
          options = genAttrs [ "account" "auth" "password" "session" ] mkRulesTypeOption;
        };
      };

      unixAuth = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Whether users can log in with passwords defined in
          {file}`/etc/shadow`.
        '';
      };

      rootOK = mkOption {
        default = false;
        type = types.bool;
        description = ''
          If set, root doesn't need to authenticate (e.g. for the
          {command}`useradd` service).
        '';
      };

      p11Auth = mkOption {
        default = config.security.pam.p11.enable;
        defaultText = literalExpression "config.security.pam.p11.enable";
        type = types.bool;
        description = ''
          If set, keys listed in
          {file}`~/.ssh/authorized_keys` and
          {file}`~/.eid/authorized_certificates`
          can be used to log in with the associated PKCS#11 tokens.
        '';
      };

      u2fAuth = mkOption {
        default = config.security.pam.u2f.enable;
        defaultText = literalExpression "config.security.pam.u2f.enable";
        type = types.bool;
        description = ''
          If set, users listed in
          {file}`$XDG_CONFIG_HOME/Yubico/u2f_keys` (or
          {file}`$HOME/.config/Yubico/u2f_keys` if XDG variable is
          not set) are able to log in with the associated U2F key. Path can be
          changed using {option}`security.pam.u2f.authFile` option.
        '';
      };

      usshAuth = mkOption {
        default = false;
        type = types.bool;
        description = ''
          If set, users with an SSH certificate containing an authorized principal
          in their SSH agent are able to log in. Specific options are controlled
          using the {option}`security.pam.ussh` options.

          Note that the  {option}`security.pam.ussh.enable` must also be
          set for this option to take effect.
        '';
      };

      yubicoAuth = mkOption {
        default = config.security.pam.yubico.enable;
        defaultText = literalExpression "config.security.pam.yubico.enable";
        type = types.bool;
        description = ''
          If set, users listed in
          {file}`~/.yubico/authorized_yubikeys`
          are able to log in with the associated Yubikey tokens.
        '';
      };

      googleAuthenticator = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = ''
            If set, users with enabled Google Authenticator (created
            {file}`~/.google_authenticator`) will be required
            to provide Google Authenticator token to log in.
          '';
        };
      };

      otpwAuth = mkOption {
        default = config.security.pam.enableOTPW;
        defaultText = literalExpression "config.security.pam.enableOTPW";
        type = types.bool;
        description = ''
          If set, the OTPW system will be used (if
          {file}`~/.otpw` exists).
        '';
      };

      googleOsLoginAccountVerification = mkOption {
        default = false;
        type = types.bool;
        description = ''
          If set, will use the Google OS Login PAM modules
          (`pam_oslogin_login`,
          `pam_oslogin_admin`) to verify possible OS Login
          users and set sudoers configuration accordingly.
          This only makes sense to enable for the `sshd` PAM
          service.
        '';
      };

      googleOsLoginAuthentication = mkOption {
        default = false;
        type = types.bool;
        description = ''
          If set, will use the `pam_oslogin_login`'s user
          authentication methods to authenticate users using 2FA.
          This only makes sense to enable for the `sshd` PAM
          service.
        '';
      };

      mysqlAuth = mkOption {
        default = config.users.mysql.enable;
        defaultText = literalExpression "config.users.mysql.enable";
        type = types.bool;
        description = ''
          If set, the `pam_mysql` module will be used to
          authenticate users against a MySQL/MariaDB database.
        '';
      };

      fprintAuth = mkOption {
        default = config.services.fprintd.enable;
        defaultText = literalExpression "config.services.fprintd.enable";
        type = types.bool;
        description = ''
          If set, fingerprint reader will be used (if exists and
          your fingerprints are enrolled).
        '';
      };

      oathAuth = mkOption {
        default = config.security.pam.oath.enable;
        defaultText = literalExpression "config.security.pam.oath.enable";
        type = types.bool;
        description = ''
          If set, the OATH Toolkit will be used.
        '';
      };

      sshAgentAuth = mkOption {
        default = false;
        type = types.bool;
        description = ''
          If set, the calling user's SSH agent is used to authenticate
          against the keys in the calling user's
          {file}`~/.ssh/authorized_keys`.  This is useful
          for {command}`sudo` on password-less remote systems.
        '';
      };

      duoSecurity = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = ''
            If set, use the Duo Security pam module
            `pam_duo` for authentication.  Requires
            configuration of {option}`security.duosec` options.
          '';
        };
      };

      startSession = mkOption {
        default = false;
        type = types.bool;
        description = ''
          If set, the service will register a new session with
          systemd's login manager.  For local sessions, this will give
          the user access to audio devices, CD-ROM drives.  In the
          default PolicyKit configuration, it also allows the user to
          reboot the system.
        '';
      };

      setEnvironment = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether the service should set the environment variables
          listed in {option}`environment.sessionVariables`
          using `pam_env.so`.
        '';
      };

      setLoginUid = mkOption {
        type = types.bool;
        description = ''
          Set the login uid of the process
          ({file}`/proc/self/loginuid`) for auditing
          purposes.  The login uid is only set by ‘entry points’ like
          {command}`login` and {command}`sshd`, not by
          commands like {command}`sudo`.
        '';
      };

      ttyAudit = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable or disable TTY auditing for specified users
          '';
        };

        enablePattern = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            For each user matching one of comma-separated
            glob patterns, enable TTY auditing
          '';
        };

        disablePattern = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            For each user matching one of comma-separated
            glob patterns, disable TTY auditing
          '';
        };

        openOnly = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Set the TTY audit flag when opening the session,
            but do not restore it when closing the session.
            Using this option is necessary for some services
            that don't fork() to run the authenticated session,
            such as sudo.
          '';
        };
      };

      forwardXAuth = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether X authentication keys should be passed from the
          calling user to the target user (e.g. for
          {command}`su`)
        '';
      };

      pamMount = mkOption {
        default = config.security.pam.mount.enable;
        defaultText = literalExpression "config.security.pam.mount.enable";
        type = types.bool;
        description = ''
          Enable PAM mount (pam_mount) system to mount filesystems on user login.
        '';
      };

      allowNullPassword = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to allow logging into accounts that have no password
          set (i.e., have an empty password field in
          {file}`/etc/passwd` or
          {file}`/etc/group`).  This does not enable
          logging into disabled accounts (i.e., that have the password
          field set to `!`).  Note that regardless of
          what the pam_unix documentation says, accounts with hashed
          empty passwords are always allowed to log in.
        '';
      };

      nodelay = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether the delay after typing a wrong password should be disabled.
        '';
      };

      requireWheel = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to permit root access only to members of group wheel.
        '';
      };

      limits = mkOption {
        default = [];
        type = limitsType;
        description = ''
          Attribute set describing resource limits.  Defaults to the
          value of {option}`security.pam.loginLimits`.
          The meaning of the values is explained in {manpage}`limits.conf(5)`.
        '';
      };

      showMotd = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to show the message of the day.";
      };

      makeHomeDir = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to try to create home directories for users
          with `$HOME`s pointing to nonexistent
          locations on session login.
        '';
      };

      updateWtmp = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to update {file}`/var/log/wtmp`.";
      };

      logFailures = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to log authentication failures in {file}`/var/log/faillog`.";
      };

      enableAppArmor = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable support for attaching AppArmor profiles at the
          user/group level, e.g., as part of a role based access
          control scheme.
        '';
      };

      kwallet = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = ''
            If enabled, pam_wallet will attempt to automatically unlock the
            user's default KDE wallet upon login. If the user has no wallet named
            "kdewallet", or the login password does not match their wallet
            password, KDE will prompt separately after login.
          '';
        };

        package = mkPackageOption pkgs.plasma5Packages "kwallet-pam" {
          pkgsText = "pkgs.plasma5Packages";
        };

        forceRun = mkEnableOption null // {
          description = ''
            The `force_run` option is used to tell the PAM module for KWallet
            to forcefully run even if no graphical session (such as a GUI
            display manager) is detected. This is useful for when you are
            starting an X Session or a Wayland Session from a TTY. If you
            intend to log-in from a TTY, it is recommended that you enable
            this option **and** ensure that `plasma-kwallet-pam.service` is
            started by `graphical-session.target`.
          '';
        };
      };

      sssdStrictAccess = mkOption {
        default = false;
        type = types.bool;
        description = "enforce sssd access control";
      };

      enableGnomeKeyring = mkOption {
        default = false;
        type = types.bool;
        description = ''
          If enabled, pam_gnome_keyring will attempt to automatically unlock the
          user's default Gnome keyring upon login. If the user login password does
          not match their keyring password, Gnome Keyring will prompt separately
          after login.
        '';
      };

      failDelay = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If enabled, this will replace the `FAIL_DELAY` setting from `login.defs`.
            Change the delay on failure per-application.
            '';
        };

        delay = mkOption {
          default = 3000000;
          type = types.int;
          example = 1000000;
          description = "The delay time (in microseconds) on failure.";
        };
      };

      gnupg = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If enabled, pam_gnupg will attempt to automatically unlock the
            user's GPG keys with the login password via
            {command}`gpg-agent`. The keygrips of all keys to be
            unlocked should be written to {file}`~/.pam-gnupg`,
            and can be queried with {command}`gpg -K --with-keygrip`.
            Presetting passphrases must be enabled by adding
            `allow-preset-passphrase` in
            {file}`~/.gnupg/gpg-agent.conf`.
          '';
        };

        noAutostart = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Don't start {command}`gpg-agent` if it is not running.
            Useful in conjunction with starting {command}`gpg-agent` as
            a systemd user service.
          '';
        };

        storeOnly = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Don't send the password immediately after login, but store for PAM
            `session`.
          '';
        };
      };

      zfs = mkOption {
        default = config.security.pam.zfs.enable;
        defaultText = literalExpression "config.security.pam.zfs.enable";
        type = types.bool;
        description = ''
          Enable unlocking and mounting of encrypted ZFS home dataset at login.
        '';
      };

      text = mkOption {
        type = types.nullOr types.lines;
        description = "Contents of the PAM service file.";
      };

    };

    # The resulting /etc/pam.d/* file contents are verified in
    # nixos/tests/pam/pam-file-contents.nix. Please update tests there when
    # changing the derivation.
    config = {
      name = mkDefault name;
      setLoginUid = mkDefault cfg.startSession;
      limits = mkDefault config.security.pam.loginLimits;

      text = let
        ensureUniqueOrder = type: rules:
          let
            checkPair = a: b: assert assertMsg (a.order != b.order) "security.pam.services.${name}.rules.${type}: rules '${a.name}' and '${b.name}' cannot have the same order value (${toString a.order})"; b;
            checked = zipListsWith checkPair rules (drop 1 rules);
          in take 1 rules ++ checked;
        # Formats a string for use in `module-arguments`. See `man pam.conf`.
        formatModuleArgument = token:
          if hasInfix " " token
          then "[${replaceStrings ["]"] ["\\]"] token}]"
          else token;
        formatRules = type: pipe cfg.rules.${type} [
          attrValues
          (filter (rule: rule.enable))
          (sort (a: b: a.order < b.order))
          (ensureUniqueOrder type)
          (map (rule: concatStringsSep " " (
            [ type rule.control rule.modulePath ]
            ++ map formatModuleArgument rule.args
            ++ [ "# ${rule.name} (order ${toString rule.order})" ]
          )))
          (concatStringsSep "\n")
        ];
      in mkDefault ''
        # Account management.
        ${formatRules "account"}

        # Authentication management.
        ${formatRules "auth"}

        # Password management.
        ${formatRules "password"}

        # Session management.
        ${formatRules "session"}
      '';

      # !!! TODO: move the LDAP stuff to the LDAP module, and the
      # Samba stuff to the Samba module.  This requires that the PAM
      # module provides the right hooks.
      rules = let
        autoOrderRules = flip pipe [
          (imap1 (index: rule: rule // { order = mkDefault (10000 + index * 100); } ))
          (map (rule: nameValuePair rule.name (removeAttrs rule [ "name" ])))
          listToAttrs
        ];
      in {
        account = autoOrderRules [
          { name = "ldap"; enable = use_ldap; control = "sufficient"; modulePath = "${pam_ldap}/lib/security/pam_ldap.so"; }
          { name = "mysql"; enable = cfg.mysqlAuth; control = "sufficient"; modulePath = "${pkgs.pam_mysql}/lib/security/pam_mysql.so"; settings = {
            config_file = "/etc/security/pam_mysql.conf";
          }; }
          { name = "kanidm"; enable = config.services.kanidm.enablePam; control = "sufficient"; modulePath = "${config.services.kanidm.package}/lib/pam_kanidm.so"; settings = {
            ignore_unknown_user = true;
          }; }
          { name = "sss"; enable = config.services.sssd.enable; control = if cfg.sssdStrictAccess then "[default=bad success=ok user_unknown=ignore]" else "sufficient"; modulePath = "${pkgs.sssd}/lib/security/pam_sss.so"; }
          { name = "krb5"; enable = config.security.pam.krb5.enable; control = "sufficient"; modulePath = "${pam_krb5}/lib/security/pam_krb5.so"; }
          { name = "oslogin_login"; enable = cfg.googleOsLoginAccountVerification; control = "[success=ok ignore=ignore default=die]"; modulePath = "${pkgs.google-guest-oslogin}/lib/security/pam_oslogin_login.so"; }
          { name = "oslogin_admin"; enable = cfg.googleOsLoginAccountVerification; control = "[success=ok default=ignore]"; modulePath = "${pkgs.google-guest-oslogin}/lib/security/pam_oslogin_admin.so"; }
          { name = "systemd_home"; enable = config.services.homed.enable; control = "sufficient"; modulePath = "${config.systemd.package}/lib/security/pam_systemd_home.so"; }
          # The required pam_unix.so module has to come after all the sufficient modules
          # because otherwise, the account lookup will fail if the user does not exist
          # locally, for example with MySQL- or LDAP-auth.
          { name = "unix"; control = "required"; modulePath = "${package}/lib/security/pam_unix.so"; }
        ];

        auth = autoOrderRules ([
          { name = "oslogin_login"; enable = cfg.googleOsLoginAuthentication; control = "[success=done perm_denied=die default=ignore]"; modulePath = "${pkgs.google-guest-oslogin}/lib/security/pam_oslogin_login.so"; }
          { name = "rootok"; enable = cfg.rootOK; control = "sufficient"; modulePath = "${package}/lib/security/pam_rootok.so"; }
          { name = "wheel"; enable = cfg.requireWheel; control = "required"; modulePath = "${package}/lib/security/pam_wheel.so"; settings = {
            use_uid = true;
          }; }
          { name = "faillock"; enable = cfg.logFailures; control = "required"; modulePath = "${package}/lib/security/pam_faillock.so"; }
          { name = "mysql"; enable = cfg.mysqlAuth; control = "sufficient"; modulePath = "${pkgs.pam_mysql}/lib/security/pam_mysql.so"; settings = {
            config_file = "/etc/security/pam_mysql.conf";
          }; }
          { name = "ssh_agent_auth"; enable = config.security.pam.sshAgentAuth.enable && cfg.sshAgentAuth; control = "sufficient"; modulePath = "${pkgs.pam_ssh_agent_auth}/libexec/pam_ssh_agent_auth.so"; settings = {
            file = lib.concatStringsSep ":" config.security.pam.sshAgentAuth.authorizedKeysFiles;
          }; }
          (let p11 = config.security.pam.p11; in { name = "p11"; enable = cfg.p11Auth; control = p11.control; modulePath = "${pkgs.pam_p11}/lib/security/pam_p11.so"; args = [
            "${pkgs.opensc}/lib/opensc-pkcs11.so"
          ]; })
          (let u2f = config.security.pam.u2f; in { name = "u2f"; enable = cfg.u2fAuth; control = u2f.control; modulePath = "${pkgs.pam_u2f}/lib/security/pam_u2f.so"; inherit (u2f) settings; })
          (let ussh = config.security.pam.ussh; in { name = "ussh"; enable = config.security.pam.ussh.enable && cfg.usshAuth; control = ussh.control; modulePath = "${pkgs.pam_ussh}/lib/security/pam_ussh.so"; settings = {
            ca_file = ussh.caFile;
            authorized_principals = ussh.authorizedPrincipals;
            authorized_principals_file = ussh.authorizedPrincipalsFile;
            inherit (ussh) group;
          }; })
          (let oath = config.security.pam.oath; in { name = "oath"; enable = cfg.oathAuth; control = "requisite"; modulePath = "${pkgs.oath-toolkit}/lib/security/pam_oath.so"; settings = {
            inherit (oath) window digits;
            usersfile = oath.usersFile;
          }; })
          (let yubi = config.security.pam.yubico; in { name = "yubico"; enable = cfg.yubicoAuth; control = yubi.control; modulePath = "${pkgs.yubico-pam}/lib/security/pam_yubico.so"; settings = {
            inherit (yubi) mode debug;
            chalresp_path = yubi.challengeResponsePath;
            id = mkIf (yubi.mode == "client") yubi.id;
          }; })
          (let dp9ik = config.security.pam.dp9ik; in { name = "p9"; enable = dp9ik.enable; control = dp9ik.control; modulePath = "${pkgs.pam_dp9ik}/lib/security/pam_p9.so"; args = [
            dp9ik.authserver
          ]; })
          { name = "fprintd"; enable = cfg.fprintAuth; control = "sufficient"; modulePath = "${config.services.fprintd.package}/lib/security/pam_fprintd.so"; }
        ] ++
          # Modules in this block require having the password set in PAM_AUTHTOK.
          # pam_unix is marked as 'sufficient' on NixOS which means nothing will run
          # after it succeeds. Certain modules need to run after pam_unix
          # prompts the user for password so we run it once with 'optional' at an
          # earlier point and it will run again with 'sufficient' further down.
          # We use try_first_pass the second time to avoid prompting password twice.
          #
          # The same principle applies to systemd-homed
          (optionals ((cfg.unixAuth || config.services.homed.enable) &&
            (config.security.pam.enableEcryptfs
              || config.security.pam.enableFscrypt
              || cfg.pamMount
              || cfg.kwallet.enable
              || cfg.enableGnomeKeyring
              || config.services.intune.enable
              || cfg.googleAuthenticator.enable
              || cfg.gnupg.enable
              || cfg.failDelay.enable
              || cfg.duoSecurity.enable
              || cfg.zfs))
            [
              { name = "systemd_home-early"; enable = config.services.homed.enable; control = "optional"; modulePath = "${config.systemd.package}/lib/security/pam_systemd_home.so"; }
              { name = "unix-early"; enable = cfg.unixAuth; control = "optional"; modulePath = "${package}/lib/security/pam_unix.so"; settings = {
                nullok = cfg.allowNullPassword;
                inherit (cfg) nodelay;
                likeauth = true;
              }; }
              { name = "ecryptfs"; enable = config.security.pam.enableEcryptfs; control = "optional"; modulePath = "${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so"; settings = {
                unwrap = true;
              }; }
              { name = "fscrypt"; enable = config.security.pam.enableFscrypt; control = "optional"; modulePath = "${pkgs.fscrypt-experimental}/lib/security/pam_fscrypt.so"; }
              { name = "zfs_key"; enable = cfg.zfs; control = "optional"; modulePath = "${config.boot.zfs.package}/lib/security/pam_zfs_key.so"; settings = {
                inherit (config.security.pam.zfs) homes;
              }; }
              { name = "mount"; enable = cfg.pamMount; control = "optional"; modulePath = "${pkgs.pam_mount}/lib/security/pam_mount.so"; settings = {
                disable_interactive = true;
              }; }
              { name = "kwallet"; enable = cfg.kwallet.enable; control = "optional"; modulePath = "${cfg.kwallet.package}/lib/security/pam_kwallet5.so"; }
              { name = "gnome_keyring"; enable = cfg.enableGnomeKeyring; control = "optional"; modulePath = "${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so"; }
              { name = "intune"; enable = config.services.intune.enable; control = "optional"; modulePath = "${pkgs.intune-portal}/lib/security/pam_intune.so"; }
              { name = "gnupg"; enable = cfg.gnupg.enable; control = "optional"; modulePath = "${pkgs.pam_gnupg}/lib/security/pam_gnupg.so"; settings = {
                store-only = cfg.gnupg.storeOnly;
              }; }
              { name = "faildelay"; enable = cfg.failDelay.enable; control = "optional"; modulePath = "${package}/lib/security/pam_faildelay.so"; settings = {
                inherit (cfg.failDelay) delay;
              }; }
              { name = "google_authenticator"; enable = cfg.googleAuthenticator.enable; control = "required"; modulePath = "${pkgs.google-authenticator}/lib/security/pam_google_authenticator.so"; settings = {
                no_increment_hotp = true;
              }; }
              { name = "duo"; enable = cfg.duoSecurity.enable; control = "required"; modulePath = "${pkgs.duo-unix}/lib/security/pam_duo.so"; }
            ]) ++ [
          { name = "systemd_home"; enable = config.services.homed.enable; control = "sufficient"; modulePath = "${config.systemd.package}/lib/security/pam_systemd_home.so"; }
          { name = "unix"; enable = cfg.unixAuth; control = "sufficient"; modulePath = "${package}/lib/security/pam_unix.so"; settings = {
            nullok = cfg.allowNullPassword;
            inherit (cfg) nodelay;
            likeauth = true;
            try_first_pass = true;
          }; }
          { name = "otpw"; enable = cfg.otpwAuth; control = "sufficient"; modulePath = "${pkgs.otpw}/lib/security/pam_otpw.so"; }
          { name = "ldap"; enable = use_ldap; control = "sufficient"; modulePath = "${pam_ldap}/lib/security/pam_ldap.so"; settings = {
            use_first_pass = true;
          }; }
          { name = "kanidm"; enable = config.services.kanidm.enablePam; control = "sufficient"; modulePath = "${config.services.kanidm.package}/lib/pam_kanidm.so"; settings = {
            ignore_unknown_user = true;
            use_first_pass = true;
          }; }
          { name = "sss"; enable = config.services.sssd.enable; control = "sufficient"; modulePath = "${pkgs.sssd}/lib/security/pam_sss.so"; settings = {
            use_first_pass = true;
          }; }
          { name = "krb5"; enable = config.security.pam.krb5.enable; control = "[default=ignore success=1 service_err=reset]"; modulePath = "${pam_krb5}/lib/security/pam_krb5.so"; settings = {
            use_first_pass = true;
          }; }
          { name = "ccreds-validate"; enable = config.security.pam.krb5.enable; control = "[default=die success=done]"; modulePath = "${pam_ccreds}/lib/security/pam_ccreds.so"; settings = {
            action = "validate";
            use_first_pass = true;
          }; }
          { name = "ccreds-store"; enable = config.security.pam.krb5.enable; control = "sufficient"; modulePath = "${pam_ccreds}/lib/security/pam_ccreds.so"; settings = {
            action = "store";
            use_first_pass = true;
          }; }
          { name = "deny"; control = "required"; modulePath = "${package}/lib/security/pam_deny.so"; }
        ]);

        password = autoOrderRules [
          { name = "systemd_home"; enable = config.services.homed.enable; control = "sufficient"; modulePath = "${config.systemd.package}/lib/security/pam_systemd_home.so"; }
          { name = "unix"; control = "sufficient"; modulePath = "${package}/lib/security/pam_unix.so"; settings = {
            nullok = true;
            yescrypt = true;
          }; }
          { name = "ecryptfs"; enable = config.security.pam.enableEcryptfs; control = "optional"; modulePath = "${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so"; }
          { name = "fscrypt"; enable = config.security.pam.enableFscrypt; control = "optional"; modulePath = "${pkgs.fscrypt-experimental}/lib/security/pam_fscrypt.so"; }
          { name = "zfs_key"; enable = cfg.zfs; control = "optional"; modulePath = "${config.boot.zfs.package}/lib/security/pam_zfs_key.so"; settings = {
            inherit (config.security.pam.zfs) homes;
          }; }
          { name = "mount"; enable = cfg.pamMount; control = "optional"; modulePath = "${pkgs.pam_mount}/lib/security/pam_mount.so"; }
          { name = "ldap"; enable = use_ldap; control = "sufficient"; modulePath = "${pam_ldap}/lib/security/pam_ldap.so"; }
          { name = "mysql"; enable = cfg.mysqlAuth; control = "sufficient"; modulePath = "${pkgs.pam_mysql}/lib/security/pam_mysql.so"; settings = {
            config_file = "/etc/security/pam_mysql.conf";
          }; }
          { name = "kanidm"; enable = config.services.kanidm.enablePam; control = "sufficient"; modulePath = "${config.services.kanidm.package}/lib/pam_kanidm.so"; }
          { name = "sss"; enable = config.services.sssd.enable; control = "sufficient"; modulePath = "${pkgs.sssd}/lib/security/pam_sss.so"; }
          { name = "krb5"; enable = config.security.pam.krb5.enable; control = "sufficient"; modulePath = "${pam_krb5}/lib/security/pam_krb5.so"; settings = {
            use_first_pass = true;
          }; }
          { name = "gnome_keyring"; enable = cfg.enableGnomeKeyring; control = "optional"; modulePath = "${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so"; settings = {
            use_authtok = true;
          }; }
        ];

        session = autoOrderRules [
          { name = "env"; enable = cfg.setEnvironment; control = "required"; modulePath = "${package}/lib/security/pam_env.so"; settings = {
            conffile = "/etc/pam/environment";
            readenv = 0;
          }; }
          { name = "unix"; control = "required"; modulePath = "${package}/lib/security/pam_unix.so"; }
          { name = "loginuid"; enable = cfg.setLoginUid; control = if config.boot.isContainer then "optional" else "required"; modulePath = "${package}/lib/security/pam_loginuid.so"; }
          { name = "tty_audit"; enable = cfg.ttyAudit.enable; control = "required"; modulePath = "${package}/lib/security/pam_tty_audit.so"; settings = {
            open_only = cfg.ttyAudit.openOnly;
            enable = cfg.ttyAudit.enablePattern;
            disable = cfg.ttyAudit.disablePattern;
          }; }
          { name = "systemd_home"; enable = config.services.homed.enable; control = "required"; modulePath = "${config.systemd.package}/lib/security/pam_systemd_home.so"; }
          { name = "mkhomedir"; enable = cfg.makeHomeDir; control = "required"; modulePath = "${package}/lib/security/pam_mkhomedir.so"; settings = {
            silent = true;
            skel = config.security.pam.makeHomeDir.skelDirectory;
            inherit (config.security.pam.makeHomeDir) umask;
          }; }
          { name = "lastlog"; enable = cfg.updateWtmp; control = "required"; modulePath = "${package}/lib/security/pam_lastlog.so"; settings = {
            silent = true;
          }; }
          { name = "ecryptfs"; enable = config.security.pam.enableEcryptfs; control = "optional"; modulePath = "${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so"; }
          # Work around https://github.com/systemd/systemd/issues/8598
          # Skips the pam_fscrypt module for systemd-user sessions which do not have a password
          # anyways.
          # See also https://github.com/google/fscrypt/issues/95
          { name = "fscrypt-skip-systemd"; enable = config.security.pam.enableFscrypt; control = "[success=1 default=ignore]"; modulePath = "${package}/lib/security/pam_succeed_if.so"; args = [
            "service" "=" "systemd-user"
          ]; }
          { name = "fscrypt"; enable = config.security.pam.enableFscrypt; control = "optional"; modulePath = "${pkgs.fscrypt-experimental}/lib/security/pam_fscrypt.so"; }
          { name = "zfs_key-skip-systemd"; enable = cfg.zfs; control = "[success=1 default=ignore]"; modulePath = "${package}/lib/security/pam_succeed_if.so"; args = [
            "service" "=" "systemd-user"
          ]; }
          { name = "zfs_key"; enable = cfg.zfs; control = "optional"; modulePath = "${config.boot.zfs.package}/lib/security/pam_zfs_key.so"; settings = {
            inherit (config.security.pam.zfs) homes;
            nounmount = config.security.pam.zfs.noUnmount;
          }; }
          { name = "mount"; enable = cfg.pamMount; control = "optional"; modulePath = "${pkgs.pam_mount}/lib/security/pam_mount.so"; settings = {
            disable_interactive = true;
          }; }
          { name = "ldap"; enable = use_ldap; control = "optional"; modulePath = "${pam_ldap}/lib/security/pam_ldap.so"; }
          { name = "mysql"; enable = cfg.mysqlAuth; control = "optional"; modulePath = "${pkgs.pam_mysql}/lib/security/pam_mysql.so"; settings = {
            config_file = "/etc/security/pam_mysql.conf";
          }; }
          { name = "kanidm"; enable = config.services.kanidm.enablePam; control = "optional"; modulePath = "${config.services.kanidm.package}/lib/pam_kanidm.so"; }
          { name = "sss"; enable = config.services.sssd.enable; control = "optional"; modulePath = "${pkgs.sssd}/lib/security/pam_sss.so"; }
          { name = "krb5"; enable = config.security.pam.krb5.enable; control = "optional"; modulePath = "${pam_krb5}/lib/security/pam_krb5.so"; }
          { name = "otpw"; enable = cfg.otpwAuth; control = "optional"; modulePath = "${pkgs.otpw}/lib/security/pam_otpw.so"; }
          { name = "systemd"; enable = cfg.startSession; control = "optional"; modulePath = "${config.systemd.package}/lib/security/pam_systemd.so"; }
          { name = "xauth"; enable = cfg.forwardXAuth; control = "optional"; modulePath = "${package}/lib/security/pam_xauth.so"; settings = {
            xauthpath = "${pkgs.xorg.xauth}/bin/xauth";
            systemuser = 99;
          }; }
          { name = "limits"; enable = cfg.limits != []; control = "required"; modulePath = "${package}/lib/security/pam_limits.so"; settings = {
            conf = "${makeLimitsConf cfg.limits}";
          }; }
          { name = "motd"; enable = cfg.showMotd && (config.users.motd != "" || config.users.motdFile != null); control = "optional"; modulePath = "${package}/lib/security/pam_motd.so"; settings = {
            inherit motd;
          }; }
          { name = "apparmor"; enable = cfg.enableAppArmor && config.security.apparmor.enable; control = "optional"; modulePath = "${pkgs.apparmor-pam}/lib/security/pam_apparmor.so"; settings = {
            order = "user,group,default";
            debug = true;
          }; }
          { name = "kwallet"; enable = cfg.kwallet.enable; control = "optional"; modulePath = "${cfg.kwallet.package}/lib/security/pam_kwallet5.so"; settings = lib.mkIf cfg.kwallet.forceRun { force_run = true; }; }
          { name = "gnome_keyring"; enable = cfg.enableGnomeKeyring; control = "optional"; modulePath = "${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so"; settings = {
            auto_start = true;
          }; }
          { name = "gnupg"; enable = cfg.gnupg.enable; control = "optional"; modulePath = "${pkgs.pam_gnupg}/lib/security/pam_gnupg.so"; settings = {
            no-autostart = cfg.gnupg.noAutostart;
          }; }
          { name = "intune"; enable = config.services.intune.enable; control = "optional"; modulePath = "${pkgs.intune-portal}/lib/security/pam_intune.so"; }
        ];
      };
    };

  };


  inherit (pkgs) pam_krb5 pam_ccreds;

  use_ldap = (config.users.ldap.enable && config.users.ldap.loginPam);
  pam_ldap = if config.users.ldap.daemon.enable then pkgs.nss_pam_ldapd else pkgs.pam_ldap;

  # Create a limits.conf(5) file.
  makeLimitsConf = limits:
    pkgs.writeText "limits.conf"
       (concatMapStrings ({ domain, type, item, value }:
         "${domain} ${type} ${item} ${toString value}\n")
         limits);

  limitsType = with lib.types; listOf (submodule ({ ... }: {
    options = {
      domain = mkOption {
        description = "Username, groupname, or wildcard this limit applies to";
        example = "@wheel";
        type = str;
      };

      type = mkOption {
        description = "Type of this limit";
        type = enum [ "-" "hard" "soft" ];
        default = "-";
      };

      item = mkOption {
        description = "Item this limit applies to";
        type = enum [
          "core"
          "data"
          "fsize"
          "memlock"
          "nofile"
          "rss"
          "stack"
          "cpu"
          "nproc"
          "as"
          "maxlogins"
          "maxsyslogins"
          "priority"
          "locks"
          "sigpending"
          "msgqueue"
          "nice"
          "rtprio"
        ];
      };

      value = mkOption {
        description = "Value of this limit";
        type = oneOf [ str int ];
      };
    };
  }));

  motd = if config.users.motdFile == null
         then pkgs.writeText "motd" config.users.motd
         else config.users.motdFile;

  makePAMService = name: service:
    { name = "pam.d/${name}";
      value.source = pkgs.writeText "${name}.pam" service.text;
    };

  optionalSudoConfigForSSHAgentAuth = optionalString config.security.pam.sshAgentAuth.enable ''
    # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
    Defaults env_keep+=SSH_AUTH_SOCK
  '';

in

{

  meta.maintainers = [ maintainers.majiir ];

  imports = [
    (mkRenamedOptionModule [ "security" "pam" "enableU2F" ] [ "security" "pam" "u2f" "enable" ])
    (mkRenamedOptionModule [ "security" "pam" "enableSSHAgentAuth" ] [ "security" "pam" "sshAgentAuth" "enable" ])
    (mkRenamedOptionModule [ "security" "pam" "u2f" "authFile" ] [ "security" "pam" "u2f" "settings" "authfile" ])
    (mkRenamedOptionModule [ "security" "pam" "u2f" "appId" ] [ "security" "pam" "u2f" "settings" "appid" ])
    (mkRenamedOptionModule [ "security" "pam" "u2f" "origin" ] [ "security" "pam" "u2f" "settings" "origin" ])
    (mkRenamedOptionModule [ "security" "pam" "u2f" "debug" ] [ "security" "pam" "u2f" "settings" "debug" ])
    (mkRenamedOptionModule [ "security" "pam" "u2f" "interactive" ] [ "security" "pam" "u2f" "settings" "interactive" ])
    (mkRenamedOptionModule [ "security" "pam" "u2f" "cue" ] [ "security" "pam" "u2f" "settings" "cue" ])
  ];

  ###### interface

  options = {

    security.pam.package = mkPackageOption pkgs "pam" { };

    security.pam.loginLimits = mkOption {
      default = [];
      type = limitsType;
      example =
        [ { domain = "ftp";
            type   = "hard";
            item   = "nproc";
            value  = "0";
          }
          { domain = "@student";
            type   = "-";
            item   = "maxlogins";
            value  = "4";
          }
       ];

     description = ''
       Define resource limits that should apply to users or groups.
       Each item in the list should be an attribute set with a
       {var}`domain`, {var}`type`,
       {var}`item`, and {var}`value`
       attribute.  The syntax and semantics of these attributes
       must be that described in {manpage}`limits.conf(5)`.

       Note that these limits do not apply to systemd services,
       whose limits can be changed via {option}`systemd.extraConfig`
       instead.
     '';
    };

    security.pam.services = mkOption {
      default = {};
      type = with types; attrsOf (submodule pamOpts);
      description = ''
          This option defines the PAM services.  A service typically
          corresponds to a program that uses PAM,
          e.g. {command}`login` or {command}`passwd`.
          Each attribute of this set defines a PAM service, with the attribute name
          defining the name of the service.
        '';
    };

    security.pam.makeHomeDir.skelDirectory = mkOption {
      type = types.str;
      default = "/var/empty";
      example =  "/etc/skel";
      description = ''
        Path to skeleton directory whose contents are copied to home
        directories newly created by `pam_mkhomedir`.
      '';
    };

    security.pam.makeHomeDir.umask = mkOption {
      type = types.str;
      default = "0077";
      example = "0022";
      description = ''
        The user file mode creation mask to use on home directories
        newly created by `pam_mkhomedir`.
      '';
    };

    security.pam.sshAgentAuth = {
      enable = mkEnableOption ''
        authenticating using a signature performed by the ssh-agent.
        This allows using SSH keys exclusively, instead of passwords, for instance on remote machines
      '';

      authorizedKeysFiles = mkOption {
        type = with types; listOf str;
        description = ''
          A list of paths to files in OpenSSH's `authorized_keys` format, containing
          the keys that will be trusted by the `pam_ssh_agent_auth` module.

          The following patterns are expanded when interpreting the path:
          - `%f` and `%H` respectively expand to the fully-qualified and short hostname ;
          - `%u` expands to the username ;
          - `~` or `%h` expands to the user's home directory.

          ::: {.note}
          Specifying user-writeable files here result in an insecure configuration:  a malicious process
          can then edit such an authorized_keys file and bypass the ssh-agent-based authentication.

          See [issue #31611](https://github.com/NixOS/nixpkgs/issues/31611)
          :::
        '';
        default = [ "/etc/ssh/authorized_keys.d/%u" ];
      };
    };

    security.pam.enableOTPW = mkEnableOption "the OTPW (one-time password) PAM module";

    security.pam.dp9ik = {
      enable = mkEnableOption ''
          the dp9ik pam module provided by tlsclient.

          If set, users can be authenticated against the 9front
          authentication server given in {option}`security.pam.dp9ik.authserver`
        '';
      control = mkOption {
        default = "sufficient";
        type = types.str;
        description = ''
          This option sets the pam "control" used for this module.
        '';
      };
      authserver = mkOption {
        default = null;
        type = with types; nullOr str;
        description = ''
          This controls the hostname for the 9front authentication server
          that users will be authenticated against.
        '';
      };
    };

    security.pam.krb5 = {
      enable = mkOption {
        default = config.security.krb5.enable;
        defaultText = literalExpression "config.security.krb5.enable";
        type = types.bool;
        description = ''
          Enables Kerberos PAM modules (`pam-krb5`,
          `pam-ccreds`).

          If set, users can authenticate with their Kerberos password.
          This requires a valid Kerberos configuration
          (`config.security.krb5.enable` should be set to
          `true`).

          Note that the Kerberos PAM modules are not necessary when using SSS
          to handle Kerberos authentication.
        '';
      };
    };

    security.pam.p11 = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enables P11 PAM (`pam_p11`) module.

          If set, users can log in with SSH keys and PKCS#11 tokens.

          More information can be found [here](https://github.com/OpenSC/pam_p11).
        '';
      };

      control = mkOption {
        default = "sufficient";
        type = types.enum [ "required" "requisite" "sufficient" "optional" ];
        description = ''
          This option sets pam "control".
          If you want to have multi factor authentication, use "required".
          If you want to use the PKCS#11 device instead of the regular password,
          use "sufficient".

          Read
          {manpage}`pam.conf(5)`
          for better understanding of this option.
        '';
      };
    };

    security.pam.u2f = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enables U2F PAM (`pam-u2f`) module.

          If set, users listed in
          {file}`$XDG_CONFIG_HOME/Yubico/u2f_keys` (or
          {file}`$HOME/.config/Yubico/u2f_keys` if XDG variable is
          not set) are able to log in with the associated U2F key. The path can
          be changed using {option}`security.pam.u2f.authFile` option.

          File format is:
          `username:first_keyHandle,first_public_key: second_keyHandle,second_public_key`
          This file can be generated using {command}`pamu2fcfg` command.

          More information can be found [here](https://developers.yubico.com/pam-u2f/).
        '';
      };

      control = mkOption {
        default = "sufficient";
        type = types.enum [ "required" "requisite" "sufficient" "optional" ];
        description = ''
          This option sets pam "control".
          If you want to have multi factor authentication, use "required".
          If you want to use U2F device instead of regular password, use "sufficient".

          Read
          {manpage}`pam.conf(5)`
          for better understanding of this option.
        '';
      };

      settings = mkOption {
        type = types.submodule {
          freeformType = moduleSettingsType;

          options = {
            authfile = mkOption {
              default = null;
              type = with types; nullOr path;
              description = ''
                By default `pam-u2f` module reads the keys from
                {file}`$XDG_CONFIG_HOME/Yubico/u2f_keys` (or
                {file}`$HOME/.config/Yubico/u2f_keys` if XDG variable is
                not set).

                If you want to change auth file locations or centralize database (for
                example use {file}`/etc/u2f-mappings`) you can set this
                option.

                File format is:
                `username:first_keyHandle,first_public_key: second_keyHandle,second_public_key`
                This file can be generated using {command}`pamu2fcfg` command.

                More information can be found [here](https://developers.yubico.com/pam-u2f/).
              '';
            };

            appid = mkOption {
              default = null;
              type = with types; nullOr str;
              description = ''
                  By default `pam-u2f` module sets the application
                  ID to `pam://$HOSTNAME`.

                  When using {command}`pamu2fcfg`, you can specify your
                  application ID with the `-i` flag.

                  More information can be found [here](https://developers.yubico.com/pam-u2f/Manuals/pam_u2f.8.html)
              '';
            };

            origin = mkOption {
              default = null;
              type = with types; nullOr str;
              description = ''
                  By default `pam-u2f` module sets the origin
                  to `pam://$HOSTNAME`.
                  Setting origin to an host independent value will allow you to
                  reuse credentials across machines

                  When using {command}`pamu2fcfg`, you can specify your
                  application ID with the `-o` flag.

                  More information can be found [here](https://developers.yubico.com/pam-u2f/Manuals/pam_u2f.8.html)
              '';
            };

            debug = mkOption {
              default = false;
              type = types.bool;
              description = ''
                Debug output to stderr.
              '';
            };

            interactive = mkOption {
              default = false;
              type = types.bool;
              description = ''
                Set to prompt a message and wait before testing the presence of a U2F device.
                Recommended if your device doesn’t have a tactile trigger.
              '';
            };

            cue = mkOption {
              default = false;
              type = types.bool;
              description = ''
                By default `pam-u2f` module does not inform user
                that he needs to use the u2f device, it just waits without a prompt.

                If you set this option to `true`,
                `cue` option is added to `pam-u2f`
                module and reminder message will be displayed.
              '';
            };
          };
        };
        default = { };
        example = {
          authfile = "/etc/u2f_keys";
          authpending_file = "";
          userpresence = 0;
          pinverification = 1;
        };
        description = ''
          Options to pass to the PAM module.

          ${moduleSettingsDescription}
        '';
      };
    };

    security.pam.ussh = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enables Uber's USSH PAM (`pam-ussh`) module.

          This is similar to `pam-ssh-agent`, except that
          the presence of a CA-signed SSH key with a valid principal is checked
          instead.

          Note that this module must both be enabled using this option and on a
          per-PAM-service level as well (using `usshAuth`).

          More information can be found [here](https://github.com/uber/pam-ussh).
        '';
      };

      caFile = mkOption {
        default = null;
        type = with types; nullOr path;
        description = ''
          By default `pam-ussh` reads the trusted user CA keys
          from {file}`/etc/ssh/trusted_user_ca`.

          This should be set the same as your `TrustedUserCAKeys`
          option for sshd.
        '';
      };

      authorizedPrincipals = mkOption {
        default = null;
        type = with types; nullOr commas;
        description = ''
          Comma-separated list of authorized principals to permit; if the user
          presents a certificate with one of these principals, then they will be
          authorized.

          Note that `pam-ussh` also requires that the certificate
          contain a principal matching the user's username. The principals from
          this list are in addition to those principals.

          Mutually exclusive with `authorizedPrincipalsFile`.
        '';
      };

      authorizedPrincipalsFile = mkOption {
        default = null;
        type = with types; nullOr path;
        description = ''
          Path to a list of principals; if the user presents a certificate with
          one of these principals, then they will be authorized.

          Note that `pam-ussh` also requires that the certificate
          contain a principal matching the user's username. The principals from
          this file are in addition to those principals.

          Mutually exclusive with `authorizedPrincipals`.
        '';
      };

      group = mkOption {
        default = null;
        type = with types; nullOr str;
        description = ''
          If set, then the authenticating user must be a member of this group
          to use this module.
        '';
      };

      control = mkOption {
        default = "sufficient";
        type = types.enum [ "required" "requisite" "sufficient" "optional" ];
        description = ''
          This option sets pam "control".
          If you want to have multi factor authentication, use "required".
          If you want to use the SSH certificate instead of the regular password,
          use "sufficient".

          Read
          {manpage}`pam.conf(5)`
          for better understanding of this option.
        '';
      };
    };

    security.pam.yubico = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enables Yubico PAM (`yubico-pam`) module.

          If set, users listed in
          {file}`~/.yubico/authorized_yubikeys`
          are able to log in with the associated Yubikey tokens.

          The file must have only one line:
          `username:yubikey_token_id1:yubikey_token_id2`
          More information can be found [here](https://developers.yubico.com/yubico-pam/).
        '';
      };
      control = mkOption {
        default = "sufficient";
        type = types.enum [ "required" "requisite" "sufficient" "optional" ];
        description = ''
          This option sets pam "control".
          If you want to have multi factor authentication, use "required".
          If you want to use Yubikey instead of regular password, use "sufficient".

          Read
          {manpage}`pam.conf(5)`
          for better understanding of this option.
        '';
      };
      id = mkOption {
        example = "42";
        type = types.str;
        description = "client id";
      };

      debug = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Debug output to stderr.
        '';
      };
      mode = mkOption {
        default = "client";
        type = types.enum [ "client" "challenge-response" ];
        description = ''
          Mode of operation.

          Use "client" for online validation with a YubiKey validation service such as
          the YubiCloud.

          Use "challenge-response" for offline validation using YubiKeys with HMAC-SHA-1
          Challenge-Response configurations. See the man-page ykpamcfg(1) for further
          details on how to configure offline Challenge-Response validation.

          More information can be found [here](https://developers.yubico.com/yubico-pam/Authentication_Using_Challenge-Response.html).
        '';
      };
      challengeResponsePath = mkOption {
        default = null;
        type = types.nullOr types.path;
        description = ''
          If not null, set the path used by yubico pam module where the challenge expected response is stored.

          More information can be found [here](https://developers.yubico.com/yubico-pam/Authentication_Using_Challenge-Response.html).
        '';
      };
    };

    security.pam.zfs = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable unlocking and mounting of encrypted ZFS home dataset at login.
        '';
      };

      homes = mkOption {
        example = "rpool/home";
        default = "rpool/home";
        type = types.str;
        description = ''
          Prefix of home datasets. This value will be concatenated with
          `"/" + <username>` in order to determine the home dataset to unlock.
        '';
      };

      noUnmount = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Do not unmount home dataset on logout.
        '';
      };
    };

    security.pam.enableEcryptfs = mkEnableOption "eCryptfs PAM module (mounting ecryptfs home directory on login)";
    security.pam.enableFscrypt = mkEnableOption ''
      fscrypt, to automatically unlock directories with the user's login password.

      This also enables a service at security.pam.services.fscrypt which is used by
      fscrypt to verify the user's password when setting up a new protector. If you
      use something other than pam_unix to verify user passwords, please remember to
      adjust this PAM service
    '';

    users.motd = mkOption {
      default = "";
      example = "Today is Sweetmorn, the 4th day of The Aftermath in the YOLD 3178.";
      type = types.lines;
      description = "Message of the day shown to users when they log in.";
    };

    users.motdFile = mkOption {
      default = null;
      example = "/etc/motd";
      type = types.nullOr types.path;
      description = "A file containing the message of the day shown to users when they log in.";
    };
  };


  ###### implementation

  config = {
    assertions = [
      {
        assertion = config.users.motd == "" || config.users.motdFile == null;
        message = ''
          Only one of users.motd and users.motdFile can be set.
        '';
      }
      {
        assertion = config.security.pam.zfs.enable -> config.boot.zfs.enabled;
        message = ''
          `security.pam.zfs.enable` requires enabling ZFS (`boot.zfs.enabled`).
        '';
      }
      {
        assertion = with config.security.pam.sshAgentAuth; enable -> authorizedKeysFiles != [];
        message = ''
          `security.pam.enableSSHAgentAuth` requires `services.openssh.authorizedKeysFiles` to be a non-empty list.
          Did you forget to set `services.openssh.enable` ?
        '';
      }
    ];

    warnings = optional
      (with lib; with config.security.pam.sshAgentAuth;
        enable && any (s: hasPrefix "%h" s || hasPrefix "~" s) authorizedKeysFiles)
      ''config.security.pam.sshAgentAuth.authorizedKeysFiles contains files in the user's home directory.

        Specifying user-writeable files there result in an insecure configuration:
        a malicious process can then edit such an authorized_keys file and bypass the ssh-agent-based authentication.
        See https://github.com/NixOS/nixpkgs/issues/31611
      '';

    environment.systemPackages =
      # Include the PAM modules in the system path mostly for the manpages.
      [ package ]
      ++ optional config.users.ldap.enable pam_ldap
      ++ optional config.services.kanidm.enablePam config.services.kanidm.package
      ++ optional config.services.sssd.enable pkgs.sssd
      ++ optionals config.security.pam.krb5.enable [pam_krb5 pam_ccreds]
      ++ optionals config.security.pam.enableOTPW [ pkgs.otpw ]
      ++ optionals config.security.pam.oath.enable [ pkgs.oath-toolkit ]
      ++ optionals config.security.pam.p11.enable [ pkgs.pam_p11 ]
      ++ optionals config.security.pam.enableFscrypt [ pkgs.fscrypt-experimental ]
      ++ optionals config.security.pam.u2f.enable [ pkgs.pam_u2f ];

    boot.supportedFilesystems = optionals config.security.pam.enableEcryptfs [ "ecryptfs" ];

    security.wrappers = {
      unix_chkpwd = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${package}/bin/unix_chkpwd";
      };
    };

    environment.etc = mapAttrs' makePAMService config.security.pam.services;

    security.pam.services =
      { other.text =
          ''
            auth     required pam_warn.so
            auth     required pam_deny.so
            account  required pam_warn.so
            account  required pam_deny.so
            password required pam_warn.so
            password required pam_deny.so
            session  required pam_warn.so
            session  required pam_deny.so
          '';

        # Most of these should be moved to specific modules.
        i3lock = {};
        i3lock-color = {};
        vlock = {};
        xlock = {};
        xscreensaver = {};

        runuser = { rootOK = true; unixAuth = false; setEnvironment = false; };

        /* FIXME: should runuser -l start a systemd session? Currently
           it complains "Cannot create session: Already running in a
           session". */
        runuser-l = { rootOK = true; unixAuth = false; };
      } // optionalAttrs (config.security.pam.enableFscrypt) {
        # Allow fscrypt to verify login passphrase
        fscrypt = {};
      };

    security.apparmor.includes."abstractions/pam" =
      lib.concatMapStrings
        (name: "r ${config.environment.etc."pam.d/${name}".source},\n")
        (attrNames config.security.pam.services) +
      (with lib; pipe config.security.pam.services [
        attrValues
        (catAttrs "rules")
        (concatMap attrValues)
        (concatMap attrValues)
        (filter (rule: rule.enable))
        (catAttrs "modulePath")
        # TODO(@uninsane): replace this warning + filter with just an assertion
        (map (modulePath: lib.warnIfNot
          (hasPrefix "/" modulePath)
          ''non-absolute PAM modulePath "${modulePath}" is unsupported by apparmor and will be treated as an error by future versions of nixpkgs; see <https://github.com/NixOS/nixpkgs/pull/314791>''
          modulePath
        ))
        (filter (hasPrefix "/"))
        unique
        (map (module: "mr ${module},"))
        concatLines
      ]);

    security.sudo.extraConfig = optionalSudoConfigForSSHAgentAuth;
    security.sudo-rs.extraConfig = optionalSudoConfigForSSHAgentAuth;
  };
}

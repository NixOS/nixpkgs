# This module provides configuration for the PAM (Pluggable
# Authentication Modules) system.

{ config, lib, pkgs, ... }:

with lib;

let
  parentConfig = config;

  pamOpts = { config, name, ... }: let cfg = config; in let config = parentConfig; in {

    options = {

      name = mkOption {
        example = "sshd";
        type = types.str;
        description = lib.mdDoc "Name of the PAM service.";
      };

      unixAuth = mkOption {
        default = true;
        type = types.bool;
        description = lib.mdDoc ''
          Whether users can log in with passwords defined in
          {file}`/etc/shadow`.
        '';
      };

      rootOK = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          If set, root doesn't need to authenticate (e.g. for the
          {command}`useradd` service).
        '';
      };

      p11Auth = mkOption {
        default = config.security.pam.p11.enable;
        defaultText = literalExpression "config.security.pam.p11.enable";
        type = types.bool;
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          If set, users listed in
          {file}`~/.yubico/authorized_yubikeys`
          are able to log in with the associated Yubikey tokens.
        '';
      };

      googleAuthenticator = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = lib.mdDoc ''
            If set, users with enabled Google Authenticator (created
            {file}`~/.google_authenticator`) will be required
            to provide Google Authenticator token to log in.
          '';
        };
      };

      usbAuth = mkOption {
        default = config.security.pam.usb.enable;
        defaultText = literalExpression "config.security.pam.usb.enable";
        type = types.bool;
        description = lib.mdDoc ''
          If set, users listed in
          {file}`/etc/pamusb.conf` are able to log in
          with the associated USB key.
        '';
      };

      otpwAuth = mkOption {
        default = config.security.pam.enableOTPW;
        defaultText = literalExpression "config.security.pam.enableOTPW";
        type = types.bool;
        description = lib.mdDoc ''
          If set, the OTPW system will be used (if
          {file}`~/.otpw` exists).
        '';
      };

      googleOsLoginAccountVerification = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          If set, the `pam_mysql` module will be used to
          authenticate users against a MySQL/MariaDB database.
        '';
      };

      fprintAuth = mkOption {
        default = config.services.fprintd.enable;
        defaultText = literalExpression "config.services.fprintd.enable";
        type = types.bool;
        description = lib.mdDoc ''
          If set, fingerprint reader will be used (if exists and
          your fingerprints are enrolled).
        '';
      };

      oathAuth = mkOption {
        default = config.security.pam.oath.enable;
        defaultText = literalExpression "config.security.pam.oath.enable";
        type = types.bool;
        description = lib.mdDoc ''
          If set, the OATH Toolkit will be used.
        '';
      };

      sshAgentAuth = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
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
          description = lib.mdDoc ''
            If set, use the Duo Security pam module
            `pam_duo` for authentication.  Requires
            configuration of {option}`security.duosec` options.
          '';
        };
      };

      startSession = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          Whether the service should set the environment variables
          listed in {option}`environment.sessionVariables`
          using `pam_env.so`.
        '';
      };

      setLoginUid = mkOption {
        type = types.bool;
        description = lib.mdDoc ''
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
          description = lib.mdDoc ''
            Enable or disable TTY auditing for specified users
          '';
        };

        enablePattern = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            For each user matching one of comma-separated
            glob patterns, enable TTY auditing
          '';
        };

        disablePattern = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            For each user matching one of comma-separated
            glob patterns, disable TTY auditing
          '';
        };

        openOnly = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          Whether X authentication keys should be passed from the
          calling user to the target user (e.g. for
          {command}`su`)
        '';
      };

      pamMount = mkOption {
        default = config.security.pam.mount.enable;
        defaultText = literalExpression "config.security.pam.mount.enable";
        type = types.bool;
        description = lib.mdDoc ''
          Enable PAM mount (pam_mount) system to mount filesystems on user login.
        '';
      };

      allowNullPassword = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          Whether the delay after typing a wrong password should be disabled.
        '';
      };

      requireWheel = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether to permit root access only to members of group wheel.
        '';
      };

      limits = mkOption {
        default = [];
        type = limitsType;
        description = lib.mdDoc ''
          Attribute set describing resource limits.  Defaults to the
          value of {option}`security.pam.loginLimits`.
          The meaning of the values is explained in {manpage}`limits.conf(5)`.
        '';
      };

      showMotd = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Whether to show the message of the day.";
      };

      makeHomeDir = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether to try to create home directories for users
          with `$HOME`s pointing to nonexistent
          locations on session login.
        '';
      };

      updateWtmp = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Whether to update {file}`/var/log/wtmp`.";
      };

      logFailures = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Whether to log authentication failures in {file}`/var/log/faillog`.";
      };

      enableAppArmor = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Enable support for attaching AppArmor profiles at the
          user/group level, e.g., as part of a role based access
          control scheme.
        '';
      };

      enableKwallet = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          If enabled, pam_wallet will attempt to automatically unlock the
          user's default KDE wallet upon login. If the user has no wallet named
          "kdewallet", or the login password does not match their wallet
          password, KDE will prompt separately after login.
        '';
      };
      sssdStrictAccess = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "enforce sssd access control";
      };

      enableGnomeKeyring = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
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
          description = lib.mdDoc ''
            If enabled, this will replace the `FAIL_DELAY` setting from `login.defs`.
            Change the delay on failure per-application.
            '';
        };

        delay = mkOption {
          default = 3000000;
          type = types.int;
          example = 1000000;
          description = lib.mdDoc "The delay time (in microseconds) on failure.";
        };
      };

      gnupg = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
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
          description = lib.mdDoc ''
            Don't start {command}`gpg-agent` if it is not running.
            Useful in conjunction with starting {command}`gpg-agent` as
            a systemd user service.
          '';
        };

        storeOnly = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
            Don't send the password immediately after login, but store for PAM
            `session`.
          '';
        };
      };

      text = mkOption {
        type = types.nullOr types.lines;
        description = lib.mdDoc "Contents of the PAM service file.";
      };

    };

    # The resulting /etc/pam.d/* file contents are verified in
    # nixos/tests/pam/pam-file-contents.nix. Please update tests there when
    # changing the derivation.
    config = {
      name = mkDefault name;
      setLoginUid = mkDefault cfg.startSession;
      limits = mkDefault config.security.pam.loginLimits;

      # !!! TODO: move the LDAP stuff to the LDAP module, and the
      # Samba stuff to the Samba module.  This requires that the PAM
      # module provides the right hooks.
      text = mkDefault
        (
          ''
            # Account management.
          '' +
          optionalString use_ldap ''
            account sufficient ${pam_ldap}/lib/security/pam_ldap.so
          '' +
          optionalString cfg.mysqlAuth ''
            account sufficient ${pkgs.pam_mysql}/lib/security/pam_mysql.so config_file=/etc/security/pam_mysql.conf
          '' +
          optionalString (config.services.sssd.enable && cfg.sssdStrictAccess==false) ''
            account sufficient ${pkgs.sssd}/lib/security/pam_sss.so
          '' +
          optionalString (config.services.sssd.enable && cfg.sssdStrictAccess) ''
            account [default=bad success=ok user_unknown=ignore] ${pkgs.sssd}/lib/security/pam_sss.so
          '' +
          optionalString config.security.pam.krb5.enable ''
            account sufficient ${pam_krb5}/lib/security/pam_krb5.so
          '' +
          optionalString cfg.googleOsLoginAccountVerification ''
            account [success=ok ignore=ignore default=die] ${pkgs.google-guest-oslogin}/lib/security/pam_oslogin_login.so
            account [success=ok default=ignore] ${pkgs.google-guest-oslogin}/lib/security/pam_oslogin_admin.so
          '' +
          optionalString config.services.homed.enable ''
            account sufficient ${config.systemd.package}/lib/security/pam_systemd_home.so
          '' +
          # The required pam_unix.so module has to come after all the sufficient modules
          # because otherwise, the account lookup will fail if the user does not exist
          # locally, for example with MySQL- or LDAP-auth.
          ''
            account required pam_unix.so

            # Authentication management.
          '' +
          optionalString cfg.googleOsLoginAuthentication ''
            auth [success=done perm_denied=die default=ignore] ${pkgs.google-guest-oslogin}/lib/security/pam_oslogin_login.so
          '' +
          optionalString cfg.rootOK ''
            auth sufficient pam_rootok.so
          '' +
          optionalString cfg.requireWheel ''
            auth required pam_wheel.so use_uid
          '' +
          optionalString cfg.logFailures ''
            auth required pam_faillock.so
          '' +
          optionalString cfg.mysqlAuth ''
            auth sufficient ${pkgs.pam_mysql}/lib/security/pam_mysql.so config_file=/etc/security/pam_mysql.conf
          '' +
          optionalString (config.security.pam.enableSSHAgentAuth && cfg.sshAgentAuth) ''
            auth sufficient ${pkgs.pam_ssh_agent_auth}/libexec/pam_ssh_agent_auth.so file=${lib.concatStringsSep ":" config.services.openssh.authorizedKeysFiles}
          '' +
          (let p11 = config.security.pam.p11; in optionalString cfg.p11Auth ''
            auth ${p11.control} ${pkgs.pam_p11}/lib/security/pam_p11.so ${pkgs.opensc}/lib/opensc-pkcs11.so
          '') +
          (let u2f = config.security.pam.u2f; in optionalString cfg.u2fAuth (''
              auth ${u2f.control} ${pkgs.pam_u2f}/lib/security/pam_u2f.so ${optionalString u2f.debug "debug"} ${optionalString (u2f.authFile != null) "authfile=${u2f.authFile}"} ''
                + ''${optionalString u2f.interactive "interactive"} ${optionalString u2f.cue "cue"} ${optionalString (u2f.appId != null) "appid=${u2f.appId}"} ${optionalString (u2f.origin != null) "origin=${u2f.origin}"}
          '')) +
          optionalString cfg.usbAuth ''
            auth sufficient ${pkgs.pam_usb}/lib/security/pam_usb.so
          '' +
          (let ussh = config.security.pam.ussh; in optionalString (config.security.pam.ussh.enable && cfg.usshAuth) ''
            auth ${ussh.control} ${pkgs.pam_ussh}/lib/security/pam_ussh.so ${optionalString (ussh.caFile != null) "ca_file=${ussh.caFile}"} ${optionalString (ussh.authorizedPrincipals != null) "authorized_principals=${ussh.authorizedPrincipals}"} ${optionalString (ussh.authorizedPrincipalsFile != null) "authorized_principals_file=${ussh.authorizedPrincipalsFile}"} ${optionalString (ussh.group != null) "group=${ussh.group}"}
          '') +
          (let oath = config.security.pam.oath; in optionalString cfg.oathAuth ''
            auth requisite ${pkgs.oath-toolkit}/lib/security/pam_oath.so window=${toString oath.window} usersfile=${toString oath.usersFile} digits=${toString oath.digits}
          '') +
          (let yubi = config.security.pam.yubico; in optionalString cfg.yubicoAuth ''
            auth ${yubi.control} ${pkgs.yubico-pam}/lib/security/pam_yubico.so mode=${toString yubi.mode} ${optionalString (yubi.challengeResponsePath != null) "chalresp_path=${yubi.challengeResponsePath}"} ${optionalString (yubi.mode == "client") "id=${toString yubi.id}"} ${optionalString yubi.debug "debug"}
          '') +
          optionalString cfg.fprintAuth ''
            auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so
          '' +
          # Modules in this block require having the password set in PAM_AUTHTOK.
          # pam_unix is marked as 'sufficient' on NixOS which means nothing will run
          # after it succeeds. Certain modules need to run after pam_unix
          # prompts the user for password so we run it once with 'optional' at an
          # earlier point and it will run again with 'sufficient' further down.
          # We use try_first_pass the second time to avoid prompting password twice.
          #
          # The same principle applies to systemd-homed
          (optionalString ((cfg.unixAuth || config.services.homed.enable) &&
            (config.security.pam.enableEcryptfs
              || config.security.pam.enableFscrypt
              || cfg.pamMount
              || cfg.enableKwallet
              || cfg.enableGnomeKeyring
              || cfg.googleAuthenticator.enable
              || cfg.gnupg.enable
              || cfg.failDelay.enable
              || cfg.duoSecurity.enable))
            (
              optionalString config.services.homed.enable ''
                auth optional ${config.systemd.package}/lib/security/pam_systemd_home.so
              '' +
              optionalString cfg.unixAuth ''
                auth optional pam_unix.so ${optionalString cfg.allowNullPassword "nullok"} ${optionalString cfg.nodelay "nodelay"} likeauth
              '' +
              optionalString config.security.pam.enableEcryptfs ''
                auth optional ${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so unwrap
              '' +
              optionalString config.security.pam.enableFscrypt ''
                auth optional ${pkgs.fscrypt-experimental}/lib/security/pam_fscrypt.so
              '' +
              optionalString cfg.pamMount ''
                auth optional ${pkgs.pam_mount}/lib/security/pam_mount.so disable_interactive
              '' +
              optionalString cfg.enableKwallet ''
               auth optional ${pkgs.plasma5Packages.kwallet-pam}/lib/security/pam_kwallet5.so kwalletd=${pkgs.plasma5Packages.kwallet.bin}/bin/kwalletd5
              '' +
              optionalString cfg.enableGnomeKeyring ''
                auth optional ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so
              '' +
              optionalString cfg.gnupg.enable ''
                auth optional ${pkgs.pam_gnupg}/lib/security/pam_gnupg.so ${optionalString cfg.gnupg.storeOnly " store-only"}
              '' +
              optionalString cfg.failDelay.enable ''
                auth optional ${pkgs.pam}/lib/security/pam_faildelay.so delay=${toString cfg.failDelay.delay}
              '' +
              optionalString cfg.googleAuthenticator.enable ''
                auth required ${pkgs.google-authenticator}/lib/security/pam_google_authenticator.so no_increment_hotp
              '' +
              optionalString cfg.duoSecurity.enable ''
                auth required ${pkgs.duo-unix}/lib/security/pam_duo.so
              ''
            )) +
          optionalString config.services.homed.enable ''
            auth sufficient ${config.systemd.package}/lib/security/pam_systemd_home.so
          '' +
          optionalString cfg.unixAuth ''
            auth sufficient pam_unix.so ${optionalString cfg.allowNullPassword "nullok"} ${optionalString cfg.nodelay "nodelay"} likeauth try_first_pass
          '' +
          optionalString cfg.otpwAuth ''
            auth sufficient ${pkgs.otpw}/lib/security/pam_otpw.so
          '' +
          optionalString use_ldap ''
            auth sufficient ${pam_ldap}/lib/security/pam_ldap.so use_first_pass
          '' +
          optionalString config.services.sssd.enable ''
            auth sufficient ${pkgs.sssd}/lib/security/pam_sss.so use_first_pass
          '' +
          optionalString config.security.pam.krb5.enable ''
            auth [default=ignore success=1 service_err=reset] ${pam_krb5}/lib/security/pam_krb5.so use_first_pass
            auth [default=die success=done] ${pam_ccreds}/lib/security/pam_ccreds.so action=validate use_first_pass
            auth sufficient ${pam_ccreds}/lib/security/pam_ccreds.so action=store use_first_pass
          '' +
          ''
            auth required pam_deny.so

            # Password management.
          '' +
          optionalString config.services.homed.enable ''
            password sufficient ${config.systemd.package}/lib/security/pam_systemd_home.so
          '' + ''
            password sufficient pam_unix.so nullok yescrypt
          '' +
          optionalString config.security.pam.enableEcryptfs ''
            password optional ${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so
          '' +
          optionalString config.security.pam.enableFscrypt ''
            password optional ${pkgs.fscrypt-experimental}/lib/security/pam_fscrypt.so
          '' +
          optionalString cfg.pamMount ''
            password optional ${pkgs.pam_mount}/lib/security/pam_mount.so
          '' +
          optionalString use_ldap ''
            password sufficient ${pam_ldap}/lib/security/pam_ldap.so
          '' +
          optionalString cfg.mysqlAuth ''
            password sufficient ${pkgs.pam_mysql}/lib/security/pam_mysql.so config_file=/etc/security/pam_mysql.conf
          '' +
          optionalString config.services.sssd.enable ''
            password sufficient ${pkgs.sssd}/lib/security/pam_sss.so use_authtok
          '' +
          optionalString config.security.pam.krb5.enable ''
            password sufficient ${pam_krb5}/lib/security/pam_krb5.so use_first_pass
          '' +
          optionalString cfg.enableGnomeKeyring ''
            password optional ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so use_authtok
          '' +
          ''

            # Session management.
          '' +
          optionalString cfg.setEnvironment ''
            session required pam_env.so conffile=/etc/pam/environment readenv=0
          '' +
          ''
            session required pam_unix.so
          '' +
          optionalString cfg.setLoginUid ''
            session ${if config.boot.isContainer then "optional" else "required"} pam_loginuid.so
          '' +
          optionalString cfg.ttyAudit.enable (concatStringsSep " \\\n  " ([
            "session required ${pkgs.pam}/lib/security/pam_tty_audit.so"
          ] ++ optional cfg.ttyAudit.openOnly "open_only"
          ++ optional (cfg.ttyAudit.enablePattern != null) "enable=${cfg.ttyAudit.enablePattern}"
          ++ optional (cfg.ttyAudit.disablePattern != null) "disable=${cfg.ttyAudit.disablePattern}"
          )) +
          optionalString config.services.homed.enable ''
            session required ${config.systemd.package}/lib/security/pam_systemd_home.so
          '' +
          optionalString cfg.makeHomeDir ''
            session required ${pkgs.pam}/lib/security/pam_mkhomedir.so silent skel=${config.security.pam.makeHomeDir.skelDirectory} umask=0077
          '' +
          optionalString cfg.updateWtmp ''
            session required ${pkgs.pam}/lib/security/pam_lastlog.so silent
          '' +
          optionalString config.security.pam.enableEcryptfs ''
            session optional ${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so
          '' +
          optionalString config.security.pam.enableFscrypt ''
            # Work around https://github.com/systemd/systemd/issues/8598
            # Skips the pam_fscrypt module for systemd-user sessions which do not have a password
            # anyways.
            # See also https://github.com/google/fscrypt/issues/95
            session [success=1 default=ignore] pam_succeed_if.so service = systemd-user
            session optional ${pkgs.fscrypt-experimental}/lib/security/pam_fscrypt.so
          '' +
          optionalString cfg.pamMount ''
            session optional ${pkgs.pam_mount}/lib/security/pam_mount.so disable_interactive
          '' +
          optionalString use_ldap ''
            session optional ${pam_ldap}/lib/security/pam_ldap.so
          '' +
          optionalString cfg.mysqlAuth ''
            session optional ${pkgs.pam_mysql}/lib/security/pam_mysql.so config_file=/etc/security/pam_mysql.conf
          '' +
          optionalString config.services.sssd.enable ''
            session optional ${pkgs.sssd}/lib/security/pam_sss.so
          '' +
          optionalString config.security.pam.krb5.enable ''
            session optional ${pam_krb5}/lib/security/pam_krb5.so
          '' +
          optionalString cfg.otpwAuth ''
            session optional ${pkgs.otpw}/lib/security/pam_otpw.so
          '' +
          optionalString cfg.startSession ''
            session optional ${config.systemd.package}/lib/security/pam_systemd.so
          '' +
          optionalString cfg.forwardXAuth ''
            session optional pam_xauth.so xauthpath=${pkgs.xorg.xauth}/bin/xauth systemuser=99
          '' +
          optionalString (cfg.limits != []) ''
            session required ${pkgs.pam}/lib/security/pam_limits.so conf=${makeLimitsConf cfg.limits}
          '' +
          optionalString (cfg.showMotd && (config.users.motd != null || config.users.motdFile != null)) ''
            session optional ${pkgs.pam}/lib/security/pam_motd.so motd=${motd}
          '' +
          optionalString (cfg.enableAppArmor && config.security.apparmor.enable) ''
            session optional ${pkgs.apparmor-pam}/lib/security/pam_apparmor.so order=user,group,default debug
          '' +
          optionalString (cfg.enableKwallet) ''
            session optional ${pkgs.plasma5Packages.kwallet-pam}/lib/security/pam_kwallet5.so kwalletd=${pkgs.plasma5Packages.kwallet.bin}/bin/kwalletd5
          '' +
          optionalString (cfg.enableGnomeKeyring) ''
            session optional ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
          '' +
          optionalString cfg.gnupg.enable ''
            session optional ${pkgs.pam_gnupg}/lib/security/pam_gnupg.so ${optionalString cfg.gnupg.noAutostart " no-autostart"}
          '' +
          optionalString (config.virtualisation.lxc.lxcfs.enable) ''
            session optional ${pkgs.lxc}/lib/security/pam_cgfs.so -c all
          ''
        );
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
        description = lib.mdDoc "Username, groupname, or wildcard this limit applies to";
        example = "@wheel";
        type = str;
      };

      type = mkOption {
        description = lib.mdDoc "Type of this limit";
        type = enum [ "-" "hard" "soft" ];
        default = "-";
      };

      item = mkOption {
        description = lib.mdDoc "Item this limit applies to";
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
        description = lib.mdDoc "Value of this limit";
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

in

{

  imports = [
    (mkRenamedOptionModule [ "security" "pam" "enableU2F" ] [ "security" "pam" "u2f" "enable" ])
  ];

  ###### interface

  options = {

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

     description = lib.mdDoc ''
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
      description =
        lib.mdDoc ''
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
      description = lib.mdDoc ''
        Path to skeleton directory whose contents are copied to home
        directories newly created by `pam_mkhomedir`.
      '';
    };

    security.pam.enableSSHAgentAuth = mkOption {
      type = types.bool;
      default = false;
      description =
        lib.mdDoc ''
          Enable sudo logins if the user's SSH agent provides a key
          present in {file}`~/.ssh/authorized_keys`.
          This allows machines to exclusively use SSH keys instead of
          passwords.
        '';
    };

    security.pam.enableOTPW = mkEnableOption (lib.mdDoc "the OTPW (one-time password) PAM module");

    security.pam.krb5 = {
      enable = mkOption {
        default = config.krb5.enable;
        defaultText = literalExpression "config.krb5.enable";
        type = types.bool;
        description = lib.mdDoc ''
          Enables Kerberos PAM modules (`pam-krb5`,
          `pam-ccreds`).

          If set, users can authenticate with their Kerberos password.
          This requires a valid Kerberos configuration
          (`config.krb5.enable` should be set to
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
        description = lib.mdDoc ''
          Enables P11 PAM (`pam_p11`) module.

          If set, users can log in with SSH keys and PKCS#11 tokens.

          More information can be found [here](https://github.com/OpenSC/pam_p11).
        '';
      };

      control = mkOption {
        default = "sufficient";
        type = types.enum [ "required" "requisite" "sufficient" "optional" ];
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
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

      authFile = mkOption {
        default = null;
        type = with types; nullOr path;
        description = lib.mdDoc ''
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

      appId = mkOption {
        default = null;
        type = with types; nullOr str;
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
            By default `pam-u2f` module sets the origin
            to `pam://$HOSTNAME`.
            Setting origin to an host independent value will allow you to
            reuse credentials across machines

            When using {command}`pamu2fcfg`, you can specify your
            application ID with the `-o` flag.

            More information can be found [here](https://developers.yubico.com/pam-u2f/Manuals/pam_u2f.8.html)
        '';
      };

      control = mkOption {
        default = "sufficient";
        type = types.enum [ "required" "requisite" "sufficient" "optional" ];
        description = lib.mdDoc ''
          This option sets pam "control".
          If you want to have multi factor authentication, use "required".
          If you want to use U2F device instead of regular password, use "sufficient".

          Read
          {manpage}`pam.conf(5)`
          for better understanding of this option.
        '';
      };

      debug = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Debug output to stderr.
        '';
      };

      interactive = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Set to prompt a message and wait before testing the presence of a U2F device.
          Recommended if your device doesn’t have a tactile trigger.
        '';
      };

      cue = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          By default `pam-u2f` module does not inform user
          that he needs to use the u2f device, it just waits without a prompt.

          If you set this option to `true`,
          `cue` option is added to `pam-u2f`
          module and reminder message will be displayed.
        '';
      };
    };

    security.pam.ussh = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          By default `pam-ussh` reads the trusted user CA keys
          from {file}`/etc/ssh/trusted_user_ca`.

          This should be set the same as your `TrustedUserCAKeys`
          option for sshd.
        '';
      };

      authorizedPrincipals = mkOption {
        default = null;
        type = with types; nullOr commas;
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          If set, then the authenticating user must be a member of this group
          to use this module.
        '';
      };

      control = mkOption {
        default = "sufficient";
        type = types.enum [ "required" "requisite" "sufficient" "optional" ];
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
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
        description = lib.mdDoc "client id";
      };

      debug = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Debug output to stderr.
        '';
      };
      mode = mkOption {
        default = "client";
        type = types.enum [ "client" "challenge-response" ];
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          If not null, set the path used by yubico pam module where the challenge expected response is stored.

          More information can be found [here](https://developers.yubico.com/yubico-pam/Authentication_Using_Challenge-Response.html).
        '';
      };
    };

    security.pam.enableEcryptfs = mkEnableOption (lib.mdDoc "eCryptfs PAM module (mounting ecryptfs home directory on login)");
    security.pam.enableFscrypt = mkEnableOption (lib.mdDoc ''
      Enables fscrypt to automatically unlock directories with the user's login password.

      This also enables a service at security.pam.services.fscrypt which is used by
      fscrypt to verify the user's password when setting up a new protector. If you
      use something other than pam_unix to verify user passwords, please remember to
      adjust this PAM service.
    '');

    users.motd = mkOption {
      default = null;
      example = "Today is Sweetmorn, the 4th day of The Aftermath in the YOLD 3178.";
      type = types.nullOr types.lines;
      description = lib.mdDoc "Message of the day shown to users when they log in.";
    };

    users.motdFile = mkOption {
      default = null;
      example = "/etc/motd";
      type = types.nullOr types.path;
      description = lib.mdDoc "A file containing the message of the day shown to users when they log in.";
    };
  };


  ###### implementation

  config = {
    assertions = [
      {
        assertion = config.users.motd == null || config.users.motdFile == null;
        message = ''
          Only one of users.motd and users.motdFile can be set.
        '';
      }
    ];

    environment.systemPackages =
      # Include the PAM modules in the system path mostly for the manpages.
      [ pkgs.pam ]
      ++ optional config.users.ldap.enable pam_ldap
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
        source = "${pkgs.pam}/bin/unix_chkpwd";
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

    security.apparmor.includes."abstractions/pam" = let
      isEnabled = test: fold or false (map test (attrValues config.security.pam.services));
      in
      lib.concatMapStrings
        (name: "r ${config.environment.etc."pam.d/${name}".source},\n")
        (attrNames config.security.pam.services) +
      ''
      mr ${getLib pkgs.pam}/lib/security/pam_filter/*,
      mr ${getLib pkgs.pam}/lib/security/pam_*.so,
      r ${getLib pkgs.pam}/lib/security/,
      '' +
      optionalString use_ldap ''
         mr ${pam_ldap}/lib/security/pam_ldap.so,
      '' +
      optionalString config.services.sssd.enable ''
        mr ${pkgs.sssd}/lib/security/pam_sss.so,
      '' +
      optionalString config.security.pam.krb5.enable ''
        mr ${pam_krb5}/lib/security/pam_krb5.so,
        mr ${pam_ccreds}/lib/security/pam_ccreds.so,
      '' +
      optionalString (isEnabled (cfg: cfg.googleOsLoginAccountVerification)) ''
        mr ${pkgs.google-guest-oslogin}/lib/security/pam_oslogin_login.so,
        mr ${pkgs.google-guest-oslogin}/lib/security/pam_oslogin_admin.so,
      '' +
      optionalString (isEnabled (cfg: cfg.googleOsLoginAuthentication)) ''
        mr ${pkgs.google-guest-oslogin}/lib/security/pam_oslogin_login.so,
      '' +
      optionalString (config.security.pam.enableSSHAgentAuth
                     && isEnabled (cfg: cfg.sshAgentAuth)) ''
        mr ${pkgs.pam_ssh_agent_auth}/libexec/pam_ssh_agent_auth.so,
      '' +
      optionalString (isEnabled (cfg: cfg.fprintAuth)) ''
        mr ${pkgs.fprintd}/lib/security/pam_fprintd.so,
      '' +
      optionalString (isEnabled (cfg: cfg.u2fAuth)) ''
        mr ${pkgs.pam_u2f}/lib/security/pam_u2f.so,
      '' +
      optionalString (isEnabled (cfg: cfg.usbAuth)) ''
        mr ${pkgs.pam_usb}/lib/security/pam_usb.so,
      '' +
      optionalString (isEnabled (cfg: cfg.usshAuth)) ''
        mr ${pkgs.pam_ussh}/lib/security/pam_ussh.so,
      '' +
      optionalString (isEnabled (cfg: cfg.oathAuth)) ''
        "mr ${pkgs.oath-toolkit}/lib/security/pam_oath.so,
      '' +
      optionalString (isEnabled (cfg: cfg.mysqlAuth)) ''
        mr ${pkgs.pam_mysql}/lib/security/pam_mysql.so,
      '' +
      optionalString (isEnabled (cfg: cfg.yubicoAuth)) ''
        mr ${pkgs.yubico-pam}/lib/security/pam_yubico.so,
      '' +
      optionalString (isEnabled (cfg: cfg.duoSecurity.enable)) ''
        mr ${pkgs.duo-unix}/lib/security/pam_duo.so,
      '' +
      optionalString (isEnabled (cfg: cfg.otpwAuth)) ''
        mr ${pkgs.otpw}/lib/security/pam_otpw.so,
      '' +
      optionalString config.security.pam.enableEcryptfs ''
        mr ${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so,
      '' +
      optionalString config.security.pam.enableFscrypt ''
        mr ${pkgs.fscrypt-experimental}/lib/security/pam_fscrypt.so,
      '' +
      optionalString (isEnabled (cfg: cfg.pamMount)) ''
        mr ${pkgs.pam_mount}/lib/security/pam_mount.so,
      '' +
      optionalString (isEnabled (cfg: cfg.enableGnomeKeyring)) ''
        mr ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so,
      '' +
      optionalString (isEnabled (cfg: cfg.startSession)) ''
        mr ${config.systemd.package}/lib/security/pam_systemd.so,
      '' +
      optionalString (isEnabled (cfg: cfg.enableAppArmor)
                     && config.security.apparmor.enable) ''
        mr ${pkgs.apparmor-pam}/lib/security/pam_apparmor.so,
      '' +
      optionalString (isEnabled (cfg: cfg.enableKwallet)) ''
        mr ${pkgs.plasma5Packages.kwallet-pam}/lib/security/pam_kwallet5.so,
      '' +
      optionalString config.virtualisation.lxc.lxcfs.enable ''
        mr ${pkgs.lxc}/lib/security/pam_cgfs.so
      '' +
      optionalString config.services.homed.enable ''
        mr ${config.systemd.package}/lib/security/pam_systemd_home.so
      '';
  };

}

# This module provides configuration for the PAM (Pluggable
# Authentication Modules) system.

{ config, lib, pkgs, ... }:

with lib;

let
  returnCode = types.enum [
    "success" "open_err" "symbol_err" "service_err" "system_err" "buf_err"
    "perm_denied" "auth_err" "cred_insufficient" "authinfo_unavail"
    "user_unknown" "maxtries" "new_authtok_reqd" "acct_expired" "session_err"
    "cred_unavail" "cred_expired" "cred_err" "no_module_data" "conv_err"
    "authtok_err" "authtok_recover_err" "authtok_lock_busy"
    "authtok_disable_aging" "try_again" "ignore" "abort" "authtok_expired"
    "module_unknown" "bad_item" "conv_again" "incomplete" "default"
  ];
  action = types.either types.int (types.enum ["ignore" "bad" "die" "ok" "done" "reset"]);

  controlType = types.either
    (types.enum [ "required" "requisite" "sufficient" "optional" "include" "substack" ])
    (types.addCheck (types.attrsOf action) (x: all returnCode.check (attrNames x)));

  pamEntry = types.submodule {
    options = {
      entryType = mkOption {
        type = types.enum [ "account" "auth" "password" "session" ];
      };
      control = mkOption {
        type = controlType;
      };
      path = mkOption {
        type = types.str; # Not types.path, to support builtin modules (e.g. pam_unix.so)
      };
      arguments = mkOption {
        default = [];
        type = types.listOf types.str;
      };
    };
  };

  parentConfig = config;

  pamOpts = { config, name, ... }: let cfg = config; in let config = parentConfig; in {
    options = {
      name = mkOption {
        example = "sshd";
        type = types.str;
        description = "Name of the PAM service.";
      };

      unixAuth = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Whether users can log in with passwords defined in
          <filename>/etc/shadow</filename>.
        '';
      };

      rootOK = mkOption {
        default = false;
        type = types.bool;
        description = ''
          If set, root doesn't need to authenticate (e.g. for the
          <command>useradd</command> service).
        '';
      };

      p11Auth = mkOption {
        default = config.security.pam.p11.enable;
        type = types.bool;
        description = ''
          If set, keys listed in
          <filename>~/.ssh/authorized_keys</filename> and
          <filename>~/.eid/authorized_certificates</filename>
          can be used to log in with the associated PKCS#11 tokens.
        '';
      };

      u2fAuth = mkOption {
        default = config.security.pam.u2f.enable;
        type = types.bool;
        description = ''
          If set, users listed in
          <filename>$XDG_CONFIG_HOME/Yubico/u2f_keys</filename> (or
          <filename>$HOME/.config/Yubico/u2f_keys</filename> if XDG variable is
          not set) are able to log in with the associated U2F key. Path can be
          changed using <option>security.pam.u2f.authFile</option> option.
        '';
      };

      yubicoAuth = mkOption {
        default = config.security.pam.yubico.enable;
        type = types.bool;
        description = ''
          If set, users listed in
          <filename>~/.yubico/authorized_yubikeys</filename>
          are able to log in with the associated Yubikey tokens.
        '';
      };

      googleAuthenticator = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = ''
            If set, users with enabled Google Authenticator (created
            <filename>~/.google_authenticator</filename>) will be required
            to provide Google Authenticator token to log in.
          '';
        };
      };

      usbAuth = mkOption {
        default = config.security.pam.usb.enable;
        type = types.bool;
        description = ''
          If set, users listed in
          <filename>/etc/pamusb.conf</filename> are able to log in
          with the associated USB key.
        '';
      };

      otpwAuth = mkOption {
        default = config.security.pam.enableOTPW;
        type = types.bool;
        description = ''
          If set, the OTPW system will be used (if
          <filename>~/.otpw</filename> exists).
        '';
      };

      googleOsLoginAccountVerification = mkOption {
        default = false;
        type = types.bool;
        description = ''
          If set, will use the Google OS Login PAM modules
          (<literal>pam_oslogin_login</literal>,
          <literal>pam_oslogin_admin</literal>) to verify possible OS Login
          users and set sudoers configuration accordingly.
          This only makes sense to enable for the <literal>sshd</literal> PAM
          service.
        '';
      };

      googleOsLoginAuthentication = mkOption {
        default = false;
        type = types.bool;
        description = ''
          If set, will use the <literal>pam_oslogin_login</literal>'s user
          authentication methods to authenticate users using 2FA.
          This only makes sense to enable for the <literal>sshd</literal> PAM
          service.
        '';
      };

      fprintAuth = mkOption {
        default = config.services.fprintd.enable;
        type = types.bool;
        description = ''
          If set, fingerprint reader will be used (if exists and
          your fingerprints are enrolled).
        '';
      };

      oathAuth = mkOption {
        default = config.security.pam.oath.enable;
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
          <filename>~/.ssh/authorized_keys</filename>.  This is useful
          for <command>sudo</command> on password-less remote systems.
        '';
      };

      duoSecurity = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = ''
            If set, use the Duo Security pam module
            <literal>pam_duo</literal> for authentication.  Requires
            configuration of <option>security.duosec</option> options.
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
          listed in <option>environment.sessionVariables</option>
          using <literal>pam_env.so</literal>.
        '';
      };

      setLoginUid = mkOption {
        type = types.bool;
        description = ''
          Set the login uid of the process
          (<filename>/proc/self/loginuid</filename>) for auditing
          purposes.  The login uid is only set by ‘entry points’ like
          <command>login</command> and <command>sshd</command>, not by
          commands like <command>sudo</command>.
        '';
      };

      forwardXAuth = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether X authentication keys should be passed from the
          calling user to the target user (e.g. for
          <command>su</command>)
        '';
      };

      pamMount = mkOption {
        default = config.security.pam.mount.enable;
        type = types.bool;
        description = ''
          Enable PAM mount (pam_mount) system to mount fileystems on user login.
        '';
      };

      allowNullPassword = mkOption {
        default = false;
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
        default = false;
        type = types.bool;
        description = ''
          Wheather the delay after typing a wrong password should be disabled.
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
        description = ''
          Attribute set describing resource limits.  Defaults to the
          value of <option>security.pam.loginLimits</option>.
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
          with <literal>$HOME</literal>s pointing to nonexistent
          locations on session login.
        '';
      };

      updateWtmp = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to update <filename>/var/log/wtmp</filename>.";
      };

      logFailures = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to log authentication failures in <filename>/var/log/faillog</filename>.";
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

      enableKwallet = mkOption {
        default = false;
        type = types.bool;
        description = ''
          If enabled, pam_wallet will attempt to automatically unlock the
          user's default KDE wallet upon login. If the user has no wallet named
          "kdewallet", or the login password does not match their wallet
          password, KDE will prompt separately after login.
        '';
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

      gnupg = {
        enable = mkOption {
          type = types.bool;
          default = false;
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
          default = false;
          description = ''
            Don't start <command>gpg-agent</command> if it is not running.
            Useful in conjunction with starting <command>gpg-agent</command> as
            a systemd user service.
          '';
        };

        storeOnly = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Don't send the password immediately after login, but store for PAM
            <literal>session</literal>.
          '';
        };
      };

      entries = mkOption {
        type = types.listOf pamEntry;
        description = "The PAM rules for this service";
      };
    };

    config = {
      name = mkDefault name;
      setLoginUid = mkDefault cfg.startSession;
      limits = mkDefault config.security.pam.loginLimits;

      # !!! TODO: move the LDAP stuff to the LDAP module, and the
      # Samba stuff to the Samba module.  This requires that the PAM
      # module provides the right hooks.
      entries = (
        # Account management
        [{
          entryType = "account"; control = "required"; path = "pam_unix.so";
        }] ++ (optional use_ldap {
          entryType = "account"; control = "sufficient"; path = "${pam_ldap}/lib/security/pam_ldap.so";
        }) ++ (optional config.services.sssd.enable {
          entryType = "account";
          control = if cfg.sssdStrictAccess then { default = "bad"; success = "ok"; user_unknown = "ignore"; } else "sufficient";
          path = "${pkgs.sssd}/lib/security/pam_sss.so";
        }) ++ (optional config.krb5.enable {
          entryType = "account"; control = "sufficient"; path = "${pam_krb5}/lib/security/pam_krb5.so";
        }) ++ (optionals cfg.googleOsLoginAccountVerification [{
          entryType = "account";
          control = { success = "ok"; ignore = "ignore"; default = "die"; };
          path = "${pkgs.google-compute-engine-oslogin}/lib/pam_oslogin_login.so";
        } {
          entryType = "account";
          control = { success = "ok"; default = "ignore"; };
          path = "${pkgs.google-compute-engine-oslogin}/lib/pam_oslogin_admin.so";
        }])
      ) ++ (
        # Authentication
        (optional cfg.googleOsLoginAuthentication {
          entryType = "auth";
          control = {success = "done";  perm_denied = "bad";  default = "ignore"; };
          path = "${pkgs.google-compute-engine-oslogin}/lib/pam_oslogin_login.so";
        }) ++ (optional cfg.rootOK {
          entryType = "auth"; control = "sufficient"; path = "pam_rootok.so";
        }) ++ (optional cfg.requireWheel {
          entryType = "auth"; control = "required"; path = "pam_wheel.so use_uid";
        }) ++ (optional cfg.logFailures {
          entryType = "auth"; control = "required"; path = "pam_tally.so";
        }) ++ (optional (config.security.pam.enableSSHAgentAuth && cfg.sshAgentAuth) {
          entryType = "auth";
          control = "sufficient";
          path = "${pkgs.pam_ssh_agent_auth}/libexec/pam_ssh_agent_auth.so";
          arguments = ["file=${lib.concatStringsSep ":" config.services.openssh.authorizedKeysFiles}"];
        }) ++ (optional cfg.fprintAuth {
          entryType = "auth"; control = "sufficient"; path = "${pkgs.fprintd}/lib/security/pam_fprintd.so";
        }) ++ (optional cfg.p11Auth {
          inherit (config.security.pam.p11) control;
          entryType = "auth";
          path = "${pkgs.pam_p11}/lib/security/pam_p11.so";
          arguments = [ "${pkgs.opensc}/lib/opensc-pkcs11.so" ];
        }) ++ (optional cfg.u2fAuth (let
          u2f = config.security.pam.u2f;
        in {
          inherit (u2f) control;
          entryType = "auth";
          path = "${pkgs.pam_u2f}/lib/security/pam_u2f.so";
          arguments = flatten [
            (optional u2f.debug "debug")
            (optional (u2f.authFile != null) "authfile=${u2f.authFile}")
            (optional u2f.interactive "interactive")
            (optional u2f.cue "cue")
            (optional (u2f.appId != null) "appid=${u2f.appId}")
          ];
        })) ++ (optional cfg.usbAuth {
          entryType = "auth"; control = "sufficient"; path = "${pkgs.pam_usb}/lib/security/pam_usb.so";
        }) ++ (optional cfg.oathAuth (let
          oath = config.security.pam.oath;
        in {
          entryType = "auth";
          control = "requisite";
          path = "${pkgs.oathToolkit}/lib/security/pam_oath.so";
          arguments = ["window=${toString oath.window}" "usersfile=${toString oath.usersFile}" "digits=${toString oath.digits}"];
        })) ++ (optional cfg.yubicoAuth (let
          yubi = config.security.pam.yubico;
        in {
          inherit (yubi) control;
          entryType = "auth";
          path = "${pkgs.yubico-pam}/lib/security/pam_yubico.so";
          arguments = flatten [
            [ "mode=${toString yubi.mode}" ]
            (optional (yubi.mode == "client") "id=${toString yubi.id}")
            (optional yubi.debug "debug")
          ];
        })) ++ (
          # Modules in this block require having the password set in PAM_AUTHTOK.
          # pam_unix is marked as 'sufficient' on NixOS which means nothing will run
          # after it succeeds. Certain modules need to run after pam_unix
          # prompts the user for password so we run it once with 'required' at an
          # earlier point and it will run again with 'sufficient' further down.
          # We use try_first_pass the second time to avoid prompting password twice
          (optionals (cfg.unixAuth && (
            config.security.pam.enableEcryptfs
            || cfg.pamMount
            || cfg.enableKwallet
            || cfg.enableGnomeKeyring
            || cfg.googleAuthenticator.enable
            || cfg.gnupg.enable
            || cfg.duoSecurity.enable
          )) (
            [{
              entryType = "auth"; control = "required"; path = "pam_unix.so";
              arguments = flatten [
                (optional cfg.allowNullPassword "nullok")
                (optionalString cfg.nodelay "nodelay")
                ["likeauth"]
              ];
            }] ++ (optional config.security.pam.enableEcryptfs {
              entryType = "auth"; control = "optional"; path = "${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so"; arguments = ["unwrap"];
            }) ++ (optional cfg.pamMount {
              entryType = "auth"; control = "optional"; path = "${pkgs.pam_mount}/lib/security/pam_mount.so";
            }) ++ (optional cfg.enableKwallet {
              entryType = "auth"; control = "optional"; path = "${pkgs.plasma5.kwallet-pam}/lib/security/pam_kwallet5.so";
              arguments = [ "kwalletd=${pkgs.kdeFrameworks.kwallet.bin}/bin/kwalletd5" ];
            }) ++ (optional cfg.enableGnomeKeyring {
              entryType = "auth"; control = "optional"; path = "${pkgs.gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so";
            }) ++ (optional cfg.gnupg.enable {
              entryType = "auth"; control = "optional"; path = "${pkgs.pam_gnupg}/lib/security/pam_gnupg.so";
              arguments = optional cfg.gnupg.storeOnly "store-only";
            }) ++ (optional cfg.googleAuthenticator.enable {
              entryType = "auth"; control = "required"; path = "${pkgs.googleAuthenticator}/lib/security/pam_google_authenticator.so";
              arguments = ["no_increment_hotp"];
            }) ++ (optional cfg.duoSecurity.enable {
              entryType = "auth"; control = "required"; path = "${pkgs.duo-unix}/lib/security/pam_duo.so";
            })
          )) ++ (optional cfg.unixAuth {
            entryType = "auth"; control = "sufficient"; path = "pam_unix.so";
            arguments = flatten [
              (optional cfg.allowNullPassword "nullok")
              (optional cfg.nodelay "nodelay")
              ["likeauth" "try_first_pass"]
            ];
          }) ++ (optional cfg.otpwAuth {
            entryType = "auth"; control = "sufficient"; path = "${pkgs.otpw}/lib/security/pam_otpw.so";
          }) ++ (optional use_ldap {
            entryType = "auth"; control = "sufficient"; path = "${pam_ldap}/lib/security/pam_ldap.so"; arguments = ["use_first_pass"];
          }) ++ (optional config.services.sssd.enable {
            entryType = "auth"; control = "sufficient"; path = "${pkgs.sssd}/lib/security/pam_sss.so"; arguments = ["use_first_pass"];
          }) ++ (optionals config.krb5.enable [{
            entryType = "auth";
            control = { default = "ignore"; success = 1; service_err = "reset"; };
            path = "${pam_krb5}/lib/security/pam_krb5.so";
            arguments = [ "use_first_pass" ];
          } {
            entryType = "auth"; control = { default = "die"; success = "done"; }; path = "${pam_ccreds}/lib/security/pam_ccreds.so action=validate";
            arguments = [ "use_first_pass" ];
          } {
            entryType = "auth"; control = "sufficient"; path = "${pam_ccreds}/lib/security/pam_ccreds.so action=store";
            arguments = [ "use_first_pass" ];
          }]) ++ [{
            entryType = "auth"; control = "required"; path = "pam_deny.so";
          }]
        )
      ) ++ (
        # Password management.
        [{
          entryType = "password"; control = "sufficient"; path = "pam_unix.so"; arguments = [ "nullok" "sha512" ];
        }] ++ (optional config.security.pam.enableEcryptfs {
          entryType = "password"; control = "optional"; path = "${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so";
        })
        ++ (optional cfg.pamMount {
          entryType = "password"; control = "optional"; path = "${pkgs.pam_mount}/lib/security/pam_mount.so";
        })
        ++ (optional use_ldap {
          entryType = "password"; control = "sufficient"; path = "${pam_ldap}/lib/security/pam_ldap.so";
        })
        ++ (optional config.services.sssd.enable {
          entryType = "password"; control = "sufficient"; path = "${pkgs.sssd}/lib/security/pam_sss.so"; arguments = ["use_authtok"];
        })
        ++ (optional config.krb5.enable {
          entryType = "password"; control = "sufficient"; path = "${pam_krb5}/lib/security/pam_krb5.so"; arguments = ["use_first_pass"];
        })
        ++ (optional cfg.enableGnomeKeyring {
          entryType = "password"; control = "optional"; path = "${pkgs.gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so"; arguments = ["use_authtok"];
        })
      ) ++ (
        # Session management.
        (optional cfg.setEnvironment {
          entryType = "session"; control = "required"; path = "pam_env.so";
          arguments = ["conffile=${config.system.build.pamEnvironment}" "readenv=0"];
        }) ++ [{
          entryType = "session"; control = "required"; path = "pam_unix.so";
        }] ++ (optional cfg.setLoginUid {
         entryType = "session"; control = if config.boot.isContainer then "optional" else "required"; path = "pam_loginuid.so";
        }) ++ (optional cfg.makeHomeDir {
          entryType = "session"; control = "required"; path = "${pkgs.pam}/lib/security/pam_mkhomedir.so";
          arguments = ["silent" "skel=${config.security.pam.makeHomeDir.skelDirectory}" "umask=0022"];
        }) ++ (optional cfg.updateWtmp {
          entryType = "session"; control = "required"; path = "${pkgs.pam}/lib/security/pam_lastlog.so"; arguments = [ "silent" ];
        }) ++ (optional config.security.pam.enableEcryptfs {
          entryType = "session"; control = "optional"; path = "${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so";
        }) ++ (optional cfg.pamMount {
          entryType = "session"; control = "optional"; path = "${pkgs.pam_mount}/lib/security/pam_mount.so";
        }) ++ (optional use_ldap {
          entryType = "session"; control = "optional"; path = "${pam_ldap}/lib/security/pam_ldap.so";
        }) ++ (optional config.services.sssd.enable {
          entryType = "session"; control = "optional"; path = "${pkgs.sssd}/lib/security/pam_sss.so";
        }) ++ (optional config.krb5.enable {
          entryType = "session"; control = "optional"; path = "${pam_krb5}/lib/security/pam_krb5.so";
        }) ++ (optional cfg.otpwAuth {
          entryType = "session"; control = "optional"; path = "${pkgs.otpw}/lib/security/pam_otpw.so";
        }) ++ (optional cfg.startSession {
          entryType = "session"; control = "optional"; path = "${pkgs.systemd}/lib/security/pam_systemd.so";
        }) ++ (optional cfg.forwardXAuth {
          entryType = "session"; control = "optional"; path = "pam_xauth.so"; arguments = ["xauthpath=${pkgs.xorg.xauth}/bin/xauth" "systemuser=99"];
        }) ++ (optional (cfg.limits != []) {
          entryType = "session"; control = "required"; path = "${pkgs.pam}/lib/security/pam_limits.so"; arguments = ["conf=${makeLimitsConf cfg.limits}"];
        }) ++ (optional (cfg.showMotd && config.users.motd != null) {
          entryType = "session"; control = "optional"; path = "${pkgs.pam}/lib/security/pam_motd.so"; arguments = ["motd=${motd}"];
        }) ++ (optional (cfg.enableAppArmor && config.security.apparmor.enable) {
          entryType = "session"; control = "optional"; path = "${pkgs.apparmor-pam}/lib/security/pam_apparmor.so"; arguments = ["order=user,group,default" "debug"];
        }) ++ (optional (cfg.enableKwallet) ({
          entryType = "session"; control = "optional"; path = "${pkgs.plasma5.kwallet-pam}/lib/security/pam_kwallet5.so";
          arguments = "kwalletd=${pkgs.kdeFrameworks.kwallet.bin}/bin/kwalletd5";
        })) ++ (optional (cfg.enableGnomeKeyring) {
          entryType = "session"; control = "optional"; path = "${pkgs.gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so"; arguments = ["auto_start"];
        }) ++ (optional cfg.gnupg.enable {
          entryType = "session"; control = "optional"; path = "${pkgs.pam_gnupg}/lib/security/pam_gnupg.so";
          arguments = optional cfg.gnupg.noAutostart "no-autostart";
        }) ++ (optional (config.virtualisation.lxc.lxcfs.enable) {
          entryType = "session"; control = "optional"; path = "${pkgs.lxc}/lib/security/pam_cgfs.so"; arguments = [ "-c all" ];
        })
      );
    };
  };

  inherit (pkgs) pam_krb5 pam_ccreds;

  use_ldap = (config.users.ldap.enable && config.users.ldap.loginPam);
  pam_ldap = if config.users.ldap.daemon.enable then pkgs.nss_pam_ldapd else pkgs.pam_ldap;

  # Create a limits.conf(5) file.
  makeLimitsConf = limits: pkgs.writeText "limits.conf" (
    concatMapStrings ({ domain, type, item, value }:
      "${domain} ${type} ${item} ${toString value}\n"
    ) limits
  );

  motd = pkgs.writeText "motd" config.users.motd;

  makePAMService = name: service: let
    argumentToString = value: if hasInfix " " value then "[${escape [ "]" ] value}]" else value;
    controlToString = value:
      if isString value then value
      else concatStringsSep " " (mapAttrsToList (name: value: "${name}=${toString value}") value);
    entryToString = { entryType, control, path, arguments}: concatStringsSep " " [
      entryType (controlToString control) path (concatMapStringsSep " " argumentToString arguments)
    ];
  in {
    name = "pam.d/${name}";
    value.source = pkgs.writeText "${name}.pam" (concatMapStringsSep "\n" entryToString service.entries);
  };
in {

  imports = [(mkRenamedOptionModule [ "security" "pam" "enableU2F" ] [ "security" "pam" "u2f" "enable" ])];

  ###### interface

  options = {
    security.pam.loginLimits = mkOption {
      default = [];
      example = [{
        domain = "ftp";
        type   = "hard";
        item   = "nproc";
        value  = "0";
      } {
        domain = "@student";
        type   = "-";
        item   = "maxlogins";
        value  = "4";
      }];

     description = ''
       Define resource limits that should apply to users or groups.
       Each item in the list should be an attribute set with a
       <varname>domain</varname>, <varname>type</varname>,
       <varname>item</varname>, and <varname>value</varname>
       attribute.  The syntax and semantics of these attributes
       must be that described in the limits.conf(5) man page.

       Note that these limits do not apply to systemd services,
       whose limits can be changed via <option>systemd.extraConfig</option>
       instead.
     '';
    };

    security.pam.services = mkOption {
      default = [];
      type = with types; attrsOf (submodule pamOpts);
      description = ''
        This option defines the PAM services.  A service typically
        corresponds to a program that uses PAM,
        e.g. <command>login</command> or <command>passwd</command>.
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
        directories newly created by <literal>pam_mkhomedir</literal>.
      '';
    };

    security.pam.enableSSHAgentAuth = mkOption {
      type = types.bool;
      default = false;
      description =
        ''
          Enable sudo logins if the user's SSH agent provides a key
          present in <filename>~/.ssh/authorized_keys</filename>.
          This allows machines to exclusively use SSH keys instead of
          passwords.
        '';
    };

    security.pam.enableOTPW = mkEnableOption "the OTPW (one-time password) PAM module";

    security.pam.p11 = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enables P11 PAM (<literal>pam_p11</literal>) module.

          If set, users can log in with SSH keys and PKCS#11 tokens.

          More information can be found <link
          xlink:href="https://github.com/OpenSC/pam_p11">here</link>.
        '';
      };

      control = mkOption {
        default = "sufficient";
        type = controlType;
        description = ''
          This option sets pam "control".
          If you want to have multi factor authentication, use "required".
          If you want to use the PKCS#11 device instead of the regular password,
          use "sufficient".

          Read
          <citerefentry>
            <refentrytitle>pam.conf</refentrytitle>
            <manvolnum>5</manvolnum>
          </citerefentry>
          for better understanding of this option.
        '';
      };
    };

    security.pam.u2f = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enables U2F PAM (<literal>pam-u2f</literal>) module.

          If set, users listed in
          <filename>$XDG_CONFIG_HOME/Yubico/u2f_keys</filename> (or
          <filename>$HOME/.config/Yubico/u2f_keys</filename> if XDG variable is
          not set) are able to log in with the associated U2F key. The path can
          be changed using <option>security.pam.u2f.authFile</option> option.

          File format is:
          <literal>username:first_keyHandle,first_public_key: second_keyHandle,second_public_key</literal>
          This file can be generated using <command>pamu2fcfg</command> command.

          More information can be found <link
          xlink:href="https://developers.yubico.com/pam-u2f/">here</link>.
        '';
      };

      authFile = mkOption {
        default = null;
        type = with types; nullOr path;
        description = ''
          By default <literal>pam-u2f</literal> module reads the keys from
          <filename>$XDG_CONFIG_HOME/Yubico/u2f_keys</filename> (or
          <filename>$HOME/.config/Yubico/u2f_keys</filename> if XDG variable is
          not set).

          If you want to change auth file locations or centralize database (for
          example use <filename>/etc/u2f-mappings</filename>) you can set this
          option.

          File format is:
          <literal>username:first_keyHandle,first_public_key: second_keyHandle,second_public_key</literal>
          This file can be generated using <command>pamu2fcfg</command> command.

          More information can be found <link
          xlink:href="https://developers.yubico.com/pam-u2f/">here</link>.
        '';
      };

      appId = mkOption {
        default = null;
        type = with types; nullOr str;
        description = ''
            By default <literal>pam-u2f</literal> module sets the application
            ID to <literal>pam://$HOSTNAME</literal>.

            When using <command>pamu2fcfg</command>, you can specify your
            application ID with the <literal>-i</literal> flag.

            More information can be found <link
            xlink:href="https://developers.yubico.com/pam-u2f/Manuals/pam_u2f.8.html">
            here</link>
        '';
      };

      control = mkOption {
        default = "sufficient";
        type = controlType;
        description = ''
          This option sets pam "control".
          If you want to have multi factor authentication, use "required".
          If you want to use U2F device instead of regular password, use "sufficient".

          Read
          <citerefentry>
            <refentrytitle>pam.conf</refentrytitle>
            <manvolnum>5</manvolnum>
          </citerefentry>
          for better understanding of this option.
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
          By default <literal>pam-u2f</literal> module does not inform user
          that he needs to use the u2f device, it just waits without a prompt.

          If you set this option to <literal>true</literal>,
          <literal>cue</literal> option is added to <literal>pam-u2f</literal>
          module and reminder message will be displayed.
        '';
      };
    };

    security.pam.yubico = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enables Yubico PAM (<literal>yubico-pam</literal>) module.

          If set, users listed in
          <filename>~/.yubico/authorized_yubikeys</filename>
          are able to log in with the associated Yubikey tokens.

          The file must have only one line:
          <literal>username:yubikey_token_id1:yubikey_token_id2</literal>
          More information can be found <link
          xlink:href="https://developers.yubico.com/yubico-pam/">here</link>.
        '';
      };
      control = mkOption {
        default = "sufficient";
        type = controlType;
        description = ''
          This option sets pam "control".
          If you want to have multi factor authentication, use "required".
          If you want to use Yubikey instead of regular password, use "sufficient".

          Read
          <citerefentry>
            <refentrytitle>pam.conf</refentrytitle>
            <manvolnum>5</manvolnum>
          </citerefentry>
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

          More information can be found <link
          xlink:href="https://developers.yubico.com/yubico-pam/Authentication_Using_Challenge-Response.html">here</link>.
        '';
      };
    };

    security.pam.enableEcryptfs = mkEnableOption "eCryptfs PAM module (mounting ecryptfs home directory on login)";

    users.motd = mkOption {
      default = null;
      example = "Today is Sweetmorn, the 4th day of The Aftermath in the YOLD 3178.";
      type = types.nullOr types.lines;
      description = "Message of the day shown to users when they log in.";
    };
  };


  ###### implementation

  config = {
    environment.systemPackages =
      # Include the PAM modules in the system path mostly for the manpages.
      [ pkgs.pam ]
      ++ optional config.users.ldap.enable pam_ldap
      ++ optional config.services.sssd.enable pkgs.sssd
      ++ optionals config.krb5.enable [pam_krb5 pam_ccreds]
      ++ optionals config.security.pam.enableOTPW [ pkgs.otpw ]
      ++ optionals config.security.pam.oath.enable [ pkgs.oathToolkit ]
      ++ optionals config.security.pam.p11.enable [ pkgs.pam_p11 ]
      ++ optionals config.security.pam.u2f.enable [ pkgs.pam_u2f ];

    boot.supportedFilesystems = optionals config.security.pam.enableEcryptfs [ "ecryptfs" ];

    security.wrappers = {
      unix_chkpwd = {
        source = "${pkgs.pam}/sbin/unix_chkpwd.orig";
        owner = "root";
        setuid = true;
      };
    };

    environment.etc = mapAttrs' makePAMService config.security.pam.services;

    security.pam.services = {
      other.entries = concatMap (entryType: [
        { inherit entryType; control = "required"; path = "pam_warn.so"; }
        { inherit entryType; control = "required"; path = "pam_deny.so"; }
      ]) [ "auth" "account" "password" "session" ];

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
    };
  };
}

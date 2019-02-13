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

      text = mkOption {
        type = types.nullOr types.lines;
        description = "Contents of the PAM service file.";
      };

    };

    config = {
      name = mkDefault name;
      setLoginUid = mkDefault cfg.startSession;
      limits = mkDefault config.security.pam.loginLimits;

      # !!! TODO: move the LDAP stuff to the LDAP module, and the
      # Samba stuff to the Samba module.  This requires that the PAM
      # module provides the right hooks.
      text = mkDefault
        (''
          # Account management.
          account required pam_unix.so
          ${optionalString use_ldap
              "account sufficient ${pam_ldap}/lib/security/pam_ldap.so"}
          ${optionalString (config.services.sssd.enable && cfg.sssdStrictAccess==false)
              "account sufficient ${pkgs.sssd}/lib/security/pam_sss.so"}
          ${optionalString (config.services.sssd.enable && cfg.sssdStrictAccess)
              "account [default=bad success=ok user_unknown=ignore] ${pkgs.sssd}/lib/security/pam_sss.so"}
          ${optionalString config.krb5.enable
              "account sufficient ${pam_krb5}/lib/security/pam_krb5.so"}
          ${optionalString cfg.googleOsLoginAccountVerification ''
            account [success=ok ignore=ignore default=die] ${pkgs.google-compute-engine-oslogin}/lib/pam_oslogin_login.so
            account [success=ok default=ignore] ${pkgs.google-compute-engine-oslogin}/lib/pam_oslogin_admin.so
          ''}

          # Authentication management.
          ${optionalString cfg.googleOsLoginAuthentication
              "auth [success=done perm_denied=bad default=ignore] ${pkgs.google-compute-engine-oslogin}/lib/pam_oslogin_login.so"}
          ${optionalString cfg.rootOK
              "auth sufficient pam_rootok.so"}
          ${optionalString cfg.requireWheel
              "auth required pam_wheel.so use_uid"}
          ${optionalString cfg.logFailures
              "auth required pam_tally.so"}
          ${optionalString (config.security.pam.enableSSHAgentAuth && cfg.sshAgentAuth)
              "auth sufficient ${pkgs.pam_ssh_agent_auth}/libexec/pam_ssh_agent_auth.so file=~/.ssh/authorized_keys:~/.ssh/authorized_keys2:/etc/ssh/authorized_keys.d/%u"}
          ${optionalString cfg.fprintAuth
              "auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so"}
          ${let u2f = config.security.pam.u2f; in optionalString cfg.u2fAuth
              "auth ${u2f.control} ${pkgs.pam_u2f}/lib/security/pam_u2f.so ${optionalString u2f.debug "debug"} ${optionalString (u2f.authFile != null) "authfile=${u2f.authFile}"} ${optionalString u2f.interactive "interactive"} ${optionalString u2f.cue "cue"}"}
          ${optionalString cfg.usbAuth
              "auth sufficient ${pkgs.pam_usb}/lib/security/pam_usb.so"}
          ${let oath = config.security.pam.oath; in optionalString cfg.oathAuth
              "auth requisite ${pkgs.oathToolkit}/lib/security/pam_oath.so window=${toString oath.window} usersfile=${toString oath.usersFile} digits=${toString oath.digits}"}
        '' +
          # Modules in this block require having the password set in PAM_AUTHTOK.
          # pam_unix is marked as 'sufficient' on NixOS which means nothing will run
          # after it succeeds. Certain modules need to run after pam_unix
          # prompts the user for password so we run it once with 'required' at an
          # earlier point and it will run again with 'sufficient' further down.
          # We use try_first_pass the second time to avoid prompting password twice
          (optionalString (cfg.unixAuth &&
          (config.security.pam.enableEcryptfs
            || cfg.pamMount
            || cfg.enableKwallet
            || cfg.enableGnomeKeyring
            || cfg.googleAuthenticator.enable)) ''
              auth required pam_unix.so ${optionalString cfg.allowNullPassword "nullok"} likeauth
              ${optionalString config.security.pam.enableEcryptfs
                "auth optional ${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so unwrap"}
              ${optionalString cfg.pamMount
                "auth optional ${pkgs.pam_mount}/lib/security/pam_mount.so"}
              ${optionalString cfg.enableKwallet
                ("auth optional ${pkgs.plasma5.kwallet-pam}/lib/security/pam_kwallet5.so" +
                 " kwalletd=${pkgs.libsForQt5.kwallet.bin}/bin/kwalletd5")}
              ${optionalString cfg.enableGnomeKeyring
                ("auth optional ${pkgs.gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so")}
              ${optionalString cfg.googleAuthenticator.enable
                  "auth required ${pkgs.googleAuthenticator}/lib/security/pam_google_authenticator.so no_increment_hotp"}
            '') + ''
          ${optionalString cfg.unixAuth
              "auth sufficient pam_unix.so ${optionalString cfg.allowNullPassword "nullok"} likeauth try_first_pass"}
          ${optionalString cfg.otpwAuth
              "auth sufficient ${pkgs.otpw}/lib/security/pam_otpw.so"}
          ${optionalString use_ldap
              "auth sufficient ${pam_ldap}/lib/security/pam_ldap.so use_first_pass"}
          ${optionalString config.services.sssd.enable
              "auth sufficient ${pkgs.sssd}/lib/security/pam_sss.so use_first_pass"}
          ${optionalString config.krb5.enable ''
            auth [default=ignore success=1 service_err=reset] ${pam_krb5}/lib/security/pam_krb5.so use_first_pass
            auth [default=die success=done] ${pam_ccreds}/lib/security/pam_ccreds.so action=validate use_first_pass
            auth sufficient ${pam_ccreds}/lib/security/pam_ccreds.so action=store use_first_pass
          ''}
          auth required pam_deny.so

          # Password management.
          password sufficient pam_unix.so nullok sha512
          ${optionalString config.security.pam.enableEcryptfs
              "password optional ${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so"}
          ${optionalString cfg.pamMount
              "password optional ${pkgs.pam_mount}/lib/security/pam_mount.so"}
          ${optionalString use_ldap
              "password sufficient ${pam_ldap}/lib/security/pam_ldap.so"}
          ${optionalString config.services.sssd.enable
              "password sufficient ${pkgs.sssd}/lib/security/pam_sss.so use_authtok"}
          ${optionalString config.krb5.enable
              "password sufficient ${pam_krb5}/lib/security/pam_krb5.so use_first_pass"}
          ${optionalString config.services.samba.syncPasswordsByPam
              "password optional ${pkgs.samba}/lib/security/pam_smbpass.so nullok use_authtok try_first_pass"}

          # Session management.
          ${optionalString cfg.setEnvironment ''
            session required pam_env.so envfile=${config.system.build.pamEnvironment}
          ''}
          session required pam_unix.so
          ${optionalString cfg.setLoginUid
              "session ${
                if config.boot.isContainer then "optional" else "required"
              } pam_loginuid.so"}
          ${optionalString cfg.makeHomeDir
              "session required ${pkgs.pam}/lib/security/pam_mkhomedir.so silent skel=${config.security.pam.makeHomeDir.skelDirectory} umask=0022"}
          ${optionalString cfg.updateWtmp
              "session required ${pkgs.pam}/lib/security/pam_lastlog.so silent"}
          ${optionalString config.security.pam.enableEcryptfs
              "session optional ${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so"}
          ${optionalString use_ldap
              "session optional ${pam_ldap}/lib/security/pam_ldap.so"}
          ${optionalString config.services.sssd.enable
              "session optional ${pkgs.sssd}/lib/security/pam_sss.so"}
          ${optionalString config.krb5.enable
              "session optional ${pam_krb5}/lib/security/pam_krb5.so"}
          ${optionalString cfg.otpwAuth
              "session optional ${pkgs.otpw}/lib/security/pam_otpw.so"}
          ${optionalString cfg.startSession
              "session optional ${pkgs.systemd}/lib/security/pam_systemd.so"}
          ${optionalString cfg.forwardXAuth
              "session optional pam_xauth.so xauthpath=${pkgs.xorg.xauth}/bin/xauth systemuser=99"}
          ${optionalString (cfg.limits != [])
              "session required ${pkgs.pam}/lib/security/pam_limits.so conf=${makeLimitsConf cfg.limits}"}
          ${optionalString (cfg.showMotd && config.users.motd != null)
              "session optional ${pkgs.pam}/lib/security/pam_motd.so motd=${motd}"}
          ${optionalString cfg.pamMount
              "session optional ${pkgs.pam_mount}/lib/security/pam_mount.so"}
          ${optionalString (cfg.enableAppArmor && config.security.apparmor.enable)
              "session optional ${pkgs.apparmor-pam}/lib/security/pam_apparmor.so order=user,group,default debug"}
          ${optionalString (cfg.enableKwallet)
              ("session optional ${pkgs.plasma5.kwallet-pam}/lib/security/pam_kwallet5.so" +
               " kwalletd=${pkgs.libsForQt5.kwallet.bin}/bin/kwalletd5")}
          ${optionalString (cfg.enableGnomeKeyring)
              "session optional ${pkgs.gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start"}
          ${optionalString (config.virtualisation.lxc.lxcfs.enable)
               "session optional ${pkgs.lxc}/lib/security/pam_cgfs.so -c all"}
        '');
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

  motd = pkgs.writeText "motd" config.users.motd;

  makePAMService = pamService:
    { source = pkgs.writeText "${pamService.name}.pam" pamService.text;
      target = "pam.d/${pamService.name}";
    };

in

{

  ###### interface

  options = {

    security.pam.loginLimits = mkOption {
      default = [];
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

     description =
       '' Define resource limits that should apply to users or groups.
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
      type = with types; loaOf (submodule pamOpts);
      description =
        ''
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
      default = false;
      description =
        ''
          Enable sudo logins if the user's SSH agent provides a key
          present in <filename>~/.ssh/authorized_keys</filename>.
          This allows machines to exclusively use SSH keys instead of
          passwords.
        '';
    };

    security.pam.enableOTPW = mkOption {
      default = false;
      description = ''
        Enable the OTPW (one-time password) PAM module.
      '';
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

      control = mkOption {
        default = "sufficient";
        type = types.enum [ "required" "requisite" "sufficient" "optional" ];
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

    security.pam.enableEcryptfs = mkOption {
      default = false;
      description = ''
        Enable eCryptfs PAM module (mounting ecryptfs home directory on login).
      '';
    };

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
      ++ optionals config.security.pam.u2f.enable [ pkgs.pam_u2f ];

    boot.supportedFilesystems = optionals config.security.pam.enableEcryptfs [ "ecryptfs" ];

    security.wrappers = {
      unix_chkpwd = {
        source = "${pkgs.pam}/sbin/unix_chkpwd.orig";
        owner = "root";
        setuid = true;
      };
    };

    environment.etc =
      mapAttrsToList (n: v: makePAMService v) config.security.pam.services;

    systemd.tmpfiles.rules = optionals
      (any (s: s.updateWtmp) (attrValues config.security.pam.services))
      [
        "f /var/log/wtmp"
        "f /var/log/lastlog"
      ];

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
        cups = {};
        ftp = {};
        i3lock = {};
        i3lock-color = {};
        screen = {};
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

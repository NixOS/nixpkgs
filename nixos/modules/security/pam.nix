# This module provides configuration for the PAM (Pluggable
# Authentication Modules) system.

{config, pkgs, ...}:

with pkgs.lib;

let

  pamOpts = args: {

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

      updateWtmp = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to update <filename>/var/log/wtmp</filename>.";
      };

      text = mkOption {
        type = types.nullOr types.lines;
        description = "Contents of the PAM service file.";
      };

    };

    config = let cfg = args.config; in {
      name = mkDefault args.name;
      setLoginUid = mkDefault cfg.startSession;
      limits = mkDefault config.security.pam.loginLimits;

      # !!! TODO: move the LDAP stuff to the LDAP module, and the
      # Samba stuff to the Samba module.  This requires that the PAM
      # module provides the right hooks.
      text = mkDefault
        ''
          # Account management.
          account sufficient pam_unix.so
          ${optionalString config.users.ldap.enable
              "account sufficient ${pam_ldap}/lib/security/pam_ldap.so"}
          ${optionalString config.krb5.enable
              "account sufficient ${pam_krb5}/lib/security/pam_krb5.so"}

          # Authentication management.
          ${optionalString cfg.rootOK
              "auth sufficient pam_rootok.so"}
          ${optionalString (config.security.pam.enableSSHAgentAuth && cfg.sshAgentAuth)
              "auth sufficient ${pkgs.pam_ssh_agent_auth}/libexec/pam_ssh_agent_auth.so file=~/.ssh/authorized_keys:~/.ssh/authorized_keys2:/etc/ssh/authorized_keys.d/%u"}
          ${optionalString cfg.usbAuth
              "auth sufficient ${pkgs.pam_usb}/lib/security/pam_usb.so"}
          ${optionalString cfg.unixAuth
              "auth sufficient pam_unix.so ${optionalString cfg.allowNullPassword "nullok"} likeauth"}
          ${optionalString cfg.otpwAuth
              "auth sufficient ${pkgs.otpw}/lib/security/pam_otpw.so"}
          ${optionalString config.users.ldap.enable
              "auth sufficient ${pam_ldap}/lib/security/pam_ldap.so use_first_pass"}
          ${optionalString config.krb5.enable ''
            auth [default=ignore success=1 service_err=reset] ${pam_krb5}/lib/security/pam_krb5.so use_first_pass
            auth [default=die success=done] ${pam_ccreds}/lib/security/pam_ccreds.so action=validate use_first_pass
            auth sufficient ${pam_ccreds}/lib/security/pam_ccreds.so action=store use_first_pass
          ''}
          auth required   pam_deny.so

          # Password management.
          password requisite pam_unix.so nullok sha512
          ${optionalString config.users.ldap.enable
              "password sufficient ${pam_ldap}/lib/security/pam_ldap.so"}
          ${optionalString config.krb5.enable
              "password sufficient ${pam_krb5}/lib/security/pam_krb5.so use_first_pass"}
          ${optionalString config.services.samba.syncPasswordsByPam
              "password optional ${pkgs.samba}/lib/security/pam_smbpass.so nullok use_authtok try_first_pass"}

          # Session management.
          session required pam_unix.so
          ${optionalString cfg.updateWtmp
              "session required ${pkgs.pam}/lib/security/pam_lastlog.so silent"}
          ${optionalString config.users.ldap.enable
              "session optional ${pam_ldap}/lib/security/pam_ldap.so"}
          ${optionalString config.krb5.enable
              "session optional ${pam_krb5}/lib/security/pam_krb5.so"}
          ${optionalString cfg.otpwAuth
              "session optional ${pkgs.otpw}/lib/security/pam_otpw.so"}
          ${optionalString cfg.startSession
              "session optional ${pkgs.systemd}/lib/security/pam_systemd.so"}
          ${optionalString cfg.setLoginUid
              "session required pam_loginuid.so"}
          ${optionalString cfg.forwardXAuth
              "session optional pam_xauth.so xauthpath=${pkgs.xorg.xauth}/bin/xauth systemuser=99"}
          ${optionalString (cfg.limits != [])
              "session required ${pkgs.pam}/lib/security/pam_limits.so conf=${makeLimitsConf cfg.limits}"}
          ${optionalString (cfg.showMotd && config.users.motd != null)
              "session optional ${pkgs.pam}/lib/security/pam_motd.so motd=${motd}"}
        '';
    };

  };


  inherit (pkgs) pam_krb5 pam_ccreds;

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
       '';
    };

    security.pam.services = mkOption {
      default = [];
      type = types.loaOf types.optionSet;
      options = [ pamOpts ];
      description =
        ''
          This option defines the PAM services.  A service typically
          corresponds to a program that uses PAM,
          e.g. <command>login</command> or <command>passwd</command>.
          Each attribute of this set defines a PAM service, with the attribute name
          defining the name of the service.
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

    users.motd = mkOption {
      default = null;
      example = "Today is Sweetmorn, the 4th day of The Aftermath in the YOLD 3178.";
      type = types.nullOr types.string;
      description = "Message of the day shown to users when they log in.";
    };

  };


  ###### implementation

  config = {

    environment.systemPackages =
      # Include the PAM modules in the system path mostly for the manpages.
      [ pkgs.pam ]
      ++ optional config.users.ldap.enable pam_ldap
      ++ optionals config.krb5.enable [pam_krb5 pam_ccreds]
      ++ optionals config.security.pam.enableOTPW [ pkgs.otpw ];

    environment.etc =
      mapAttrsToList (n: v: makePAMService v) config.security.pam.services;

    security.setuidOwners = [ {
      program = "unix_chkpwd";
      source = "${pkgs.pam}/sbin/unix_chkpwd.orig";
      owner = "root";
      setuid = true;
    } ];

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
        screen = {};
        vlock = {};
        xlock = {};
        xscreensaver = {};
      };

  };

}

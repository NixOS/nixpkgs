# This module provides configuration for the PAM (Pluggable
# Authentication Modules) system.

{config, pkgs, ...}:

with pkgs.lib;

let

  inherit (pkgs) pam_krb5 pam_ccreds;

  pam_ldap = if config.users.ldap.daemon.enable then pkgs.nss_pam_ldapd else pkgs.pam_ldap;

  otherService = pkgs.writeText "other.pam"
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

  # Create a limits.conf(5) file.
  makeLimitsConf = limits:
    pkgs.writeText "limits.conf"
      (concatStringsSep "\n"
           (map ({ domain, type, item, value }:
                 concatStringsSep " " [ domain type item value ])
                limits));

  motd = pkgs.writeText "motd" config.users.motd;

  makePAMService =
    { name
    , # If set, root doesn't need to authenticate (e.g. for the "chsh"
      # service).
      rootOK ? false
    , # If set, user listed in /etc/pamusb.conf are able to log in with
      # the associated usb key.
      usbAuth ? config.security.pam.usb.enable
    , # If set, the calling user's SSH agent is used to authenticate
      # against the keys in the calling user's ~/.ssh/authorized_keys.
      # This is useful for "sudo" on password-less remote systems.
      sshAgentAuth ? false
    , # If set, the service will register a new session with systemd's
      # login manager.  If the service is running locally, this will
      # give the user ownership of audio devices etc.
      startSession ? false
    , # Whether to forward XAuth keys between users.  Mostly useful
      # for "su".
      forwardXAuth ? false
    , # Whether to allow logging into accounts that have no password
      # set (i.e., have an empty password field in /etc/passwd or
      # /etc/group).  This does not enable logging into disabled
      # accounts (i.e., that have the password field set to `!').
      # Note that regardless of what the pam_unix documentation says,
      # accounts with hashed empty passwords are always allowed to log
      # in.
      allowNullPassword ? false
    , # The limits, as per limits.conf(5).
      limits ? config.security.pam.loginLimits
    , # Whether to show the message of the day.
      showMotd ? false
    }:

    { source = pkgs.writeText "${name}.pam"
        # !!! TODO: move the LDAP stuff to the LDAP module, and the
        # Samba stuff to the Samba module.  This requires that the PAM
        # module provides the right hooks.
        ''
          # Account management.
          account sufficient pam_unix.so
          ${optionalString config.users.ldap.enable
              "account sufficient ${pam_ldap}/lib/security/pam_ldap.so"}
          ${optionalString config.krb5.enable
              "account sufficient ${pam_krb5}/lib/security/pam_krb5.so"}

          # Authentication management.
          ${optionalString rootOK
              "auth sufficient pam_rootok.so"}
          ${optionalString (config.security.pam.enableSSHAgentAuth && sshAgentAuth)
              "auth sufficient ${pkgs.pam_ssh_agent_auth}/libexec/pam_ssh_agent_auth.so file=~/.ssh/authorized_keys:~/.ssh/authorized_keys2:/etc/ssh/authorized_keys.d/%u"}
          ${optionalString usbAuth
              "auth sufficient ${pkgs.pam_usb}/lib/security/pam_usb.so"}
          auth sufficient pam_unix.so ${optionalString allowNullPassword "nullok"} likeauth
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
          ${optionalString config.users.ldap.enable
              "session optional ${pam_ldap}/lib/security/pam_ldap.so"}
          ${optionalString config.krb5.enable
              "session optional ${pam_krb5}/lib/security/pam_krb5.so"}
          ${optionalString startSession
              "session optional ${pkgs.systemd}/lib/security/pam_systemd.so"}
          ${optionalString forwardXAuth
              "session optional pam_xauth.so xauthpath=${pkgs.xorg.xauth}/bin/xauth systemuser=99"}
          ${optionalString (limits != [])
              "session required ${pkgs.pam}/lib/security/pam_limits.so conf=${makeLimitsConf limits}"}
          ${optionalString (showMotd && config.users.motd != null)
              "session optional ${pkgs.pam}/lib/security/pam_motd.so motd=${motd}"}
        '';
      target = "pam.d/${name}";
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
      example = [
        { name = "chsh"; rootOK = true; }
        { name = "login"; startSession = true; allowNullPassword = true;
          limits = [
            { domain = "ftp";
              type   = "hard";
              item   = "nproc";
              value  = "0";
            }
          ];
        }
      ];

      description =
        ''
          This option defines the PAM services.  A service typically
          corresponds to a program that uses PAM,
          e.g. <command>login</command> or <command>passwd</command>.
          Each element of this list is an attribute set describing a
          service.  The attribute <varname>name</varname> specifies
          the name of the service.  The attribute
          <varname>rootOK</varname> specifies whether the root user is
          allowed to use this service without authentication.  The
          attribute <varname>startSession</varname> specifies whether
          systemd's PAM connector module should be used to start a new
          session; for local sessions, this will give the user
          ownership of devices such as audio and CD-ROM drives.  The
          attribute <varname>forwardXAuth</varname> specifies whether
          X authentication keys should be passed from the calling user
          to the target user (e.g. for <command>su</command>).

          The attribute <varname>limits</varname> defines resource limits
          that should apply to users or groups for the service.  Each item in
          the list should be an attribute set with a
          <varname>domain</varname>, <varname>type</varname>,
          <varname>item</varname>, and <varname>value</varname> attribute.
          The syntax and semantics of these attributes must be that described
          in the limits.conf(5) man page.
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
      ++ optional config.krb5.enable [pam_krb5 pam_ccreds];

    environment.etc =
      map makePAMService config.security.pam.services
      ++ singleton
        { source = otherService;
          target = "pam.d/other";
        };

    security.setuidOwners = [ {
      program = "unix_chkpwd";
      source = "${pkgs.pam}/sbin/unix_chkpwd.orig";
      owner = "root";
      setuid = true;
    } ];

    security.pam.services =
      # Most of these should be moved to specific modules.
      [ { name = "cups"; }
        { name = "ejabberd"; }
        { name = "ftp"; }
        { name = "i3lock"; }
        { name = "lshd"; }
        { name = "samba"; }
        { name = "screen"; }
        { name = "vlock"; }
        { name = "xlock"; }
        { name = "xscreensaver"; }
      ];

  };

}

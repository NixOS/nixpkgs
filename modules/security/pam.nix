# This module provides configuration for the PAM (Pluggable
# Authentication Modules) system.

{config, pkgs, ...}:

with pkgs.lib;

let

  inherit (pkgs) pam_usb pam_ldap;

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

  makePAMService =
    { name
    , # If set, root doesn't need to authenticate (e.g. for the "chsh"
      # service).
      rootOK ? false
    , # If set, user listed in /etc/pamusb.conf are able to log in with
      # the associated usb key.
      usbAuth ? config.security.pam.usb.enable
    , # If set, use ConsoleKit's PAM connector module to claim
      # ownership of audio devices etc.
      ownDevices ? false
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
      limits ? []
    }:

    { source = pkgs.writeText "${name}.pam"
        # !!! TODO: move the LDAP stuff to the LDAP module, and the
        # Samba stuff to the Samba module.  This requires that the PAM
        # module provides the right hooks.
        ''
          # Account management.
          ${optionalString config.users.ldap.enable
              "account optional ${pam_ldap}/lib/security/pam_ldap.so"}
          account required pam_unix.so

          # Authentication management.
          ${optionalString rootOK
              "auth sufficient pam_rootok.so"}
          ${optionalString usbAuth
              "auth sufficient ${pam_usb}/lib/security/pam_usb.so"}
          ${optionalString config.users.ldap.enable
              "auth sufficient ${pam_ldap}/lib/security/pam_ldap.so"}
          auth sufficient pam_unix.so ${
            optionalString allowNullPassword "nullok"}
          auth required   pam_deny.so

          # Password management.
          ${optionalString config.users.ldap.enable
              "password sufficient ${pam_ldap}/lib/security/pam_ldap.so"}
          password requisite pam_unix.so nullok sha512
          ${optionalString config.services.samba.syncPasswordsByPam
              "password optional ${pkgs.samba}/lib/security/pam_smbpass.so nullok use_authtok try_first_pass"}

          # Session management.
          ${optionalString config.users.ldap.enable
              "session optional ${pam_ldap}/lib/security/pam_ldap.so"}
          session required pam_unix.so
          ${optionalString ownDevices
              "session optional ${pkgs.consolekit}/lib/security/pam_ck_connector.so"}
          ${optionalString forwardXAuth
              "session optional pam_xauth.so xauthpath=${pkgs.xorg.xauth}/bin/xauth systemuser=99"}
          ${optionalString (limits != [])
              "session required ${pkgs.pam}/lib/security/pam_limits.so conf=${makeLimitsConf limits}"}
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
       '' Define resource limits that should apply to users or groups for the
          <command>login</command> service.  Each item in the list should be
          an attribute set with a <varname>domain</varname>,
          <varname>type</varname>, <varname>item</varname>, and
          <varname>value</varname> attribute.  The syntax and semantics of
          these attributes must be that described in the limits.conf(5) man
          page.
       '';
    };

    security.pam.services = mkOption {
      default = [];
      example = [
        { name = "chsh"; rootOK = true; }
        { name = "login"; ownDevices = true; allowNullPassword = true;
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
          attribute <varname>ownDevices</varname> specifies whether
          ConsoleKit's PAM connector module should be used to give the
          user ownership of devices such as audio and CD-ROM drives.
          The attribute <varname>forwardXAuth</varname> specifies
          whether X authentication keys should be passed from the
          calling user to the target user (e.g. for
          <command>su</command>).

          The attribute <varname>limits</varname> defines resource limits
          that should apply to users or groups for the service.  Each item in
          the list should be an attribute set with a
          <varname>domain</varname>, <varname>type</varname>,
          <varname>item</varname>, and <varname>value</varname> attribute.
          The syntax and semantics of these attributes must be that described
          in the limits.conf(5) man page.
        '';
    };

  };


  ###### implementation

  config = {
  
    environment.systemPackages =
      # Include the PAM modules in the system path mostly for the manpages.
      [ pkgs.pam ]
      ++ optional config.users.ldap.enable pam_ldap;

    environment.etc =
      map makePAMService config.security.pam.services
      ++ singleton
        { source = otherService;
          target = "pam.d/other";
        };

    security.pam.services =
      # Most of these should be moved to specific modules.
      [ { name = "cups"; }
        { name = "ejabberd"; }
        { name = "ftp"; }
        { name = "lshd"; }
        { name = "samba"; }
        { name = "sshd"; }
        { name = "xlock"; }
      ];

  };
  
}

# This module provides configuration for the PAM (Pluggable
# Authentication Modules) system.

{config, pkgs, ...}:

with pkgs.lib;

let

  inherit (pkgs) pam_unix2 pam_console pam_ldap;

  # !!! ugh, these files shouldn't be created here.
  pamConsoleHandlers = pkgs.writeText "console.handlers" ''
    console consoledevs /dev/tty[0-9][0-9]* :[0-9]\.[0-9] :[0-9]
    ${pkgs.pam_console}/sbin/pam_console_apply lock logfail wait -t tty -s -c ${pamConsolePerms}
    ${pkgs.pam_console}/sbin/pam_console_apply unlock logfail wait -r -t tty -s -c ${pamConsolePerms}
  '';

  pamConsolePerms = ./console.perms;

  makePAMService =
    { name
    , # If set, root doesn't need to authenticate (e.g. for the "chsh"
      # service).
      rootOK ? false
    , # If set, this is a local login (e.g. virtual console or X), so
      # the user gets ownership of audio devices etc.
      localLogin ? false
    , # Whether to forward XAuth keys between users.  Mostly useful
      # for "su".
      forwardXAuth ? false
    }:

    { source = pkgs.writeText "${name}.pam"
        # !!! TODO: move the LDAP stuff to the LDAP module, and the
        # Samba stuff to the Samba module.  This requires that the PAM
        # module provides the right hooks.
        ''
          # Account management.
          ${optionalString config.users.ldap.enable
              "account optional ${pam_ldap}/lib/security/pam_ldap.so"}
          account required ${pam_unix2}/lib/security/pam_unix2.so

          # Authentication management.
          ${optionalString rootOK
              "auth sufficient pam_rootok.so"}
          ${optionalString config.users.ldap.enable
              "auth sufficient ${pam_ldap}/lib/security/pam_ldap.so"}
          auth sufficient ${pam_unix2}/lib/security/pam_unix2.so
          auth required   pam_deny.so

          # Password management.
          ${optionalString config.users.ldap.enable
              "password sufficient ${pam_ldap}/lib/security/pam_ldap.so"}
          password requisite ${pam_unix2}/lib/security/pam_unix2.so nullok
          ${optionalString config.services.samba.syncPasswordsByPam
              "password optional ${pkgs.samba}/lib/security/pam_smbpass.so nullok use_authtok try_first_pass"}

          # Session management.
          ${optionalString config.users.ldap.enable
              "session optional ${pam_ldap}/lib/security/pam_ldap.so"}
          session required ${pam_unix2}/lib/security/pam_unix2.so
          ${optionalString localLogin
              "session optional ${pam_console}/lib/security/pam_console.so debug handlersfile=${pamConsoleHandlers}"}
          ${optionalString forwardXAuth
              "session optional pam_xauth.so xauthpath=${pkgs.xorg.xauth}/bin/xauth systemuser=99"}
        '';
      target = "pam.d/${name}";
    };

in

{

  ###### interface

  options = {

    security.pam.services = mkOption {
      default = [];
      example = [ { name = "chsh"; rootOK = true; } ];
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
          attribute <varname>localLogin</varname> specifies whether
          this is a local login service (e.g. <command>xdm</command>),
          which implies that the user gets ownership of devices such
          as audio and CD-ROM drives.  The
          attribute <varname>forwardXAuth</varname> specifies whether
          X authentication keys should be passed from the calling user
          to the target user (e.g. for <command>su</command>).
        '';
    };

  };


  ###### implementation

  config = {
  
    environment.systemPackages =
      # Include the PAM modules in the system path mostly for the manpages.
      [ pkgs.pam pam_unix2 ]
      ++ optional config.users.ldap.enable pam_ldap;

    environment.etc = map makePAMService config.security.pam.services;

    security.pam.services =
      # Most of these should be moved to specific modules.
      [ { name = "cups"; }
        { name = "ejabberd"; }
        { name = "ftp"; }
        { name = "lshd"; }
        { name = "passwd"; }
        { name = "samba"; }
        { name = "sshd"; }
        { name = "xlock"; }
        { name = "chsh"; rootOK = true; }
        { name = "su"; rootOK = true; forwardXAuth = true; }
        # Note: useradd, groupadd etc. aren't setuid root, so it
        # doesn't really matter what the PAM config says as long as it
        # lets root in.
        { name = "useradd"; rootOK = true; }
        # Used by groupadd etc.
        { name = "shadow"; rootOK = true; }
        { name = "login"; localLogin = true; }
      ];

  };
  
}

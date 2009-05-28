# This module provides configuration for the PAM (Pluggable
# Authentication Modules) system.

{config, pkgs, ...}:

let

  # !!! ugh, these files shouldn't be created here.
  pamConsoleHandlers = pkgs.writeText "console.handlers" ''
    console consoledevs /dev/tty[0-9][0-9]* :[0-9]\.[0-9] :[0-9]
    ${pkgs.pam_console}/sbin/pam_console_apply lock logfail wait -t tty -s -c ${pamConsolePerms}
    ${pkgs.pam_console}/sbin/pam_console_apply unlock logfail wait -r -t tty -s -c ${pamConsolePerms}
  '';

  pamConsolePerms = ./console.perms;

  generatePAMConfig = program:
    let isLDAPEnabled = config.users.ldap.enable; in
    { source = pkgs.substituteAll {
        src = ./pam.d + ("/" + program);
        inherit (pkgs) pam_unix2 pam_console;
        pam_ldap =
          if isLDAPEnabled
          then pkgs.pam_ldap
          else "/no-such-path";
        inherit (pkgs.xorg) xauth;
        inherit pamConsoleHandlers;
        isLDAPEnabled = if isLDAPEnabled then "" else "#";
        syncSambaPasswords = if config.services.samba.syncPasswordsByPam
          then "password   optional     ${pkgs.samba}/lib/security/pam_smbpass.so nullok use_authtok try_first_pass"
          else "# change samba configuration options to make passwd sync the samba auth database as well here..";
      };
      target = "pam.d/" + program;
    };

in

{
  environment.etc =  map generatePAMConfig 
    [ "login"
      "su"
      "other"
      "passwd"
      "shadow"
      "sshd"
      "lshd"
      "useradd"
      "chsh"
      "xlock"
      "samba"
      "cups"
      "ftp"
      "ejabberd"
      "common"
      "common-console" # shared stuff for interactive local sessions
    ];
}

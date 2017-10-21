# Configuration for `ssmtp', a trivial mail transfer agent that can
# replace sendmail/postfix on simple systems.  It delivers email
# directly to an SMTP server defined in its configuration file, wihout
# queueing mail locally.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.networking.defaultMailServer;

in

{

  options = {

    networking.defaultMailServer = {

      directDelivery = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Use the trivial Mail Transfer Agent (MTA)
          <command>ssmtp</command> package to allow programs to send
          e-mail.  If you don't want to run a “real” MTA like
          <command>sendmail</command> or <command>postfix</command> on
          your machine, set this option to <literal>true</literal>, and
          set the option
          <option>networking.defaultMailServer.hostName</option> to the
          host name of your preferred mail server.
        '';
      };

      hostName = mkOption {
        type = types.str;
        example = "mail.example.org";
        description = ''
          The host name of the default mail server to use to deliver
          e-mail. Can also contain a port number (ex: mail.example.org:587),
          defaults to port 25 if no port is given.
        '';
      };

      root = mkOption {
        type = types.str;
        default = "";
        example = "root@example.org";
        description = ''
          The e-mail to which mail for users with UID &lt; 1000 is forwarded.
        '';
      };

      domain = mkOption {
        type = types.str;
        default = "";
        example = "example.org";
        description = ''
          The domain from which mail will appear to be sent.
        '';
      };

      useTLS = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether TLS should be used to connect to the default mail
          server.
        '';
      };

      useSTARTTLS = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether the STARTTLS should be used to connect to the default
          mail server.  (This is needed for TLS-capable mail servers
          running on the default SMTP port 25.)
        '';
      };

      authUser = mkOption {
        type = types.str;
        default = "";
        example = "foo@example.org";
        description = ''
          Username used for SMTP auth. Leave blank to disable.
        '';
      };

      authPass = mkOption {
        type = types.str;
        default = "";
        example = "correctHorseBatteryStaple";
        description = ''
          Password used for SMTP auth. (STORED PLAIN TEXT, WORLD-READABLE IN NIX STORE)

          It's recommended to use <option>authPassFile</option>
          which takes precedence over <option>authPass</option>.
        '';
      };

      authPassFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/run/keys/ssmtp-authpass";
        description = ''
          Path to a file that contains the password used for SMTP auth. The file
          should not contain a trailing newline, if the password does not contain one.
          This file should be readable by the users that need to execute ssmtp.

          <option>authPassFile</option> takes precedence over <option>authPass</option>.

          Warning: when <option>authPass</option> is non-empty <option>authPassFile</option>
          defaults to a file in the WORLD-READABLE Nix store containing that password.
        '';
      };

      setSendmail = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to set the system sendmail to ssmtp's.";
      };

    };

  };


  config = mkIf cfg.directDelivery {

    networking.defaultMailServer.authPassFile = mkIf (cfg.authPass != "")
      (mkDefault (toString (pkgs.writeTextFile {
        name = "ssmtp-authpass";
        text = cfg.authPass;
      })));

    environment.etc."ssmtp/ssmtp.conf".text =
      let yesNo = yes : if yes then "YES" else "NO"; in
      ''
        MailHub=${cfg.hostName}
        FromLineOverride=YES
        ${optionalString (cfg.root   != "") "root=${cfg.root}"}
        ${optionalString (cfg.domain != "") "rewriteDomain=${cfg.domain}"}
        UseTLS=${yesNo cfg.useTLS}
        UseSTARTTLS=${yesNo cfg.useSTARTTLS}
        #Debug=YES
        ${optionalString (cfg.authUser != "")       "AuthUser=${cfg.authUser}"}
        ${optionalString (!isNull cfg.authPassFile) "AuthPassFile=${cfg.authPassFile}"}
      '';

    environment.systemPackages = [pkgs.ssmtp];

    services.mail.sendmailSetuidWrapper = mkIf cfg.setSendmail {
      program = "sendmail";
      source = "${pkgs.ssmtp}/bin/sendmail";
      setuid = false;
      setgid = false;
    };

  };

}

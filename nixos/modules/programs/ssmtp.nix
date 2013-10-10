# Configuration for `ssmtp', a trivial mail transfer agent that can
# replace sendmail/postfix on simple systems.  It delivers email
# directly to an SMTP server defined in its configuration file, wihout
# queueing mail locally.

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.networking.defaultMailServer;

in

{

  options = {

    networking.defaultMailServer = {

      directDelivery = mkOption {
        default = false;
        example = true;
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
        example = "mail.example.org";
        description = ''
          The host name of the default mail server to use to deliver
          e-mail.
        '';
      };

      domain = mkOption {
        default = "";
        example = "example.org";
        description = ''
          The domain from which mail will appear to be sent.
        '';
      };

      useTLS = mkOption {
        default = false;
        example = true;
        description = ''
          Whether TLS should be used to connect to the default mail
          server.
        '';
      };

      useSTARTTLS = mkOption {
        default = false;
        example = true;
        description = ''
          Whether the STARTTLS should be used to connect to the default
          mail server.  (This is needed for TLS-capable mail servers
          running on the default SMTP port 25.)
        '';
      };

      authUser = mkOption {
        default = "";
        example = "foo@example.org";
        description = ''
          Username used for SMTP auth. Leave blank to disable.
        '';
      };

      authPass = mkOption {
        default = "";
        example = "correctHorseBatteryStaple";
        description = ''
          Password used for SMTP auth. (STORED PLAIN TEXT, WORLD-READABLE IN NIX STORE)
        '';
      };

    };

  };


  config = mkIf cfg.directDelivery {

    environment.etc."ssmtp/ssmtp.conf".text =
      ''
        MailHub=${cfg.hostName}
        FromLineOverride=YES
        ${if cfg.domain != "" then "rewriteDomain=${cfg.domain}" else ""}
        UseTLS=${if cfg.useTLS then "YES" else "NO"}
        UseSTARTTLS=${if cfg.useSTARTTLS then "YES" else "NO"}
        #Debug=YES
        ${if cfg.authUser != "" then "AuthUser=${cfg.authUser}" else ""}
        ${if cfg.authPass != "" then "AuthPass=${cfg.authPass}" else ""}
      '';

    environment.systemPackages = [pkgs.ssmtp];

  };

}

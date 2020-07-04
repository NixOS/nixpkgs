# Configuration for `ssmtp', a trivial mail transfer agent that can
# replace sendmail/postfix on simple systems.  It delivers email
# directly to an SMTP server defined in its configuration file, wihout
# queueing mail locally.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ssmtp;

in
{

  imports = [
    (mkRenamedOptionModule [ "networking" "defaultMailServer" "directDelivery" ] [ "services" "ssmtp" "enable" ])
    (mkRenamedOptionModule [ "networking" "defaultMailServer" "hostName" ] [ "services" "ssmtp" "hostName" ])
    (mkRenamedOptionModule [ "networking" "defaultMailServer" "domain" ] [ "services" "ssmtp" "domain" ])
    (mkRenamedOptionModule [ "networking" "defaultMailServer" "root" ] [ "services" "ssmtp" "root" ])
    (mkRenamedOptionModule [ "networking" "defaultMailServer" "useTLS" ] [ "services" "ssmtp" "useTLS" ])
    (mkRenamedOptionModule [ "networking" "defaultMailServer" "useSTARTTLS" ] [ "services" "ssmtp" "useSTARTTLS" ])
    (mkRenamedOptionModule [ "networking" "defaultMailServer" "authUser" ] [ "services" "ssmtp" "authUser" ])
    (mkRenamedOptionModule [ "networking" "defaultMailServer" "authPassFile" ] [ "services" "ssmtp" "authPassFile" ])
    (mkRenamedOptionModule [ "networking" "defaultMailServer" "setSendmail" ] [ "services" "ssmtp" "setSendmail" ])

    (mkRemovedOptionModule [ "networking" "defaultMailServer" "authPass" ] "authPass has been removed since it leaks the clear-text password into the world-readable store. Use authPassFile instead and make sure it's not a store path")
    (mkRemovedOptionModule [ "services" "ssmtp" "authPass" ] "authPass has been removed since it leaks the clear-text password into the world-readable store. Use authPassFile instead and make sure it's not a store path")
  ];

  options = {

    services.ssmtp = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Use the trivial Mail Transfer Agent (MTA)
          <command>ssmtp</command> package to allow programs to send
          e-mail.  If you don't want to run a “real” MTA like
          <command>sendmail</command> or <command>postfix</command> on
          your machine, set this option to <literal>true</literal>, and
          set the option
          <option>services.ssmtp.hostName</option> to the
          host name of your preferred mail server.
        '';
      };

      settings = mkOption {
        type = with types; attrsOf (oneOf [ bool str ]);
        default = {};
        description = ''
          <citerefentry><refentrytitle>ssmtp</refentrytitle><manvolnum>5</manvolnum></citerefentry> configuration. Refer
          to <link xlink:href="https://linux.die.net/man/5/ssmtp.conf"/> for details on supported values.
        '';
        example = literalExample ''
          {
            Debug = true;
            FromLineOverride = false;
          }
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

      authPassFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/run/keys/ssmtp-authpass";
        description = ''
          Path to a file that contains the password used for SMTP auth. The file
          should not contain a trailing newline, if the password does not contain one.
          This file should be readable by the users that need to execute ssmtp.
        '';
      };

      setSendmail = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to set the system sendmail to ssmtp's.";
      };

    };

  };


  config = mkIf cfg.enable {

    services.ssmtp.settings = mkMerge [
      ({
        MailHub = cfg.hostName;
        FromLineOverride = mkDefault true;
        UseTLS = cfg.useTLS;
        UseSTARTTLS = cfg.useSTARTTLS;
      })
      (mkIf (cfg.root != "") { root = cfg.root; })
      (mkIf (cfg.domain != "") { rewriteDomain = cfg.domain; })
      (mkIf (cfg.authUser != "") { AuthUser = cfg.authUser; })
      (mkIf (cfg.authPassFile != null) { AuthPassFile = cfg.authPassFile; })
    ];

    environment.etc."ssmtp/ssmtp.conf".source =
      let
        toStr = value:
          if value == true then "YES"
          else if value == false then "NO"
          else builtins.toString value
        ;
      in
        pkgs.writeText "ssmtp.conf" (concatStringsSep "\n" (mapAttrsToList (key: value: "${key}=${toStr value}") cfg.settings));

    environment.systemPackages = [pkgs.ssmtp];

    services.mail.sendmailSetuidWrapper = mkIf cfg.setSendmail {
      program = "sendmail";
      source = "${pkgs.ssmtp}/bin/sendmail";
      setuid = false;
      setgid = false;
    };

  };

}

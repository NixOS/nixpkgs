{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    services.nullmailer = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable nullmailer daemon.";
      };

      user = mkOption {
        type = types.string;
        default = "nullmailer";
        description = ''
          User to use to run nullmailer-send.
        '';
      };

      group = mkOption {
        type = types.string;
        default = "nullmailer";
        description = ''
          Group to use to run nullmailer-send.
        '';
      };

      setSendmail = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to set the system sendmail to nullmailer's.";
      };

      config = {
        adminaddr = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            If set, all recipients to users at either "localhost" (the literal string)
            or the canonical host name (from the me control attribute) are remapped to this address.
            This is provided to allow local daemons to be able to send email to
            "somebody@localhost" and have it go somewhere sensible instead of being  bounced
            by your relay host. To send to multiple addresses,
            put them all on one line separated by a comma.
          '';
        };

        allmailfrom = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            If set, content will override the envelope sender on all messages.
          '';
        };

        defaultdomain = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
             The content of this attribute is appended to any host name that
             does not contain a period (except localhost), including defaulthost
             and idhost. Defaults to the value of the me attribute, if it exists,
             otherwise the literal name defauldomain.
          '';
        };

        defaulthost = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
             The content of this attribute is appended to any address that
             is missing a host name. Defaults to the value of the me control
             attribute, if it exists, otherwise the literal name defaulthost.
          '';
        };

        doublebounceto = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            If the original sender was empty (the original message was a
            delivery status or disposition notification), the double bounce
            is sent to the address in this attribute.
          '';
        };

        helohost = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Sets  the  environment variable $HELOHOST which is used by the
            SMTP protocol module to set the parameter given to the HELO command.
            Defaults to the value of the me configuration attribute.
          '';
        };

        idhost = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            The content of this attribute is used when building the message-id
            string for the message. Defaults to the canonicalized value of defaulthost.
          '';
        };

        maxpause = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
             The maximum time to pause between successive queue runs, in seconds.
             Defaults to 24 hours (86400).
          '';
        };

        me = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
             The fully-qualifiled host name of the computer running nullmailer.
             Defaults to the literal name me.
          '';
        };

        pausetime = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            The minimum time to pause between successive queue runs when there
            are messages in the queue, in seconds. Defaults to 1 minute (60).
            Each time this timeout is reached, the timeout is doubled to a
            maximum of maxpause. After new messages are injected, the timeout
            is reset.  If this is set to 0, nullmailer-send will exit
            immediately after going through the queue once (one-shot mode).
          '';
        };

        remotes = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            If set, content will override the envelope sender on all messages.
          '';
        };

        sendtimeout = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            The  time to wait for a remote module listed above to complete sending
            a message before killing it and trying again, in seconds.
            Defaults to 1 hour (3600).  If this is set to 0, nullmailer-send
            will wait forever for messages to complete sending.
          '';
        };
      };
    };
  };

  config = let
    cfg = config.services.nullmailer;
  in mkIf cfg.enable {

    environment = {
      systemPackages = [ pkgs.nullmailer ];
      etc = let
        getval  = attr: builtins.getAttr attr cfg.config;
        attrs   = builtins.attrNames cfg.config;
        attrs'  = builtins.filter (attr: ! isNull (getval attr)) attrs;
      in foldl' (as: attr: as // { "nullmailer/${attr}".text = getval attr; }) {} attrs';
    };

    users = {
      extraUsers = singleton {
        name = cfg.user;
        description = "Nullmailer relay-only mta user";
        group = cfg.group;
      };

      extraGroups = singleton {
        name = cfg.group;
      };
    };

    systemd.services.nullmailer = {
      description = "nullmailer";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        mkdir -p /var/spool/nullmailer/{queue,tmp}
        rm -f var/spool/nullmailer/trigger && mkfifo -m 660 /var/spool/nullmailer/trigger
        chown ${cfg.user} /var/spool/nullmailer/*
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly=true;
        ExecStart = "${pkgs.nullmailer}/bin/nullmailer-send";
        Restart = "always";
      };
    };

    services.mail.sendmailSetuidWrapper = mkIf cfg.setSendmail {
      program = "sendmail";
      source = "${pkgs.nullmailer}/bin/sendmail";
      owner = cfg.user;
      group = cfg.group;
      setuid = true;
      setgid = true;
    };
  };
}

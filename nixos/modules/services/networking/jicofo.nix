{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.jicofo;

  format = pkgs.formats.hocon { };

  configFile = format.generate "jicofo.conf" cfg.config;
in
{
  options.services.jicofo = with lib.types; {
    enable = lib.mkEnableOption "Jitsi Conference Focus - component of Jitsi Meet";

    xmppHost = lib.mkOption {
      type = str;
      example = "localhost";
      description = ''
        Hostname of the XMPP server to connect to.
      '';
    };

    xmppDomain = lib.mkOption {
      type = nullOr str;
      example = "meet.example.org";
      description = ''
        Domain name of the XMMP server to which to connect as a component.

        If null, {option}`xmppHost` is used.
      '';
    };

    componentPasswordFile = lib.mkOption {
      type = str;
      example = "/run/keys/jicofo-component";
      description = ''
        Path to file containing component secret.
      '';
    };

    userName = lib.mkOption {
      type = str;
      default = "focus";
      description = ''
        User part of the JID for XMPP user connection.
      '';
    };

    userDomain = lib.mkOption {
      type = str;
      example = "auth.meet.example.org";
      description = ''
        Domain part of the JID for XMPP user connection.
      '';
    };

    userPasswordFile = lib.mkOption {
      type = str;
      example = "/run/keys/jicofo-user";
      description = ''
        Path to file containing password for XMPP user connection.
      '';
    };

    bridgeMuc = lib.mkOption {
      type = str;
      example = "jvbbrewery@internal.meet.example.org";
      description = ''
        JID of the internal MUC used to communicate with Videobridges.
      '';
    };

    config = lib.mkOption {
      type = format.type;
      default = { };
      example = lib.literalExpression ''
        {
          jicofo.bridge.max-bridge-participants = 42;
        }
      '';
      description = ''
        Contents of the {file}`jicofo.conf` configuration file.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.jicofo.config = {
      jicofo = {
        bridge.brewery-jid = cfg.bridgeMuc;
        xmpp = rec {
          client = {
            hostname = cfg.xmppHost;
            username = cfg.userName;
            domain = cfg.userDomain;
            password = format.lib.mkSubstitution "JICOFO_AUTH_PASS";
            xmpp-domain = if cfg.xmppDomain == null then cfg.xmppHost else cfg.xmppDomain;
          };
          service = client;
        };
      };
    };

    users.groups.jitsi-meet = { };

    systemd.services.jicofo =
      let
        jicofoProps = {
          "-Dnet.java.sip.communicator.SC_HOME_DIR_LOCATION" = "/etc/jitsi";
          "-Dnet.java.sip.communicator.SC_HOME_DIR_NAME" = "jicofo";
          "-Djava.util.logging.config.file" = "/etc/jitsi/jicofo/logging.properties";
          "-Dconfig.file" = configFile;
        };
      in
      {
        description = "JItsi COnference FOcus";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        restartTriggers = [
          configFile
        ];
        environment.JAVA_SYS_PROPS = lib.concatStringsSep " " (
          lib.mapAttrsToList (k: v: "${k}=${toString v}") jicofoProps
        );

        script = ''
          export JICOFO_AUTH_PASS="$(<${cfg.userPasswordFile})"
          exec "${pkgs.jicofo}/bin/jicofo"
        '';

        serviceConfig = {
          Type = "exec";

          DynamicUser = true;
          User = "jicofo";
          Group = "jitsi-meet";

          CapabilityBoundingSet = "";
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectHostname = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          LockPersonality = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
        };
      };

    environment.etc."jitsi/jicofo/sip-communicator.properties".text = "";
    environment.etc."jitsi/jicofo/logging.properties".source =
      lib.mkDefault "${pkgs.jicofo}/etc/jitsi/jicofo/logging.properties-journal";
  };

  meta.maintainers = lib.teams.jitsi.members;
}

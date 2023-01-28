{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.jicofo;
in
{
  options.services.jicofo = with types; {
    enable = mkEnableOption (lib.mdDoc "Jitsi Conference Focus - component of Jitsi Meet");

    xmppHost = mkOption {
      type = str;
      example = "localhost";
      description = lib.mdDoc ''
        Hostname of the XMPP server to connect to.
      '';
    };

    xmppDomain = mkOption {
      type = nullOr str;
      example = "meet.example.org";
      description = lib.mdDoc ''
        Domain name of the XMMP server to which to connect as a component.

        If null, {option}`xmppHost` is used.
      '';
    };

    componentPasswordFile = mkOption {
      type = str;
      example = "/run/keys/jicofo-component";
      description = lib.mdDoc ''
        Path to file containing component secret.
      '';
    };

    userName = mkOption {
      type = str;
      default = "focus";
      description = lib.mdDoc ''
        User part of the JID for XMPP user connection.
      '';
    };

    userDomain = mkOption {
      type = str;
      example = "auth.meet.example.org";
      description = lib.mdDoc ''
        Domain part of the JID for XMPP user connection.
      '';
    };

    userPasswordFile = mkOption {
      type = str;
      example = "/run/keys/jicofo-user";
      description = lib.mdDoc ''
        Path to file containing password for XMPP user connection.
      '';
    };

    bridgeMuc = mkOption {
      type = str;
      example = "jvbbrewery@internal.meet.example.org";
      description = lib.mdDoc ''
        JID of the internal MUC used to communicate with Videobridges.
      '';
    };

    config = mkOption {
      type = attrsOf str;
      default = { };
      example = literalExpression ''
        {
          "org.jitsi.jicofo.auth.URL" = "XMPP:jitsi-meet.example.com";
        }
      '';
      description = lib.mdDoc ''
        Contents of the {file}`sip-communicator.properties` configuration file for jicofo.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.jicofo.config = mapAttrs (_: v: mkDefault v) {
      "org.jitsi.jicofo.BRIDGE_MUC" = cfg.bridgeMuc;
    };

    users.groups.jitsi-meet = {};

    systemd.services.jicofo = let
      jicofoProps = {
        "-Dnet.java.sip.communicator.SC_HOME_DIR_LOCATION" = "/etc/jitsi";
        "-Dnet.java.sip.communicator.SC_HOME_DIR_NAME" = "jicofo";
        "-Djava.util.logging.config.file" = "/etc/jitsi/jicofo/logging.properties";
      };
    in
    {
      description = "JItsi COnference FOcus";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      restartTriggers = [
        config.environment.etc."jitsi/jicofo/sip-communicator.properties".source
      ];
      environment.JAVA_SYS_PROPS = concatStringsSep " " (mapAttrsToList (k: v: "${k}=${toString v}") jicofoProps);

      script = ''
        ${pkgs.jicofo}/bin/jicofo \
          --host=${cfg.xmppHost} \
          --domain=${if cfg.xmppDomain == null then cfg.xmppHost else cfg.xmppDomain} \
          --secret=$(cat ${cfg.componentPasswordFile}) \
          --user_name=${cfg.userName} \
          --user_domain=${cfg.userDomain} \
          --user_password=$(cat ${cfg.userPasswordFile})
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
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };

    environment.etc."jitsi/jicofo/sip-communicator.properties".source =
      pkgs.writeText "sip-communicator.properties" (
        generators.toKeyValue {} cfg.config
      );
    environment.etc."jitsi/jicofo/logging.properties".source =
      mkDefault "${pkgs.jicofo}/etc/jitsi/jicofo/logging.properties-journal";
  };

  meta.maintainers = lib.teams.jitsi.members;
}

{ config, lib, pkgs, ... }:
let
  cfg = config.services.jigasi;
  homeDirName = "jigasi-home";
  stateDir = "/tmp";
  sipCommunicatorPropertiesFile = "${stateDir}/${homeDirName}/sip-communicator.properties";
  sipCommunicatorPropertiesFileUnsubstituted = "${pkgs.jigasi}/etc/jitsi/jigasi/sip-communicator.properties";
in
{
  options.services.jigasi = with lib.types; {
    enable = lib.mkEnableOption "Jitsi Gateway to SIP - component of Jitsi Meet";

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

        If null, <option>xmppHost</option> is used.
      '';
    };

    componentPasswordFile = lib.mkOption {
      type = str;
      example = "/run/keys/jigasi-component";
      description = ''
        Path to file containing component secret.
      '';
    };

    userName = lib.mkOption {
      type = str;
      default = "callcontrol";
      description = ''
        User part of the JID for XMPP user connection.
      '';
    };

    userDomain = lib.mkOption {
      type = str;
      example = "internal.meet.example.org";
      description = ''
        Domain part of the JID for XMPP user connection.
      '';
    };

    userPasswordFile = lib.mkOption {
      type = str;
      example = "/run/keys/jigasi-user";
      description = ''
        Path to file containing password for XMPP user connection.
      '';
    };

    bridgeMuc = lib.mkOption {
      type = str;
      example = "jigasibrewery@internal.meet.example.org";
      description = ''
        JID of the internal MUC used to communicate with Videobridges.
      '';
    };

    defaultJvbRoomName = lib.mkOption {
      type = str;
      default = "";
      example = "siptest";
      description = ''
        Name of the default JVB room that will be joined if no special header is included in SIP invite.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File containing environment variables to be passed to the jigasi service,
        in which secret tokens can be specified securely by defining values for
        <literal>JIGASI_SIPUSER</literal>,
        <literal>JIGASI_SIPPWD</literal>,
        <literal>JIGASI_SIPSERVER</literal> and
        <literal>JIGASI_SIPPORT</literal>.
      '';
    };

    config = lib.mkOption {
      type = attrsOf str;
      default = { };
      example = lib.literalExpression ''
        {
          "org.jitsi.jigasi.auth.URL" = "XMPP:jitsi-meet.example.com";
        }
      '';
      description = ''
        Contents of the <filename>sip-communicator.properties</filename> configuration file for jigasi.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.jicofo.config = {
      "org.jitsi.jicofo.jigasi.BREWERY" = "${cfg.bridgeMuc}";
    };

    services.jigasi.config = lib.mapAttrs (_: v: lib.mkDefault v) {
      "org.jitsi.jigasi.BRIDGE_MUC" = cfg.bridgeMuc;
    };

    users.groups.jitsi-meet = {};

    systemd.services.jigasi = let
      jigasiProps = {
        "-Dnet.java.sip.communicator.SC_HOME_DIR_LOCATION" = "${stateDir}";
        "-Dnet.java.sip.communicator.SC_HOME_DIR_NAME" = "${homeDirName}";
        "-Djava.util.logging.config.file" = "${pkgs.jigasi}/etc/jitsi/jigasi/logging.properties";
      };
    in
    {
      description = "Jitsi Gateway to SIP";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        [ -f "${sipCommunicatorPropertiesFile}" ] && rm -f "${sipCommunicatorPropertiesFile}"
        mkdir -p "$(dirname ${sipCommunicatorPropertiesFile})"
        temp="${sipCommunicatorPropertiesFile}.unsubstituted"

        export DOMAIN_BASE="${cfg.xmppDomain}"
        export JIGASI_XMPP_PASSWORD=$(cat "${cfg.userPasswordFile}")
        export JIGASI_DEFAULT_JVB_ROOM_NAME="${cfg.defaultJvbRoomName}"

        # encode the credentials to base64
        export JIGASI_SIPPWD=$(echo -n "$JIGASI_SIPPWD" | base64 -w 0)
        export JIGASI_XMPP_PASSWORD_BASE64=$(cat "${cfg.userPasswordFile}" | base64 -w 0)

        cp "${sipCommunicatorPropertiesFileUnsubstituted}" "$temp"
        chmod 644 "$temp"
        cat <<EOF >>"$temp"
        net.java.sip.communicator.impl.protocol.sip.acc1403273890647.SERVER_PORT=$JIGASI_SIPPORT
        net.java.sip.communicator.impl.protocol.sip.acc1403273890647.PREFERRED_TRANSPORT=udp
        EOF
        chmod 444 "$temp"

        # Replace <<$VAR_NAME>> from example config to $VAR_NAME for environment substitution
        sed -i -E \
          's/<<([^>]+)>>/\$\1/g' \
          "$temp"

        sed -i \
          's|\(net\.java\.sip\.communicator\.impl\.protocol\.jabber\.acc-xmpp-1\.PASSWORD=\).*|\1\$JIGASI_XMPP_PASSWORD_BASE64|g' \
          "$temp"

        sed -i \
          's|\(#\)\(org.jitsi.jigasi.DEFAULT_JVB_ROOM_NAME=\).*|\2\$JIGASI_DEFAULT_JVB_ROOM_NAME|g' \
          "$temp"

        ${pkgs.envsubst}/bin/envsubst \
          -o "${sipCommunicatorPropertiesFile}" \
          -i "$temp"

        # Set the brewery room name
        sed -i \
          's|\(net\.java\.sip\.communicator\.impl\.protocol\.jabber\.acc-xmpp-1\.BREWERY=\).*|\1${cfg.bridgeMuc}|g' \
          "${sipCommunicatorPropertiesFile}"
        sed -i \
          's|\(org\.jitsi\.jigasi\.ALLOWED_JID=\).*|\1${cfg.bridgeMuc}|g' \
          "${sipCommunicatorPropertiesFile}"


        # Disable certificate verification for self-signed certificates
        sed -i \
          's|\(# \)\(net.java.sip.communicator.service.gui.ALWAYS_TRUST_MODE_ENABLED=true\)|\2|g' \
          "${sipCommunicatorPropertiesFile}"
      '';

      restartTriggers = [
        config.environment.etc."jitsi/jigasi/sip-communicator.properties".source
      ];
      environment.JAVA_SYS_PROPS = lib.concatStringsSep " " (lib.mapAttrsToList (k: v: "${k}=${toString v}") jigasiProps);

      script = ''
        ${pkgs.jigasi}/bin/jigasi \
          --host="${cfg.xmppHost}" \
          --domain="${if cfg.xmppDomain == null then cfg.xmppHost else cfg.xmppDomain}" \
          --secret="$(cat ${cfg.componentPasswordFile})" \
          --user_name="${cfg.userName}" \
          --user_domain="${cfg.userDomain}" \
          --user_password="$(cat ${cfg.userPasswordFile})" \
          --configdir="${stateDir}" \
          --configdirname="${homeDirName}"
      '';

      serviceConfig = {
        Type = "exec";

        DynamicUser = true;
        User = "jigasi";
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
        StateDirectory = baseNameOf stateDir;
        EnvironmentFile = cfg.environmentFile;
      };
    };

    environment.etc."jitsi/jigasi/sip-communicator.properties".source =
      lib.mkDefault "${sipCommunicatorPropertiesFile}";
    environment.etc."jitsi/jigasi/logging.properties".source =
      lib.mkDefault "${stateDir}/logging.properties-journal";
  };

  meta.maintainers = lib.teams.jitsi.members;
}

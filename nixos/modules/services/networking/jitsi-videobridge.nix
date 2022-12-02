{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.jitsi-videobridge;
  attrsToArgs = a: concatStringsSep " " (mapAttrsToList (k: v: "${k}=${toString v}") a);

  # HOCON is a JSON superset that videobridge2 uses for configuration.
  # It can substitute environment variables which we use for passwords here.
  # https://github.com/lightbend/config/blob/master/README.md
  #
  # Substitution for environment variable FOO is represented as attribute set
  # { __hocon_envvar = "FOO"; }
  toHOCON = x: if isAttrs x && x ? __hocon_envvar then ("\${" + x.__hocon_envvar + "}")
    else if isAttrs x then "{${ concatStringsSep "," (mapAttrsToList (k: v: ''"${k}":${toHOCON v}'') x) }}"
    else if isList x then "[${ concatMapStringsSep "," toHOCON x }]"
    else builtins.toJSON x;

  # We're passing passwords in environment variables that have names generated
  # from an attribute name, which may not be a valid bash identifier.
  toVarName = s: "XMPP_PASSWORD_" + stringAsChars (c: if builtins.match "[A-Za-z0-9]" c != null then c else "_") s;

  defaultJvbConfig = {
    videobridge = {
      ice = {
        tcp = {
          enabled = true;
          port = 4443;
        };
        udp.port = 10000;
      };
      stats = {
        enabled = true;
        transports = [ { type = "muc"; } ];
      };
      apis.xmpp-client.configs = flip mapAttrs cfg.xmppConfigs (name: xmppConfig: {
        hostname = xmppConfig.hostName;
        domain = xmppConfig.domain;
        username = xmppConfig.userName;
        password = { __hocon_envvar = toVarName name; };
        muc_jids = xmppConfig.mucJids;
        muc_nickname = xmppConfig.mucNickname;
        disable_certificate_verification = xmppConfig.disableCertificateVerification;
      });
    };
  };

  # Allow overriding leaves of the default config despite types.attrs not doing any merging.
  jvbConfig = recursiveUpdate defaultJvbConfig cfg.config;
in
{
  options.services.jitsi-videobridge = with types; {
    enable = mkEnableOption (lib.mdDoc "Jitsi Videobridge, a WebRTC compatible video router");

    config = mkOption {
      type = attrs;
      default = { };
      example = literalExpression ''
        {
          videobridge = {
            ice.udp.port = 5000;
            websockets = {
              enabled = true;
              server-id = "jvb1";
            };
          };
        }
      '';
      description = lib.mdDoc ''
        Videobridge configuration.

        See <https://github.com/jitsi/jitsi-videobridge/blob/master/jvb/src/main/resources/reference.conf>
        for default configuration with comments.
      '';
    };

    xmppConfigs = mkOption {
      description = lib.mdDoc ''
        XMPP servers to connect to.

        See <https://github.com/jitsi/jitsi-videobridge/blob/master/doc/muc.md> for more information.
      '';
      default = { };
      example = literalExpression ''
        {
          "localhost" = {
            hostName = "localhost";
            userName = "jvb";
            domain = "auth.xmpp.example.org";
            passwordFile = "/var/lib/jitsi-meet/videobridge-secret";
            mucJids = "jvbbrewery@internal.xmpp.example.org";
          };
        }
      '';
      type = attrsOf (submodule ({ name, ... }: {
        options = {
          hostName = mkOption {
            type = str;
            example = "xmpp.example.org";
            description = lib.mdDoc ''
              Hostname of the XMPP server to connect to. Name of the attribute set is used by default.
            '';
          };
          domain = mkOption {
            type = nullOr str;
            default = null;
            example = "auth.xmpp.example.org";
            description = lib.mdDoc ''
              Domain part of JID of the XMPP user, if it is different from hostName.
            '';
          };
          userName = mkOption {
            type = str;
            default = "jvb";
            description = lib.mdDoc ''
              User part of the JID.
            '';
          };
          passwordFile = mkOption {
            type = str;
            example = "/run/keys/jitsi-videobridge-xmpp1";
            description = lib.mdDoc ''
              File containing the password for the user.
            '';
          };
          mucJids = mkOption {
            type = str;
            example = "jvbbrewery@internal.xmpp.example.org";
            description = lib.mdDoc ''
              JID of the MUC to join. JiCoFo needs to be configured to join the same MUC.
            '';
          };
          mucNickname = mkOption {
            # Upstream DEBs use UUID, let's use hostname instead.
            type = str;
            description = lib.mdDoc ''
              Videobridges use the same XMPP account and need to be distinguished by the
              nickname (aka resource part of the JID). By default, system hostname is used.
            '';
          };
          disableCertificateVerification = mkOption {
            type = bool;
            default = false;
            description = lib.mdDoc ''
              Whether to skip validation of the server's certificate.
            '';
          };
        };
        config = {
          hostName = mkDefault name;
          mucNickname = mkDefault (builtins.replaceStrings [ "." ] [ "-" ] (
            config.networking.fqdnOrHostName
          ));
        };
      }));
    };

    nat = {
      localAddress = mkOption {
        type = nullOr str;
        default = null;
        example = "192.168.1.42";
        description = lib.mdDoc ''
          Local address when running behind NAT.
        '';
      };

      publicAddress = mkOption {
        type = nullOr str;
        default = null;
        example = "1.2.3.4";
        description = lib.mdDoc ''
          Public address when running behind NAT.
        '';
      };
    };

    extraProperties = mkOption {
      type = attrsOf str;
      default = { };
      description = lib.mdDoc ''
        Additional Java properties passed to jitsi-videobridge.
      '';
    };

    openFirewall = mkOption {
      type = bool;
      default = false;
      description = lib.mdDoc ''
        Whether to open ports in the firewall for the videobridge.
      '';
    };

    apis = mkOption {
      type = with types; listOf str;
      description = lib.mdDoc ''
        What is passed as --apis= parameter. If this is empty, "none" is passed.
        Needed for monitoring jitsi.
      '';
      default = [];
      example = literalExpression "[ \"colibri\" \"rest\" ]";
    };
  };

  config = mkIf cfg.enable {
    users.groups.jitsi-meet = {};

    services.jitsi-videobridge.extraProperties = optionalAttrs (cfg.nat.localAddress != null) {
      "org.ice4j.ice.harvest.NAT_HARVESTER_LOCAL_ADDRESS" = cfg.nat.localAddress;
      "org.ice4j.ice.harvest.NAT_HARVESTER_PUBLIC_ADDRESS" = cfg.nat.publicAddress;
    };

    systemd.services.jitsi-videobridge2 = let
      jvbProps = {
        "-Dnet.java.sip.communicator.SC_HOME_DIR_LOCATION" = "/etc/jitsi";
        "-Dnet.java.sip.communicator.SC_HOME_DIR_NAME" = "videobridge";
        "-Djava.util.logging.config.file" = "/etc/jitsi/videobridge/logging.properties";
        "-Dconfig.file" = pkgs.writeText "jvb.conf" (toHOCON jvbConfig);
        # Mitigate CVE-2021-44228
        "-Dlog4j2.formatMsgNoLookups" = true;
      } // (mapAttrs' (k: v: nameValuePair "-D${k}" v) cfg.extraProperties);
    in
    {
      aliases = [ "jitsi-videobridge.service" ];
      description = "Jitsi Videobridge";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment.JAVA_SYS_PROPS = attrsToArgs jvbProps;

      script = (concatStrings (mapAttrsToList (name: xmppConfig:
        "export ${toVarName name}=$(cat ${xmppConfig.passwordFile})\n"
      ) cfg.xmppConfigs))
      + ''
        ${pkgs.jitsi-videobridge}/bin/jitsi-videobridge --apis=${if (cfg.apis == []) then "none" else concatStringsSep "," cfg.apis}
      '';

      serviceConfig = {
        Type = "exec";

        DynamicUser = true;
        User = "jitsi-videobridge";
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

        TasksMax = 65000;
        LimitNPROC = 65000;
        LimitNOFILE = 65000;
      };
    };

    environment.etc."jitsi/videobridge/logging.properties".source =
      mkDefault "${pkgs.jitsi-videobridge}/etc/jitsi/videobridge/logging.properties-journal";

    # (from videobridge2 .deb)
    # this sets the max, so that we can bump the JVB UDP single port buffer size.
    boot.kernel.sysctl."net.core.rmem_max" = mkDefault 10485760;
    boot.kernel.sysctl."net.core.netdev_max_backlog" = mkDefault 100000;

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall
      [ jvbConfig.videobridge.ice.tcp.port ];
    networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall
      [ jvbConfig.videobridge.ice.udp.port ];

    assertions = [{
      message = "publicAddress must be set if and only if localAddress is set";
      assertion = (cfg.nat.publicAddress == null) == (cfg.nat.localAddress == null);
    }];
  };

  meta.maintainers = lib.teams.jitsi.members;
}

{ config, lib, pkgs, ... }:
let
  cfg = config.services.jitsi-videobridge;
  attrsToArgs = a: lib.concatStringsSep " " (lib.mapAttrsToList (k: v: "${k}=${toString v}") a);

  format = pkgs.formats.hocon { };

  # We're passing passwords in environment variables that have names generated
  # from an attribute name, which may not be a valid bash identifier.
  toVarName = s: "XMPP_PASSWORD_" + lib.stringAsChars (c: if builtins.match "[A-Za-z0-9]" c != null then c else "_") s;

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
      apis.xmpp-client.configs = lib.flip lib.mapAttrs cfg.xmppConfigs (name: xmppConfig: {
        hostname = xmppConfig.hostName;
        domain = xmppConfig.domain;
        username = xmppConfig.userName;
        password = format.lib.mkSubstitution (toVarName name);
        muc_jids = xmppConfig.mucJids;
        muc_nickname = xmppConfig.mucNickname;
        disable_certificate_verification = xmppConfig.disableCertificateVerification;
      });
      apis.rest.enabled = cfg.colibriRestApi;
    };
  };

  # Allow overriding leaves of the default config despite types.attrs not doing any merging.
  jvbConfig = lib.recursiveUpdate defaultJvbConfig cfg.config;
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "jitsi-videobridge" "apis" ]
      "services.jitsi-videobridge.apis was broken and has been migrated into the boolean option services.jitsi-videobridge.colibriRestApi. It is set to false by default, setting it to true will correctly enable the private /colibri rest API."
    )
  ];
  options.services.jitsi-videobridge = with lib.types; {
    enable = lib.mkEnableOption "Jitsi Videobridge, a WebRTC compatible video router";

    config = lib.mkOption {
      type = attrs;
      default = { };
      example = lib.literalExpression ''
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
      description = ''
        Videobridge configuration.

        See <https://github.com/jitsi/jitsi-videobridge/blob/master/jvb/src/main/resources/reference.conf>
        for default configuration with comments.
      '';
    };

    xmppConfigs = lib.mkOption {
      description = ''
        XMPP servers to connect to.

        See <https://github.com/jitsi/jitsi-videobridge/blob/master/doc/muc.md> for more information.
      '';
      default = { };
      example = lib.literalExpression ''
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
          hostName = lib.mkOption {
            type = str;
            example = "xmpp.example.org";
            description = ''
              Hostname of the XMPP server to connect to. Name of the attribute set is used by default.
            '';
          };
          domain = lib.mkOption {
            type = nullOr str;
            default = null;
            example = "auth.xmpp.example.org";
            description = ''
              Domain part of JID of the XMPP user, if it is different from hostName.
            '';
          };
          userName = lib.mkOption {
            type = str;
            default = "jvb";
            description = ''
              User part of the JID.
            '';
          };
          passwordFile = lib.mkOption {
            type = str;
            example = "/run/keys/jitsi-videobridge-xmpp1";
            description = ''
              File containing the password for the user.
            '';
          };
          mucJids = lib.mkOption {
            type = str;
            example = "jvbbrewery@internal.xmpp.example.org";
            description = ''
              JID of the MUC to join. JiCoFo needs to be configured to join the same MUC.
            '';
          };
          mucNickname = lib.mkOption {
            # Upstream DEBs use UUID, let's use hostname instead.
            type = str;
            description = ''
              Videobridges use the same XMPP account and need to be distinguished by the
              nickname (aka resource part of the JID). By default, system hostname is used.
            '';
          };
          disableCertificateVerification = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Whether to skip validation of the server's certificate.
            '';
          };
        };
        config = {
          hostName = lib.mkDefault name;
          mucNickname = lib.mkDefault (builtins.replaceStrings [ "." ] [ "-" ] (
            config.networking.fqdnOrHostName
          ));
        };
      }));
    };

    nat = {
      localAddress = lib.mkOption {
        type = nullOr str;
        default = null;
        example = "192.168.1.42";
        description = ''
          Local address to assume when running behind NAT.
        '';
      };

      publicAddress = lib.mkOption {
        type = nullOr str;
        default = null;
        example = "1.2.3.4";
        description = ''
          Public address to assume when running behind NAT.
        '';
      };

      harvesterAddresses = lib.mkOption {
        type = listOf str;
        default = [
          "stunserver.stunprotocol.org:3478"
          "stun.framasoft.org:3478"
          "meet-jit-si-turnrelay.jitsi.net:443"
        ];
        example = [];
        description = ''
          Addresses of public STUN services to use to automatically find
          the public and local addresses of this Jitsi-Videobridge instance
          without the need for manual configuration.

          This option is ignored if {option}`services.jitsi-videobridge.nat.localAddress`
          and {option}`services.jitsi-videobridge.nat.publicAddress` are set.
        '';
      };
    };

    extraProperties = lib.mkOption {
      type = attrsOf str;
      default = { };
      description = ''
        Additional Java properties passed to jitsi-videobridge.
      '';
    };

    openFirewall = lib.mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to open ports in the firewall for the videobridge.
      '';
    };

    colibriRestApi = lib.mkOption {
      type = bool;
      description = ''
        Whether to enable the private rest API for the COLIBRI control interface.
        Needed for monitoring jitsi, enabling scraping of the /colibri/stats endpoint.
      '';
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.jitsi-meet = {};

    services.jitsi-videobridge.extraProperties =
      if (cfg.nat.localAddress != null) then {
        "org.ice4j.ice.harvest.NAT_HARVESTER_LOCAL_ADDRESS" = cfg.nat.localAddress;
        "org.ice4j.ice.harvest.NAT_HARVESTER_PUBLIC_ADDRESS" = cfg.nat.publicAddress;
      } else {
        "org.ice4j.ice.harvest.STUN_MAPPING_HARVESTER_ADDRESSES" = lib.concatStringsSep "," cfg.nat.harvesterAddresses;
      };

    systemd.services.jitsi-videobridge2 = let
      jvbProps = {
        "-Dnet.java.sip.communicator.SC_HOME_DIR_LOCATION" = "/etc/jitsi";
        "-Dnet.java.sip.communicator.SC_HOME_DIR_NAME" = "videobridge";
        "-Djava.util.logging.config.file" = "/etc/jitsi/videobridge/logging.properties";
        "-Dconfig.file" = format.generate "jvb.conf" jvbConfig;
        # Mitigate CVE-2021-44228
        "-Dlog4j2.formatMsgNoLookups" = true;
      } // (lib.mapAttrs' (k: v: lib.nameValuePair "-D${k}" v) cfg.extraProperties);
    in
    {
      aliases = [ "jitsi-videobridge.service" ];
      description = "Jitsi Videobridge";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment.JAVA_SYS_PROPS = attrsToArgs jvbProps;

      script = (lib.concatStrings (lib.mapAttrsToList (name: xmppConfig:
        "export ${toVarName name}=$(cat ${xmppConfig.passwordFile})\n"
      ) cfg.xmppConfigs))
      + ''
        ${pkgs.jitsi-videobridge}/bin/jitsi-videobridge
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
      lib.mkDefault "${pkgs.jitsi-videobridge}/etc/jitsi/videobridge/logging.properties-journal";

    # (from videobridge2 .deb)
    # this sets the max, so that we can bump the JVB UDP single port buffer size.
    boot.kernel.sysctl."net.core.rmem_max" = lib.mkDefault 10485760;
    boot.kernel.sysctl."net.core.netdev_max_backlog" = lib.mkDefault 100000;

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall
      [ jvbConfig.videobridge.ice.tcp.port ];
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall
      [ jvbConfig.videobridge.ice.udp.port ];

    assertions = [{
      message = "publicAddress must be set if and only if localAddress is set";
      assertion = (cfg.nat.publicAddress == null) == (cfg.nat.localAddress == null);
    }];
  };

  meta.maintainers = lib.teams.jitsi.members;
}

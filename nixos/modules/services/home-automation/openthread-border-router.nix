{
  lib,
  config,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.openthread-border-router;
  logLevelMappings = {
    "emerg" = 0;
    "alert" = 1;
    "crit" = 2;
    "err" = 3;
    "warning" = 4;
    "notice" = 5;
    "info" = 6;
    "debug" = 7;
  };
  logLevel = lib.getAttr cfg.logLevel logLevelMappings;
  # Use correct iptables for otbr-firewall (legacy vs nf-compat)
  iptables =
    let
      inherit (config.networking) firewall;
    in
    if firewall.backend == "iptables" then firewall.package else pkgs.iptables;
in
{
  meta.maintainers = with lib.maintainers; [
    jamiemagee
    leonm1
    mrene
  ];

  options.services.openthread-border-router = {
    enable = lib.mkEnableOption "the OpenThread Border Router";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the REST API and web interface ports.";
    };

    package = lib.mkPackageOption pkgs "openthread-border-router" { };

    backboneInterfaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "eth0" ];
      description = "The network interfaces on which to advertise the thread ipv6 mesh prefix. Can be specified multiple times.";
    };

    interfaceName = lib.mkOption {
      type = lib.types.str;
      default = "wpan0";
      description = "The network interface to create for thread packets.";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum (lib.attrNames logLevelMappings);
      default = "err";
      description = "The level to use when logging messages.";
    };

    rest = {
      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The address on which to listen for REST API requests.";
        example = "::";
      };

      listenPort = lib.mkOption {
        type = lib.types.port;
        default = 8081;
        description = "The port on which to listen for REST API requests. Warning: the web interface relies on this value being set to 8081.";
      };
    };

    web = {
      enable = lib.mkEnableOption "the web interface";
      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The address on which the web interface should listen.";
        example = "::";
      };

      listenPort = lib.mkOption {
        type = lib.types.port;
        default = 8082;
        description = "The port on which the web interface should listen.";
      };
    };

    radio = {
      device = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          The device name of the serial port of the radio device.
          Ignored if {option}`services.openthread-border-router.radio.url` is set.
        '';
      };

      baudRate = lib.mkOption {
        type = lib.types.ints.positive;
        default = 115200;
        description = ''
          The baud rate of the radio device.
          Ignored if {option}`services.openthread-border-router.radio.url` is set.
        '';
      };

      flowControl = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable hardware flow control.
          Ignored if {option}`services.openthread-border-router.radio.url` is set.
        '';
      };

      urlQueryString = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Extra URL query string parameters.
          Ignored if {option}`services.openthread-border-router.radio.url` is set.
        '';
        example = "bus-latency=100&region=ca";
      };

      url = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "The URL of the radio device to use.";
        example = "spinel+hdlc+uart:///dev/ttyUSB0?uart-baudrate=460800&uart-flow-control";
      };

      extraDevices = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Extra devices to add to the radio device.";
        example = [ "trel://eth0" ];
      };
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra arguments to pass to the otbr-agent daemon.";
      example = [ "--radio-version" ];
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.radio.device != null || cfg.radio.url != null;
        message = "services.openthread-border-router requires either radio.device or radio.url to be set.";
      }
    ];

    warnings = lib.optional (cfg.web.enable && cfg.rest.listenPort != 8081) ''
      The openthread-border-router web interface is hardcoded to talk to the REST API on port 8081, but its
      port has been changed to ${toString cfg.rest.listenPort}. Some features will be broken.
    '';

    services.openthread-border-router.radio.url = lib.mkIf (cfg.radio.device != null) (
      lib.mkDefault (
        "spinel+hdlc+uart://${cfg.radio.device}?"
        + lib.concatStringsSep "&" (
          [ "uart-baudrate=${toString cfg.radio.baudRate}" ]
          ++ lib.optional cfg.radio.flowControl "uart-flow-control"
          ++ lib.optional (cfg.radio.urlQueryString != "") cfg.radio.urlQueryString
        )
      )
    );

    # ot-ctl can be used to query the router instance
    environment.systemPackages = [ cfg.package ];

    # Make sure we have ipv6 support, and that forwarding is enabled
    networking.enableIPv6 = true;
    networking.firewall.allowedTCPPorts =
      lib.optional cfg.openFirewall cfg.rest.listenPort
      ++ lib.optional (cfg.openFirewall && cfg.web.enable) cfg.web.listenPort;
    boot.kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    }
    // lib.listToAttrs (
      lib.concatMap (iface: [
        {
          name = "net.ipv6.conf.${iface}.accept_ra";
          value = 2;
        }
        {
          name = "net.ipv6.conf.${iface}.accept_ra_rt_info_max_plen";
          value = 64;
        }
      ]) cfg.backboneInterfaces
    );

    # OTBR uses avahi for mDNS service publishing
    services.avahi = {
      enable = lib.mkDefault true;
      publish = {
        enable = lib.mkDefault true;
        userServices = lib.mkDefault true;
      };
    };

    # The upstream service files (src/agent/otbr-agent.service.in, src/web/otbr-web.service.in) use
    # EnvironmentFile and CMake-substituted platform scripts that don't translate to NixOS, so the
    # services are rebuilt here from typed module options instead.
    systemd.services = {
      # The agent keeps its local state in /var/lib/thread
      otbr-agent = {
        description = "OpenThread Border Router Agent";
        wantedBy = [ "multi-user.target" ];
        requires = [ "network-online.target" ];
        after = [ "network-online.target" ];
        environment = {
          THREAD_IF = cfg.interfaceName;
        };
        serviceConfig = {
          ExecStartPre = "${utils.escapeSystemdExecArg (lib.getExe' cfg.package "otbr-firewall")} start";
          ExecStart = lib.concatStringsSep " " (
            lib.concatLists [
              [
                (lib.getExe' cfg.package "otbr-agent")
                "--verbose"
              ]
              (map (iface: "--backbone-ifname ${utils.escapeSystemdExecArg iface}") cfg.backboneInterfaces)
              [
                "--thread-ifname ${utils.escapeSystemdExecArg cfg.interfaceName}"
                "--debug-level ${toString logLevel}"
              ]
              (lib.optional (cfg.rest.listenPort != 0) "--rest-listen-port ${toString cfg.rest.listenPort}")
              (lib.optional (
                cfg.rest.listenAddress != ""
              ) "--rest-listen-address ${utils.escapeSystemdExecArg cfg.rest.listenAddress}")
              (lib.optional (cfg.radio.url != null) (utils.escapeSystemdExecArg cfg.radio.url))
              (map utils.escapeSystemdExecArg cfg.radio.extraDevices)
              (map utils.escapeSystemdExecArg cfg.extraArgs)
            ]
          );
          ExecStopPost = "${utils.escapeSystemdExecArg (lib.getExe' cfg.package "otbr-firewall")} stop";
          KillMode = "mixed";
          Restart = "on-failure";
          RestartSec = 5;
          RestartPreventExitStatus = "SIGKILL";

          # Hardening options (not present in upstream service definitions)
          StateDirectory = "thread";
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          ProtectClock = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          ProtectProc = "invisible";
          ProcSubset = "pid";
          NoNewPrivileges = true;
          LockPersonality = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          UMask = "0077";

          CapabilityBoundingSet = [
            "CAP_NET_ADMIN"
            "CAP_NET_RAW"
          ];
        };
        path = [
          pkgs.ipset
          iptables
        ];
      };

      # Sync with: src/web/otbr-web.service.in
      otbr-web = lib.mkIf cfg.web.enable {
        description = "OpenThread Border Router Web Interface";
        after = [ "otbr-agent.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = lib.concatStringsSep " " (
            lib.concatLists [
              [
                (lib.getExe' cfg.package "otbr-web")
                "-I"
                (utils.escapeSystemdExecArg cfg.interfaceName)
                "-d"
                (toString logLevel)
              ]
              (lib.optional (
                cfg.web.listenAddress != ""
              ) "-a ${utils.escapeSystemdExecArg cfg.web.listenAddress}")
              (lib.optional (cfg.web.listenPort != 0) "-p ${toString cfg.web.listenPort}")
            ]
          );

          # Hardening options (not present in upstream service definitions)
          DynamicUser = true;
          PrivateUsers = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectClock = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          ProtectProc = "invisible";
          ProcSubset = "pid";
          NoNewPrivileges = true;
          LockPersonality = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          UMask = "0077";
          CapabilityBoundingSet = "";
        };
      };
    };
  };
}

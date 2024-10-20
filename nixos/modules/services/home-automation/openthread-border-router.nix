{
  lib,
  config,
  pkgs,
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
in
{
  meta.maintainers = with lib.maintainers; [ mrene ];

  options.services.openthread-border-router = {
    enable = lib.mkEnableOption "the OpenThread Border Router";

    package = lib.mkPackageOption pkgs "openthread-border-router" { };

    backboneInterface = lib.mkOption {
      type = lib.types.str;
      default = "eth0";
      description = "The network interface on which to advertise the thread ipv6 mesh prefix";
    };

    interfaceName = lib.mkOption {
      type = lib.types.str;
      default = "wpan0";
      description = "The network interface to create for thread packets";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "emerg"
        "alert"
        "crit"
        "err"
        "warning"
        "notice"
        "info"
        "debug"
      ];
      default = "err";
      description = "The level to use when logging messages";
    };

    rest = {
      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The address on which to listen for REST API requests";
        example = "::";
      };

      listenPort = lib.mkOption {
        type = lib.types.port;
        default = 8081;
        description = "The port on which to listen for REST API requests";
      };
    };

    web = {
      enable = lib.mkEnableOption "the web interface";
      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The address on which the web interface should listen";
        example = "::";
      };

      listenPort = lib.mkOption {
        type = lib.types.port;
        default = 8082;
        description = "The port on which the web interface should listen";
      };
    };

    radio = {
      device = lib.mkOption {
        type = lib.types.path;
        default = "/dev/ttyUSB0";
        description = "The device name of the serial port of the radio device. Ignored if services.openthread-border-router.radio.url is set.";
      };

      baudRate = lib.mkOption {
        type = lib.types.int;
        default = 115200;
        description = "The baud rate of the radio device. Ignored if services.openthread-border-router.radio.url is set.";
      };

      flowControl = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable hardware flow control. Ignored if services.openthread-border-router.radio.url is set.";
      };

      urlQueryString = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Extra URL query string parameters. Ignored if services.openthread-border-router.radio.url is set.";
        example = "bus-latency=100&region=ca";
      };

      url = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "The URL of the radio device to use";
        example = "spinel+hdlc+uart:///dev/ttyUSB0?uart-baudrate=460800&uart-flow-control";
      };

      extraDevices = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Extra devices to add to the radio device";
        example = "[ \"trel://eth0\" ]";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.openthread-border-router.radio.url = lib.mkDefault (
      "spinel+hdlc+uart://${cfg.radio.device}?"
      + lib.concatStringsSep "&" (
        [ "uart-baudrate=${toString cfg.radio.baudRate}" ]
        ++ lib.optional cfg.radio.flowControl "uart-flow-control"
        ++ lib.optional (cfg.radio.urlQueryString != "") cfg.radio.urlQueryString
      )
    );

    # ot-ctl can be used to query the router instance
    environment.systemPackages = [ cfg.package ];

    # Make sure we have ipv6 support, and that forwarding is enabled
    networking.enableIPv6 = true;
    boot.kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv6.ip_forward" = 1;

      # Make sure we accept IPv6 router advertisements from the local network interface
      "net.ipv6.conf.${cfg.backboneInterface}.accept_ra" = 2;
      "net.ipv6.conf.${cfg.backboneInterface}.accept_ra_rt_info_max_plen" = 64;
    };

    # OTBR needs to publish its addresses via avahi
    services.avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    # Synchronize the services with the unit files defined in the source pacakge
    systemd.services = {
      # Sync with: src/agent/otbr-agent.service.in
      # Manually added otbr-firewall calls because they are handled inside platform-specific scripts
      # The agent keeps its local state in /var/lib/thread
      otbr-agent = {
        description = "OpenThread Border Router Agent";
        wantedBy = [ "multi-user.target" ];
        requires = [ "dbus.socket" ];
        after = [ "dbus.socket" ];
        environment = {
          THREAD_IF = cfg.interfaceName;
        };
        serviceConfig = {
          ExecStartPre = "${lib.getExe' cfg.package "otbr-firewall"} start";
          ExecStart = (
            lib.concatStringsSep " " (
              [ (lib.getExe' cfg.package "otbr-agent") ]
              ++ [
                "--verbose"
                "--backbone-ifname ${cfg.backboneInterface}"
                "--thread-ifname ${cfg.interfaceName}"
                "--debug-level ${toString logLevel}"
              ]
              ++ lib.optional (cfg.rest.listenPort != 0) "--rest-listen-port ${toString cfg.rest.listenPort}"
              ++ lib.optional (cfg.rest.listenAddress != "") "--rest-listen-address ${cfg.rest.listenAddress}"
              ++ [ cfg.radio.url ]
              ++ cfg.radio.extraDevices
            )
          );
          ExecStopPost = "${lib.getExe' cfg.package "otbr-firewall"} stop";
          KillMode = "mixed";
          Restart = "on-failure";
          RestartSec = 5;
          RestartPreventExitStatus = "SIGKILL";
        };
        path = [
          pkgs.ipset
          pkgs.iptables
        ];
      };

      # Sync with: src/web/otbr-web.service.in
      otbr-web = lib.mkIf cfg.web.enable {
        description = "OpenThread Border Router Web";
        after = [ "otbr-agent.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = (
            lib.concatStringsSep " " (
              [
                (lib.getExe' cfg.package "otbr-web")
                "-I"
                "${cfg.interfaceName}"
                "-d"
                "${toString logLevel}"
              ]
              ++ lib.optional (cfg.web.listenAddress != "") "-a ${cfg.web.listenAddress}"
              ++ lib.optional (cfg.web.listenPort != 0) "-p ${toString cfg.web.listenPort}"
            )
          );
        };
      };
    };
  };
}

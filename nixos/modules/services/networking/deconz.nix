{ config, lib, pkgs, ... }:

let
  cfg = config.services.deconz;
  name = "deconz";
  stateDir = "/var/lib/${name}";
  # ref. upstream deconz.service
  capabilities =
    lib.optionals (cfg.httpPort < 1024 || cfg.wsPort < 1024) [ "CAP_NET_BIND_SERVICE" ]
    ++ lib.optionals (cfg.allowRebootSystem) [ "CAP_SYS_BOOT" ]
    ++ lib.optionals (cfg.allowRestartService) [ "CAP_KILL" ]
    ++ lib.optionals (cfg.allowSetSystemTime) [ "CAP_SYS_TIME" ];
in
{
  options.services.deconz = {

    enable = lib.mkEnableOption "deCONZ, a Zigbee gateway for use with ConBee hardware (https://phoscon.de/en/conbee2)";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.deconz;
      defaultText = lib.literalExpression "pkgs.deconz";
      description = "Which deCONZ package to use.";
    };

    device = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Force deCONZ to use a specific USB device (e.g. /dev/ttyACM0). By
        default it does a search.
      '';
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = ''
        Pin deCONZ to the network interface specified through the provided IP
        address. This applies for the webserver as well as the websocket
        notifications.
      '';
    };

    httpPort = lib.mkOption {
      type = lib.types.port;
      default = 80;
      description = "TCP port for the web server.";
    };

    wsPort = lib.mkOption {
      type = lib.types.port;
      default = 443;
      description = "TCP port for the WebSocket.";
    };

    openFirewall = lib.mkEnableOption "opening up the service ports in the firewall";

    allowRebootSystem = lib.mkEnableOption "rebooting the system";

    allowRestartService = lib.mkEnableOption "killing/restarting processes";

    allowSetSystemTime = lib.mkEnableOption "setting the system time";

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--dbg-info=1"
        "--dbg-err=2"
      ];
      description = ''
        Extra command line arguments for deCONZ, see
        https://github.com/dresden-elektronik/deconz-rest-plugin/wiki/deCONZ-command-line-parameters.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.httpPort
      cfg.wsPort
    ];

    services.udev.packages = [ cfg.package ];

    systemd.services.deconz = {
      description = "deCONZ Zigbee gateway";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        # The service puts a nix store path reference in here, and that path can
        # be garbage collected. Ensure the file gets "refreshed" on every start.
        rm -f ${stateDir}/.local/share/dresden-elektronik/deCONZ/zcldb.txt
      '';
      postStart = ''
        # Delay signalling service readiness until it's actually up.
        while ! "${lib.getExe pkgs.curl}" -sSfL -o /dev/null "http://${cfg.listenAddress}:${toString cfg.httpPort}"; do
            echo "Waiting for TCP port ${toString cfg.httpPort} to be open..."
            sleep 1
        done
      '';
      environment = {
        HOME = stateDir;
        XDG_RUNTIME_DIR = "/run/${name}";
      };
      serviceConfig = {
        ExecStart =
          "${lib.getExe cfg.package}"
          + " -platform minimal"
          + " --http-listen=${cfg.listenAddress}"
          + " --http-port=${toString cfg.httpPort}"
          + " --ws-port=${toString cfg.wsPort}"
          + " --auto-connect=1"
          + (lib.optionalString (cfg.device != null) " --dev=${cfg.device}")
          + " " + (lib.escapeShellArgs cfg.extraArgs);
        Restart = "on-failure";
        AmbientCapabilities = capabilities;
        CapabilityBoundingSet = capabilities;
        UMask = "0027";
        DynamicUser = true;
        RuntimeDirectory = name;
        RuntimeDirectoryMode = "0700";
        StateDirectory = name;
        SuccessExitStatus = [ 143 ];
        WorkingDirectory = stateDir;
        # For access to /dev/ttyACM0 (ConBee).
        SupplementaryGroups = [ "dialout" ];
        ProtectHome = true;
      };
    };
  };
}

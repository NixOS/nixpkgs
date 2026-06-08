{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.matterjs-server;
in
{
  options.services.matterjs-server = {
    enable = lib.mkEnableOption "matterjs-server, a Matter Controller WebSocket server based on Matter.js";

    package = lib.mkPackageOption pkgs "matterjs-server" { };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "IP address the WebSocket API binds to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5580;
      description = "TCP port the WebSocket API listens on.";
    };

    openFirewall = lib.mkEnableOption null // {
      description = "Whether to open the WebSocket API port in the firewall.";
    };

    bluetoothSupport = lib.mkEnableOption ''
      BLE (Bluetooth Low Energy) commissioning support. Select an adapter with
      `--bluetooth-adapter=<id>` in
      {option}`services.matterjs-server.extraArgs`
    '';

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--primary-interface=enp11s0"
        "--log-level=debug"
      ];
      description = ''
        Additional command-line arguments passed to `matterjs-server`. See
        `matterjs-server --help` for the full list of options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.services.matterjs-server = {
      description = "Matter Controller WebSocket server based on Matter.js";
      documentation = [ "https://github.com/matter-js/matterjs-server" ];

      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig =
        let
          bluetoothCaps = [
            "CAP_NET_RAW"
            "CAP_NET_ADMIN"
          ];
        in
        {
          ExecStart = lib.escapeShellArgs (
            [
              (lib.getExe cfg.package)
              "--storage-path=%S/matterjs-server"
              "--listen-address=${cfg.listenAddress}"
              "--port=${toString cfg.port}"
              "--production-mode"
            ]
            ++ cfg.extraArgs
          );

          StateDirectory = "matterjs-server";
          StateDirectoryMode = "0700";

          DynamicUser = true;

          # Required for interaction with hci devices and bluetooth sockets
          AmbientCapabilities = lib.optionals cfg.bluetoothSupport bluetoothCaps;
          CapabilityBoundingSet = lib.optionals cfg.bluetoothSupport bluetoothCaps;
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateTmp = true;
          PrivateUsers = !cfg.bluetoothSupport; # Prevents gaining capabilities in the host namespace
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
            "AF_UNIX"
          ]
          ++ lib.optional cfg.bluetoothSupport "AF_BLUETOOTH";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
          ];
          UMask = "0077";
        };
    };
  };

  meta.maintainers = with lib.maintainers; [
    kranzes
    marie
  ];
}

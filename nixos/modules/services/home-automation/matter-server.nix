{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.matter-server;
  storageDir = "matter-server";
  storagePath = "/var/lib/${storageDir}";
  vendorId = "4939"; # home-assistant vendor ID
in

{
  meta.maintainers = with lib.maintainers; [ leonm1 ];

  options.services.matter-server = with lib.types; {
    enable = lib.mkEnableOption "Matter-server";

    package = lib.mkPackageOption pkgs "python-matter-server" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5580;
      description = "Port to expose the matter-server service on.";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "critical"
        "error"
        "warning"
        "info"
        "debug"
      ];
      default = "info";
      description = "Verbosity of logs from the matter-server";
    };

    extraArgs = lib.mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Extra arguments to pass to the matter-server executable.
        See <https://github.com/home-assistant-libs/python-matter-server?tab=readme-ov-file#running-the-development-server> for options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.matter-server = {
      after = [ "network-online.target" ];
      before = [ "home-assistant.service" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      description = "Matter Server";
      environment.HOME = storagePath;
      serviceConfig = {
        ExecStart = (
          lib.concatStringsSep " " [
            # `python-matter-server` writes to /data even when a storage-path
            # is specified. This symlinks /data at the systemd-managed
            # /var/lib/matter-server, so all files get dropped into the state
            # directory.
            "${pkgs.bash}/bin/sh"
            "-c"
            "'"
            "${pkgs.coreutils}/bin/ln -s %S/matter-server/ %t/matter-server/root/data"
            "&&"
            "${cfg.package}/bin/matter-server"
            "--port"
            (toString cfg.port)
            "--vendorid"
            vendorId
            "--storage-path"
            storagePath
            "--log-level"
            "${cfg.logLevel}"
            "${lib.escapeShellArgs cfg.extraArgs}"
            "'"
          ]
        );
        # Start with a clean root filesystem, and allowlist what the container
        # is permitted to access.
        # See https://discourse.nixos.org/t/hardening-systemd-services/17147/14.
        RuntimeDirectory = [ "matter-server/root" ];
        RootDirectory = "%t/matter-server/root";

        # Allowlist /nix/store (to allow the binary to find its dependencies)
        # and dbus.
        BindReadOnlyPaths = "/nix/store /run/dbus";
        # Let systemd manage `/var/lib/matter-server` for us inside the
        # ephemeral TemporaryFileSystem.
        StateDirectory = storageDir;

        # Hardening bits
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        DevicePolicy = "closed";
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallFilter = lib.concatStringsSep " " [
          "~" # Blocklist
          "@clock"
          "@cpu-emulation"
          "@debug"
          "@module"
          "@mount"
          "@obsolete"
          "@privileged"
          "@raw-io"
          "@reboot"
          "@resources"
          "@swap"
        ];
        UMask = "0077";
      };
    };
  };
}

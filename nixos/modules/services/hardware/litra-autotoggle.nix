{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.litra-autotoggle;

  natural = with lib.types; addCheck int (x: x >= 0);
in
{
  options = {
    services.litra-autotoggle = {
      enable = lib.mkEnableOption "litra-autotoggle, a service to sync your Logitech Litra light with your webcam";

      serialNumber = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = ''
          The serial number of the Logitech Litra device.
          You can get the serial number using the litra devices command in the litra CLI.
        '';
        example = "1234AB567CD8";
        default = null;
      };
      requireDevice = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        description = ''
          To enforce that a Litra device must be connected.
          By default, the listener will keep running even if no Litra device is found.
          With this set, the listener will exit whenever it looks for a Litra device and none is found.
        '';
        default = null;
      };
      videoDevice = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = ''
          (linuxOnly) Watch a specific video device (e.g. /dev/video0).
          By default, all video devices will be watched.
        '';
        example = "/dev/video0";
        default = null;
      };
      delay = lib.mkOption {
        type = lib.types.nullOr natural;
        description = ''
          To customize the delay (in milliseconds) between a webcam event being detected and toggling your Litra.
          When your webcam turns on or off, multiple events may be generated in quick succession.
          Setting a delay allows the program to wait for all events before taking action, avoiding flickering.
          Defaults to 1.5 seconds (1500 milliseconds).
        '';
        example = 1500;
        default = null;
      };
      package = lib.mkPackageOption pkgs "litra-autotoggle" { };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.videoDevice == null || pkgs.stdenv.hostPlatform.isLinux;
        message = "Option videoDevice is only supported on Linux";
      }
    ];

    environment.systemPackages = [
      cfg.package
    ];

    services.udev.packages = [
      cfg.package
    ];

    systemd.services.litra-autotoggle = {
      description = "Turn your Logitech Litra device on when your webcam turns on";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Restart = "on-failure";
        ExecStart = lib.concatStringsSep " " [
          "${cfg.package}/bin/litra-autotoggle"

          (lib.optionalString (cfg.serialNumber != null) "--serial-number ${cfg.serialNumber}")
          (lib.optionalString (cfg.requireDevice != null && cfg.requireDevice) "--require-device")
          (lib.optionalString (cfg.videoDevice != null) "--video-device ${cfg.videoDevice}")
          (lib.optionalString (cfg.delay != null) "--delay ${builtins.toString cfg.delay}")
        ];

        # Hardening
        AmbientCapabilities = "";
        CapabilityBoundingSet = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = false;
        PrivateMounts = true;
        PrivateTmp = "disconnected";
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
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = "none";
        RestrictRealtime = true;
        SocketBindDeny = [
          "ipv4:tcp"
          "ipv4:udp"
          "ipv6:tcp"
          "ipv6:udp"
        ];
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    sh3rm4n
  ];
}

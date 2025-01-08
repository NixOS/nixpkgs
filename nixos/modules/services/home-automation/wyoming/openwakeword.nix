{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.wyoming.openwakeword;

  inherit (builtins)
    toString
    ;

in

{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "wyoming"
      "openwakeword"
      "models"
    ] "Configuring models has been removed, they are now dynamically discovered and loaded at runtime")
  ];

  meta.buildDocsInSandbox = false;

  options.services.wyoming.openwakeword = {
    enable = lib.mkEnableOption "Wyoming openWakeWord server";

    package = lib.mkPackageOption pkgs "wyoming-openwakeword" { };

    uri = lib.mkOption {
      type = lib.types.strMatching "^(tcp|unix)://.*$";
      default = "tcp://0.0.0.0:10400";
      example = "tcp://192.0.2.1:5000";
      description = ''
        URI to bind the wyoming server to.
      '';
    };

    customModelsDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.types.path;
      default = [ ];
      description = ''
        Paths to directories with custom wake word models (*.tflite model files).
      '';
    };

    preloadModels = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "ok_nabu"
      ];
      example = [
        # wyoming_openwakeword/models/*.tflite
        "alexa"
        "hey_jarvis"
        "hey_mycroft"
        "hey_rhasspy"
        "ok_nabu"
      ];
      description = ''
        List of wake word models to preload after startup.
      '';
    };

    threshold = lib.mkOption {
      type = lib.types.float;
      default = 0.5;
      description = ''
        Activation threshold (0-1), where higher means fewer activations.

        See trigger level for the relationship between activations and
        wake word detections.
      '';
      apply = toString;
    };

    triggerLevel = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = ''
        Number of activations before a detection is registered.

        A higher trigger level means fewer detections.
      '';
      apply = toString;
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Extra arguments to pass to the server commandline.
      '';
      apply = lib.escapeShellArgs;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services."wyoming-openwakeword" = {
      description = "Wyoming openWakeWord server";
      wants = [
        "network-online.target"
      ];
      after = [
        "network-online.target"
      ];
      wantedBy = [
        "multi-user.target"
      ];
      serviceConfig = {
        DynamicUser = true;
        User = "wyoming-openwakeword";
        # https://github.com/home-assistant/addons/blob/master/openwakeword/rootfs/etc/s6-overlay/s6-rc.d/openwakeword/run
        ExecStart = lib.concatStringsSep " " [
          "${cfg.package}/bin/wyoming-openwakeword"
          "--uri ${cfg.uri}"
          (lib.concatMapStringsSep " " (model: "--preload-model ${model}") cfg.preloadModels)
          (lib.concatMapStringsSep " " (dir: "--custom-model-dir ${toString dir}") cfg.customModelsDirectories)
          "--threshold ${cfg.threshold}"
          "--trigger-level ${cfg.triggerLevel}"
          "${cfg.extraArgs}"
        ];
        CapabilityBoundingSet = "";
        DeviceAllow = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectProc = "invisible";
        ProcSubset = "all"; # reads /proc/cpuinfo
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RuntimeDirectory = "wyoming-openwakeword";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
  };
}

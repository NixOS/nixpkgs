{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.wyoming.openwakeword;

  inherit (lib)
    concatMap
    mkOption
    mkEnableOption
    mkIf
    mkPackageOption
    mkRemovedOptionModule
    types
    ;

  inherit (builtins)
    toString
    ;

  inherit (utils)
    escapeSystemdExecArgs
    ;
in

{
  imports = [
    (mkRemovedOptionModule [
      "services"
      "wymoing"
      "openwakeword"
      "preLoadModels"
    ] "Passing a list of models to preload was removed in wyoming-openwakeword 2.0")
  ];

  options.services.wyoming.openwakeword = with types; {
    enable = mkEnableOption "Wyoming protocol server for openWakeWord wake word detection system";

    package = mkPackageOption pkgs "wyoming-openwakeword" { };

    uri = mkOption {
      type = strMatching "^(tcp|unix)://.*$";
      default = "tcp://0.0.0.0:10400";
      example = "tcp://192.0.2.1:5000";
      description = ''
        URI to bind the wyoming server to.
      '';
    };

    customModelsDirectories = mkOption {
      type = listOf types.path;
      default = [ ];
      description = ''
        Paths to directories with custom wake word models (*.tflite model files).
      '';
    };

    threshold = mkOption {
      type = numbers.between 0.0 1.0;
      default = 0.5;
      description = ''
        Activation threshold (0.0-1.0), where higher means fewer activations.

        See trigger level for the relationship between activations and
        wake word detections.
      '';
      apply = toString;
    };

    triggerLevel = mkOption {
      type = ints.unsigned;
      default = 1;
      description = ''
        Number of activations before a detection is registered.

        A higher trigger level means fewer detections.
      '';
      apply = toString;
    };

    refractorySeconds = mkOption {
      type = either int float;
      default = 2;
      example = 1.5;
      description = ''
        Duration in seconds before a wake word can be detected again.
      '';
      apply = toString;
    };

    extraArgs = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Extra arguments to pass to the server commandline.
      '';
    };
  };

  config = mkIf cfg.enable {
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
        ExecStart = escapeSystemdExecArgs (
          [
            (lib.getExe cfg.package)
            "--uri"
            cfg.uri
            "--threshold"
            cfg.threshold
            "--trigger-level"
            cfg.triggerLevel
            "--refractory-seconds"
            cfg.refractorySeconds
          ]
          ++ (concatMap (dir: [
            "--custom-model-dir"
            (toString dir)
          ]) cfg.customModelsDirectories)
          ++ cfg.extraArgs
        );
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

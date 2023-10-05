{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.services.wyoming.openwakeword;

  inherit (lib)
    concatMapStringsSep
    escapeShellArgs
    mkOption
    mdDoc
    mkEnableOption
    mkIf
    mkPackageOptionMD
    types
    ;

  inherit (builtins)
    toString
    ;

  models = [
    # wyoming_openwakeword/models/*.tflite
    "alexa"
    "hey_jarvis"
    "hey_mycroft"
    "hey_rhasspy"
    "ok_nabu"
  ];

in

{
  meta.buildDocsInSandbox = false;

  options.services.wyoming.openwakeword = with types; {
    enable = mkEnableOption (mdDoc "Wyoming openWakeWord server");

    package = mkPackageOptionMD pkgs "wyoming-openwakeword" { };

    uri = mkOption {
      type = strMatching "^(tcp|unix)://.*$";
      default = "tcp://0.0.0.0:10400";
      example = "tcp://192.0.2.1:5000";
      description = mdDoc ''
        URI to bind the wyoming server to.
      '';
    };

    models = mkOption {
      type = listOf (enum models);
      default = models;
      description = mdDoc ''
        List of wake word models that should be made available.
      '';
    };

    preloadModels = mkOption {
      type = listOf (enum models);
      default = [
        "ok_nabu"
      ];
      description = mdDoc ''
        List of wake word models to preload after startup.
      '';
    };

    threshold = mkOption {
      type = float;
      default = 0.5;
      description = mdDoc ''
        Activation threshold (0-1), where higher means fewer activations.

        See trigger level for the relationship between activations and
        wake word detections.
      '';
      apply = toString;
    };

    triggerLevel = mkOption {
      type = int;
      default = 1;
      description = mdDoc ''
        Number of activations before a detection is registered.

        A higher trigger level means fewer detections.
      '';
      apply = toString;
    };

    extraArgs = mkOption {
      type = listOf str;
      default = [ ];
      description = mdDoc ''
        Extra arguments to pass to the server commandline.
      '';
      apply = escapeShellArgs;
    };
  };

  config = mkIf cfg.enable {
    systemd.services."wyoming-openwakeword" = {
      description = "Wyoming openWakeWord server";
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
        ExecStart = ''
          ${cfg.package}/bin/wyoming-openwakeword \
            --uri ${cfg.uri} \
            ${concatMapStringsSep " " (model: "--model ${model}") cfg.models} \
            ${concatMapStringsSep " " (model: "--preload-model ${model}") cfg.preloadModels} \
            --threshold ${cfg.threshold} \
            --trigger-level ${cfg.triggerLevel} ${cfg.extraArgs}
        '';
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
        ProcSubset = "pid";
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

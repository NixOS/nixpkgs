{ config
, lib
, pkgs
, utils
, ...
}:

let
  cfg = config.services.wyoming-satellite;

  inherit (lib)
    getExe
    mkOption
    mdDoc
    mkEnableOption
    mkIf
    mkPackageOption
    optionals
    types
  ;

  finalPackage = cfg.package.overridePythonAttrs (oldAttrs: {
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs
      # for audio enhancements like auto-gain, noise suppression
      ++ cfg.package.optional-dependencies.webrtc
      # vad is currently optional, because it is broken on aarch64-linux
      ++ optionals cfg.vad.enable cfg.package.optional-dependencies.silerovad;
    });
in

{
  meta.buildDocsInSandbox = false;

  options.services.wyoming-satellite = with types; {
    enable = mkEnableOption "Wyoming Satellite";

    package = mkPackageOption pkgs "wyoming-satellite" { };

    user = mkOption {
      type = str;
      example = "alice";
      description = mdDoc ''
        User to run wyoming-satellite under.
      '';
    };

    group = mkOption {
      type = str;
      default = "users";
      description = mdDoc ''
        Group to run wyoming-satellite under.
      '';
    };

    uri = mkOption {
      type = str;
      default = "tcp://0.0.0.0:10700";
      description = mdDoc ''
        URI where wyoming-satellite will bind its socket.
      '';
    };

    name = mkOption {
      type = str;
      default = config.networking.hostName;
      description = ''
        Name of the satellite.
      '';
    };

    area = mkOption {
      type = nullOr str;
      default = null;
      example = "Kitchen";
      description = ''
        Area to the satellite.
      '';
    };

    microphone = {
      command = mkOption {
        type = nullOr str;
        default = "arecord -r 16000 -c 1 -f S16_LE -t raw";
        description = ''
          Program to run for audio input.
        '';
      };

      autoGain = mkOption {
        type = ints.between 0 31;
        default = 5;
        example = 15;
        description = ''
          Automatic gain control in dbFS, with 31 being the loudest value.
        '';
      };

      noiseSuppression = mkOption {
        type = nullOr ints.between 0 4;
        default = 2;
        example = 3;
        description = ''
          Noise suppression level with 4 being the maximum suppression,
          which may cause audio distortion.
        '';
      };
    };

    sound = {
      command = mkOption {
        type = nullOr str;
        default = "aplay -r 22050 -c 1 -f S16_LE -t raw";
        description = ''
          Program to run for sound output.
        '';
      };
    };

    vad = {
      enable = mkOption {
        type = bool;
        default = true;
        description = ''
          Whether to enable voice activity detection.

          Enabling will result in only streaming audio, when speech gets
          detected.
        '';
      };
    };

    extraArgs = mkOption {
      type = listOf str;
      default = [ ];
      description = mdDoc ''
        Extra arguments to pass to the executable.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services."wyoming-satellite" = {
      description = "Wyoming Satellite";
      after = [
        "network-online.target"
      ];
      wants = [
        "network-online.target"
      ];
      wantedBy = [
        "multi-user.target"
      ];
      path = with pkgs; [
        alsa-utils
      ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        # https://github.com/rhasspy/hassio-addons/blob/master/assist_microphone/rootfs/etc/s6-overlay/s6-rc.d/assist_microphone/run
        ExecStart = utils.escapeSystemdExecArgs ([
          (getExe finalPackage)
          "--uri" cfg.uri
          "--name" cfg.name
        ] ++ optionals (cfg.area != null) [
          "--area" cfg.area
        ] ++ optionals (cfg.microphone.command != null) [
          "--mic-command" cfg.microphone.command
        ] ++ optionals (cfg.sound.command != null) [
          "--snd-command" cfg.sound.command
        ] ++ optionals cfg.vad.enable [
          "--vad"
        ] ++ cfg.extraArgs);
        CapabilityBoundingSet = "";
        DeviceAllow = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = false; # onnxruntime/capi/onnxruntime_pybind11_state.so: cannot enable executable stack as shared object requires: Operation not permitted
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHome = false; # Would deny access to local pulse/pipewire server
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectProc = "invisible";
        ProcSubset = "all"; # Error in cpuinfo: failed to parse processor information from /proc/cpuinfo
        Restart = "always";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SupplementaryGroups = [
          "audio"
        ];
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

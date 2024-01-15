{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.services.homeassistant-satellite;

  inherit (lib)
    escapeShellArg
    escapeShellArgs
    mkOption
    mdDoc
    mkEnableOption
    mkIf
    mkPackageOption
    types
    ;

  inherit (builtins)
    toString
    ;

  # override the package with the relevant vad dependencies
  package = cfg.package.overridePythonAttrs (oldAttrs: {
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs
      ++ lib.optional (cfg.vad == "webrtcvad") cfg.package.optional-dependencies.webrtc
      ++ lib.optional (cfg.vad == "silero") cfg.package.optional-dependencies.silerovad
      ++ lib.optional (cfg.pulseaudio.enable) cfg.package.optional-dependencies.pulseaudio;
  });

in

{
  meta.buildDocsInSandbox = false;

  options.services.homeassistant-satellite = with types; {
    enable = mkEnableOption (mdDoc "Home Assistant Satellite");

    package = mkPackageOption pkgs "homeassistant-satellite" { };

    user = mkOption {
      type = str;
      example = "alice";
      description = mdDoc ''
        User to run homeassistant-satellite under.
      '';
    };

    group = mkOption {
      type = str;
      default = "users";
      description = mdDoc ''
        Group to run homeassistant-satellite under.
      '';
    };

    host = mkOption {
      type = str;
      example = "home-assistant.local";
      description = mdDoc ''
        Hostname on which your Home Assistant instance can be reached.
      '';
    };

    port = mkOption {
      type = port;
      example = 8123;
      description = mdDoc ''
        Port on which your Home Assistance can be reached.
      '';
      apply = toString;
    };

    protocol = mkOption {
      type = enum [ "http" "https" ];
      default = "http";
      example = "https";
      description = mdDoc ''
        The transport protocol used to connect to Home Assistant.
      '';
    };

    tokenFile = mkOption {
      type = path;
      example = "/run/keys/hass-token";
      description = mdDoc ''
        Path to a file containing a long-lived access token for your Home Assistant instance.
      '';
      apply = escapeShellArg;
    };

    sounds = {
      awake = mkOption {
        type = nullOr str;
        default = null;
        description = mdDoc ''
          Audio file to play when the wake word is detected.
        '';
      };

      done = mkOption {
        type = nullOr str;
        default = null;
        description = mdDoc ''
          Audio file to play when the voice command is done.
        '';
      };
    };

    vad = mkOption {
      type = enum [ "disabled" "webrtcvad" "silero" ];
      default = "disabled";
      example = "silero";
      description = mdDoc ''
        Voice activity detection model. With `disabled` sound will be transmitted continously.
      '';
    };

    pulseaudio = {
      enable = mkEnableOption "recording/playback via PulseAudio or PipeWire";

      socket = mkOption {
        type = nullOr str;
        default = null;
        example = "/run/user/1000/pulse/native";
        description = mdDoc ''
          Path or hostname to connect with the PulseAudio server.
        '';
      };

      duckingVolume = mkOption {
        type = nullOr float;
        default = null;
        example = 0.4;
        description = mdDoc ''
          Reduce output volume (between 0 and 1) to this percentage value while recording.
        '';
      };

      echoCancellation = mkEnableOption "acoustic echo cancellation";
    };

    extraArgs = mkOption {
      type = listOf str;
      default = [ ];
      description = mdDoc ''
        Extra arguments to pass to the commandline.
      '';
      apply = escapeShellArgs;
    };
  };

  config = mkIf cfg.enable {
    systemd.services."homeassistant-satellite" = {
      description = "Home Assistant Satellite";
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
        ffmpeg-headless
      ] ++ lib.optionals (!cfg.pulseaudio.enable) [
        alsa-utils
      ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        # https://github.com/rhasspy/hassio-addons/blob/master/assist_microphone/rootfs/etc/s6-overlay/s6-rc.d/assist_microphone/run
        ExecStart = ''
          ${package}/bin/homeassistant-satellite \
            --host ${cfg.host} \
            --port ${cfg.port} \
            --protocol ${cfg.protocol} \
            --token-file ${cfg.tokenFile} \
            --vad ${cfg.vad} \
            ${lib.optionalString cfg.pulseaudio.enable "--pulseaudio"}${lib.optionalString (cfg.pulseaudio.socket != null) "=${cfg.pulseaudio.socket}"} \
            ${lib.optionalString (cfg.pulseaudio.enable && cfg.pulseaudio.duckingVolume != null) "--ducking-volume=${toString cfg.pulseaudio.duckingVolume}"} \
            ${lib.optionalString (cfg.pulseaudio.enable && cfg.pulseaudio.echoCancellation) "--echo-cancel"} \
            ${lib.optionalString (cfg.sounds.awake != null) "--awake-sound=${toString cfg.sounds.awake}"} \
            ${lib.optionalString (cfg.sounds.done != null) "--done-sound=${toString cfg.sounds.done}"} \
            ${cfg.extraArgs}
        '';
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

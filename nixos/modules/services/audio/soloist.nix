{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.soloist;

  args = [
    "--device-name"
    cfg.deviceName
  ]
  ++ lib.optionals (cfg.cacheSize != null) [
    "--cache-size"
    (toString cfg.cacheSize)
  ]
  ++ lib.optionals (cfg.initialVolume != null) [
    "--initial-volume"
    (toString cfg.initialVolume)
  ]
  ++ lib.optionals (cfg.pipewireDevice != null) [
    "--pipewire-device"
    cfg.pipewireDevice
  ]
  ++ lib.optionals (cfg.websocketAddress != null) [
    "--ws"
    cfg.websocketAddress
  ]
  ++ lib.optional cfg.verbose "--verbose"
  ++ cfg.extraArgs;
in
{
  options.services.soloist = {
    enable = lib.mkEnableOption "Spotify Soloist, a headless Spotify Connect client";

    package = lib.mkPackageOption pkgs "soloist" { };

    deviceName = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = config.networking.hostName;
      defaultText = lib.literalExpression "config.networking.hostName";
      description = ''
        Name advertised to Spotify Connect controllers on the local network.
        Select this name in the Spotify app to start playback on this device.
      '';
    };

    apiKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/soloist-api-key";
      description = ''
        File containing the Spotify Soloist API key.

        Generate one from the [Spotify for Developers dashboard](https://developer.spotify.com/dashboard/soloist).
      '';
    };

    initialVolume = lib.mkOption {
      type = lib.types.nullOr (lib.types.ints.between 0 100);
      default = null;
      example = 40;
      description = ''
        Initial volume from 0 to 100.
      '';
    };

    pipewireDevice = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "alsa_output.usb-foobar-00.analog-stereo";
      description = ''
        Route audio to a specific PipeWire node name or ID instead of the
        system's default audio output.
      '';
    };

    cacheSize = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.unsigned;
      default = null;
      example = 500;
      description = ''
        Maximum playback cache size in MB. Use 0 for no limit (the default
        when unset). Values must be 0 or at least 100.
      '';
    };

    websocketAddress = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "127.0.0.1:0";
      description = ''
        Address and port (`ADDR:PORT`) to enable the local WebSocket API on.
        Use port 0 to let the operating system choose a free port.
        If unset, the WebSocket API stays disabled.
      '';
    };

    verbose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable verbose logging.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "--verbose" ];
      description = ''
        Extra command-line arguments to pass to `soloist`.
        See <https://developer.spotify.com/documentation/soloist/reference/command-line>.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.apiKeyFile != null;
        message = "services.soloist.apiKeyFile must be set to a file containing your Spotify Soloist API key (generate one at https://developer.spotify.com/dashboard/soloist).";
      }
      {
        assertion = cfg.cacheSize == null || cfg.cacheSize == 0 || cfg.cacheSize >= 100;
        message = "services.soloist.cacheSize must be 0 (no limit) or at least 100 (MB).";
      }
      {
        assertion = config.services.pipewire.enable && config.services.pipewire.systemWide;
        message = ''
          services.soloist needs system-wide PipeWire: set
          `services.pipewire.enable = true` and
          `services.pipewire.systemWide = true`. Soloist has no ALSA backend.
        '';
      }
    ];

    systemd.services.soloist = {
      description = "Spotify Soloist headless Spotify Connect client";
      documentation = [ "https://developer.spotify.com/documentation/soloist" ];

      after = [
        "network-online.target"
        "sound.target"
        "pipewire.service"
      ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      script = ''
        apiKey="$(cat "$CREDENTIALS_DIRECTORY/soloist-api-key")"
        exec ${lib.getExe cfg.package} \
          --api-key "$apiKey" \
          --data-dir "$STATE_DIRECTORY" \
          --cache-dir "$CACHE_DIRECTORY" \
          ${lib.escapeShellArgs args}
      '';

      serviceConfig = {
        DynamicUser = true;
        User = "soloist";
        Group = "soloist";
        SupplementaryGroups = [
          "audio"
          "pipewire"
        ];

        StateDirectory = "soloist";
        StateDirectoryMode = "0700";
        CacheDirectory = "soloist";
        CacheDirectoryMode = "0700";

        LoadCredential = lib.optional (cfg.apiKeyFile != null) "soloist-api-key:${cfg.apiKeyFile}";

        Restart = "always";
        RestartSec = "5s";

        CapabilityBoundingSet = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = false;
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
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "ptrace"
        ];
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ tlvince ];
}

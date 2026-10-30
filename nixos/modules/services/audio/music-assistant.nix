{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkPackageOption
    types
    ;

  inherit (types)
    bool
    listOf
    enum
    str
    ;

  cfg = config.services.music-assistant;

  finalPackage = cfg.package.override {
    inherit (cfg) providers;
  };
in

{
  meta.buildDocsInSandbox = false;

  options.services.music-assistant = {
    enable = mkEnableOption "Music Assistant";

    package = mkPackageOption pkgs "music-assistant" { };

    extraOptions = mkOption {
      type = listOf str;
      default = [
        "--config"
        "/var/lib/music-assistant"
      ];
      example = [
        "--log-level"
        "DEBUG"
      ];
      description = ''
        List of extra options to pass to the music-assistant executable.
      '';
    };

    openFirewall = lib.mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to open required ports for the configured providers.
        Currently AirPlay, AriaCast Receiver, Sendspin, Snapcast, Squeezelite and Spotify Connect need port(s) to be opened to properly function.

        ::: {.note}
        AirPlay and Spotify Connect must open all random high UDP or TCP ports respectively to function.
        :::
      '';
    };

    providers = mkOption {
      type = listOf (enum cfg.package.providerNames);
      default = [ ];
      example = [
        "opensubsonic"
        "snapcast"
      ];
      description = ''
        List of provider names for which dependencies will be installed.

        Providers that need shared service credentials (`spotify`, `qobuz`, `apple_music`,
        `theaudiodb`, `fanarttv`) do not work out of the box. Register your own credentials
        with the service and pass them to Music Assistant through the matching `MASS_APP_VAR_*`
        environment variable:

        ```nix
        services.music-assistant.providers = [ "spotify" ];

        systemd.services.music-assistant.environment = {
          MASS_APP_VAR_SPOTIFY_CLIENT_ID = "your-client-id";
        };
        ```

        To pass multiple values at once, point Music Assistant at a JSON map of app variables
        with the `MASS_APP_VARS_FILE` environment variable. The upstream
        [app_vars.py](https://github.com/music-assistant/server/blob/dev/music_assistant/helpers/app_vars.py)
        file lists the supported variables and the provider documentation (for example
        <https://www.music-assistant.io/music-providers/spotify/>) describes the setup steps.
        Qobuz and Tidal cannot be configured this way, and Spotify restricts apps registered
        by third parties.

        Nixpkgs does not ship these credentials: they are bundled only in the official Music
        Assistant release builds, are not covered by the Apache-2.0 license of the source code
        and may not be redistributed (see the upstream
        [NOTICE file](https://github.com/music-assistant/server/blob/dev/NOTICE)).
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts =
        lib.optional cfg.enable 8097 # Music Assistant stream port
        # https://github.com/music-assistant/server/blob/dev/music_assistant/providers/airplay/pairing.py#L191
        ++ lib.optionals (lib.elem "airplay" cfg.providers) [
          5000 # AirPlay 1/RAOP
          7000 # AirPlay 2
        ]
        # https://github.com/AriaCast/AriaCast-Protocol-Spec/blob/main/spec/discovery.md#ports
        ++ lib.optional (lib.elem "ariacast_receiver" cfg.providers) 12889
        # https://www.music-assistant.io/player-support/sendspin/#connecting-external-sendspin-clients
        ++ lib.optional (lib.elem "sendspin" cfg.providers) 8927
        # https://www.music-assistant.io/player-support/snapcast/#known-issues--notes
        ++ lib.optional (lib.elem "snapcast" cfg.providers) 1780
        ++ lib.optionals (lib.elem "squeezelite" cfg.providers) [
          # https://lyrion.org/reference/slimproto-protocol/
          3483 # Slimproto control
          # https://lyrion.org/reference/cli/using-the-cli/
          9000 # Slimproto JSON-RPC
          9090 # Slimproto CLI
        ];
      allowedTCPPortRanges =
        # Music Assistant does not configure the zeroconf_port, so all ephemeral ports are used
        # https://github.com/devgianlu/go-librespot#example-minimal-zeroconf-configuration
        lib.optionals (lib.elem "spotify_connect" cfg.providers) [
          {
            from = 32768;
            to = 65535;
          }
        ];
      allowedUDPPorts =
        #  https://github.com/AriaCast/AriaCast-Protocol-Spec/blob/main/spec/discovery.md#ports
        lib.optional (lib.elem "ariacast_receiver" cfg.providers) 12888
        ++ lib.optionals (lib.elem "squeezelite" cfg.providers) [
          # https://lyrion.org/reference/slimproto-protocol/
          3483 # Slimproto discovery
        ];
      # The information published by Apple 1 seem to not apply to libraop.
      # The closest we could find that represents the port range being used as observed by tcpdump is the ephemeral port range.
      # 1: https://support.apple.com/en-us/103229#:~:text=49152%E2%80%93-,65535,-TCP%2C%20UDP
      # 2: https://en.wikipedia.org/wiki/Ephemeral_port#Range
      allowedUDPPortRanges = lib.mkIf (lib.elem "airplay" cfg.providers) [
        {
          from = 32768;
          to = 65535;
        }
      ];
    };

    services = {
      avahi = lib.mkIf (lib.elem "airplay_receiver" cfg.providers) {
        enable = true;
        openFirewall = lib.mkIf cfg.openFirewall true;
        publish = {
          enable = true;
          userServices = true;
        };
      };

      music-assistant.providers = cfg.package.providersBuiltins;
    };

    systemd.services.music-assistant = {
      description = "Music Assistant";
      documentation = [ "https://music-assistant.io" ];

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      wantedBy = [ "multi-user.target" ];

      environment = {
        HOME = "/var/lib/music-assistant";
        PYTHONPATH = finalPackage.pythonPath;
      };

      path =
        with pkgs;
        [
          lsof
        ]
        ++ lib.optionals (lib.elem "airplay" cfg.providers) [
          airplay-cli
        ]
        ++ lib.optionals (lib.elem "airplay_receiver" cfg.providers) [
          shairport-sync
        ]
        ++ lib.optionals (lib.elem "spotify" cfg.providers) [
          librespot-ma
        ]
        ++ lib.optionals (lib.elem "spotify_connect" cfg.providers) [
          go-librespot
        ]
        ++ lib.optionals (lib.elem "snapcast" cfg.providers) [
          snapcast
        ]
        # YouTube Music needs deno with JIT to solve yt-dlp challenges
        ++ lib.optionals (lib.elem "ytmusic" cfg.providers) [
          deno
          ffmpeg-headless
        ];

      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe cfg.package)
          ]
          ++ cfg.extraOptions
        );
        DynamicUser = true;
        StateDirectory = "music-assistant";
        # AirPlay 2 requires CAP_NET_BIND_SERVICE to bind to UDP ports 319 and 320 for synchronized group playback.
        # Opening the ports in the firewall is not necessary.
        # See this older version of the docs:
        # https://github.com/music-assistant/music-assistant.io/blob/33175c11961beac4c6a27beff6d4cce269f29efe/src/content/docs/player-support/airplay.md#airplay-2-group-synchronization
        AmbientCapabilities = [
          ""
        ]
        ++ lib.optionals (lib.elem "airplay" cfg.providers) [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [
          ""
        ]
        ++ lib.optionals (lib.elem "airplay" cfg.providers) [ "CAP_NET_BIND_SERVICE" ];
        DevicePolicy = "closed";
        LockPersonality = true;
        # breaks pyopenssl's cffi calls, used in remote access feature
        # not compatible with llvmlite which is required by numba -> librosa
        MemoryDenyWriteExecute = false;
        # required for torch to properly detect the supported engines
        # allows Music-Assistant to warn, if x86_64-v2 cpu features are missing
        BindReadOnlyPaths = [ "/proc/cpuinfo" ];
        ProcSubset = "all";
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
        ]
        ++ lib.optionals (lib.elem "snapcast" cfg.providers) [
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "mbind"
        ]
        # YouTube Music needs deno with JIT to solve yt-dlp challenges
        ++ lib.optionals (lib.elem "ytmusic" cfg.providers) [
          "@pkey"
        ];
        RestrictSUIDSGID = true;
        UMask = "0077";
      };
    };
  };
}

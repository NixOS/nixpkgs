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

  # YouTube Music needs deno with JIT to solve yt-dlp challenges
  useYTMusic = lib.elem "ytmusic" cfg.providers;
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
        Currently airplay and sendspin need port to be opened to function.
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
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts =
        lib.optional cfg.enable 8097 # Music Assistant stream port
        ++ lib.optional (lib.elem "airplay" cfg.providers) 7000
        ++ lib.optional (lib.elem "sendspin" cfg.providers) 8927;
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

    services.avahi = lib.mkIf (lib.elem "airplay_receiver" cfg.providers) {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
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
          cliairplay
          libraop
        ]
        ++ lib.optionals (lib.elem "airplay_receiver" cfg.providers) [
          shairport-sync
        ]
        ++ lib.optionals (lib.elem "spotify" cfg.providers) [
          librespot-ma
        ]
        ++ lib.optionals (lib.elem "snapcast" cfg.providers) [
          snapcast
        ]
        ++ lib.optionals useYTMusic [
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
        AmbientCapabilities = "";
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = !useYTMusic;
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
        ]
        ++ lib.optionals (lib.elem "snapcast" cfg.providers) [
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged @resources"
          "mbind"
        ]
        ++ lib.optionals useYTMusic [
          "@pkey"
        ];
        RestrictSUIDSGID = true;
        UMask = "0077";
      };
    };
  };
}

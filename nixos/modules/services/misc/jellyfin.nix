{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkIf
    getExe
    maintainers
    mkEnableOption
    mkOption
    mkPackageOption
    ;
  inherit (lib.types)
    bool
    enum
    int
    listOf
    nullOr
    path
    str
    ;
  cfg = config.services.jellyfin;
in
{
  options = {
    services.jellyfin = {
      enable = mkEnableOption "Jellyfin Media Server";

      package = mkPackageOption pkgs "jellyfin" { };

      user = mkOption {
        type = str;
        default = "jellyfin";
        description = "User account under which Jellyfin runs.";
      };

      group = mkOption {
        type = str;
        default = "jellyfin";
        description = "Group under which jellyfin runs.";
      };

      dataDir = mkOption {
        type = path;
        default = "/var/lib/jellyfin";
        description = ''
          Base data directory,
          passed with `--datadir` see [#data-directory](https://jellyfin.org/docs/general/administration/configuration/#data-directory)
        '';
      };

      configDir = mkOption {
        type = path;
        default = "${cfg.dataDir}/config";
        defaultText = "\${cfg.dataDir}/config";
        description = ''
          Directory containing the server configuration files,
          passed with `--configdir` see [configuration-directory](https://jellyfin.org/docs/general/administration/configuration/#configuration-directory)
        '';
      };

      cacheDir = mkOption {
        type = path;
        default = "/var/cache/jellyfin";
        description = ''
          Directory containing the jellyfin server cache,
          passed with `--cachedir` see [#cache-directory](https://jellyfin.org/docs/general/administration/configuration/#cache-directory)
        '';
      };

      logDir = mkOption {
        type = path;
        default = "${cfg.dataDir}/log";
        defaultText = "\${cfg.dataDir}/log";
        description = ''
          Directory where the Jellyfin logs will be stored,
          passed with `--logdir` see [#log-directory](https://jellyfin.org/docs/general/administration/configuration/#log-directory)
        '';
      };

      openFirewall = mkOption {
        type = bool;
        default = false;
        description = ''
          Open the default ports in the firewall for the media server. The
          HTTP/HTTPS ports can be changed in the Web UI, so this option should
          only be used if they are unchanged, see [Port Bindings](https://jellyfin.org/docs/general/networking/#port-bindings).
        '';
      };

      hardwareAcceleration = {
        enable = mkEnableOption "hardware acceleration for video transcoding";

        devices = mkOption {
          type = listOf str;
          default = [ ];
          example = [ "/dev/dri/renderD128" ];
          description = ''
            List of device paths to hardware acceleration devices that Jellyfin should
            have access to. This is useful when transcoding media files.
          '';
        };

        type = mkOption {
          type = enum [
            "none"
            "vaapi"
            "nvenc"
            "qsv"
            "videotoolbox"
            "amf"
            "V4L2"
          ];
          default = "none";
          description = ''
            The method of hardware acceleration. See [Hardware Acceleration](https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration) for more details.
          '';
        };
      };

      transcoding = {
        maxConcurrentStreams = mkOption {
          type = nullOr (lib.types.ints.positive);
          default = null;
          example = 2;
          description = ''
            Maximum number of concurrent transcoding streams.
            Set to null for unlimited (limited by hardware capabilities).
          '';
        };

        enableToneMapping = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable tone mapping when transcoding HDR content.
          '';
        };

        enableSubtitleExtraction = mkOption {
          type = bool;
          default = true;
          description = ''
            Embedded subtitles can be extracted from videos and delivered to clients in plain text, in order to help prevent video transcoding. On some systems this can take a long time and cause video playback to stall during the extraction process. Disable this to have embedded subtitles burned in with video transcoding when they are not natively supported by the client device.
          '';
        };

        throttleTranscoding = mkOption {
          type = bool;
          default = false;
          description = ''
            When a transcode or remux gets far enough ahead from the current playback position, pause the process so it will consume fewer resources. This is most useful when watching without seeking often. Turn this off if you experience playback issues.
          '';
        };

        threadCount = mkOption {
          type = nullOr (lib.types.ints.positive);
          default = null;
          example = 4;
          description = ''
            Number of threads to use when transcoding.
            Set to null to use automatic detection.
          '';
        };

        hardwareDecodingCodecs = mkOption {
          type = listOf (enum [
            "h264"
            "hevc"
            "mpeg2"
            "vc1"
            "vp8"
            "vp9"
            "av1"
            "hevc10bit"
            "hevcRExt10bit"
            "hevcRExt12bit"
          ]);
          default = [ ];
          description = ''
            List of codecs to enable for hardware decoding.
          '';
        };

        hardwareEncodingCodecs = mkOption {
          type = listOf (enum [
            "h264"
            "hevc"
            "av1"
          ]);
          default = [ ];
          description = ''
            List of codecs to enable for hardware encoding.
          '';
        };

        encodingPreset = mkOption {
          type = enum [
            "auto"
            "veryslow"
            "slower"
            "slow"
            "medium"
            "fast"
            "faster"
            "veryfast"
            "superfast"
            "ultrafast"
          ];
          default = "auto";
          description = ''
            Encoder preset for transcoding.
            Lower presets sacrifice quality for speed, higher presets optimize quality.
          '';
        };

        deleteSegments = mkOption {
          type = bool;
          default = true;
          description = ''
            Delete transcoding segments when finished.
          '';
        };

        h264Crf = mkOption {
          type = lib.types.ints.between 0 51;
          default = 23;
          description = ''
            Constant Rate Factor (CRF) for H.264 encoding. Lower values result in better quality. Range: 0-51.
          '';
        };

        h265Crf = mkOption {
          type = lib.types.ints.between 0 51;
          default = 28;
          description = ''
            Constant Rate Factor (CRF) for H.265 encoding. Lower values result in better quality. Range: 0-51.
          '';
        };

        enableHardwareEncoding = mkOption {
          type = bool;
          default = false;
          description = ''
            Enable hardware encoding for video transcoding.
          '';
        };

        enableIntelLowPowerEncoding = mkOption {
          type = bool;
          default = false;
          description = ''
            Enable low-power encoding mode for Intel Quick Sync Video.
            Requires i915 HuC firmware to be configured.
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.hardwareAcceleration.enable || cfg.hardwareAcceleration.devices != [ ];
        message = "services.jellyfin.hardwareAcceleration.devices cannot be empty when hardware acceleration is enabled.";
      }
    ];

    # Generate Jellyfin configuration files
    environment.etc = mkIf cfg.hardwareAcceleration.enable {
      "jellyfin/encoding.xml" =
        let
          boolStr = b: if b then "true" else "false";
          # XML escape function for special characters
          escapeXML = str: builtins.replaceStrings
            ["&" "<" ">" "\"" "'"]
            ["&amp;" "&lt;" "&gt;" "&quot;" "&apos;"]
            str;
          devicePath =
            if cfg.hardwareAcceleration.devices != [ ]
            then escapeXML (lib.head cfg.hardwareAcceleration.devices)
            else "";
          filteredDecodingCodecs = builtins.filter
            (c: c != "hevcRExt10bit" && c != "hevcRExt12bit")
            cfg.transcoding.hardwareDecodingCodecs;
        in {
        text = ''
          <?xml version="1.0" encoding="utf-8"?>
          <EncodingOptions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
            <HardwareAccelerationType>${cfg.hardwareAcceleration.type}</HardwareAccelerationType>
            ${lib.optionalString (cfg.hardwareAcceleration.type == "vaapi" && devicePath != "") "<VaapiDevice>${devicePath}</VaapiDevice>"}
            ${lib.optionalString (cfg.hardwareAcceleration.type == "qsv" && devicePath != "") "<OpenclDevice>${devicePath}</OpenclDevice>"}
            <EncodingThreadCount>${if cfg.transcoding.threadCount != null then toString cfg.transcoding.threadCount else "-1"}</EncodingThreadCount>
            <EnableThrottling>${boolStr cfg.transcoding.throttleTranscoding}</EnableThrottling>
            <EnableTonemapping>${boolStr cfg.transcoding.enableToneMapping}</EnableTonemapping>
            <EnableSubtitleExtraction>${boolStr cfg.transcoding.enableSubtitleExtraction}</EnableSubtitleExtraction>
            <H264Crf>${toString cfg.transcoding.h264Crf}</H264Crf>
            <H265Crf>${toString cfg.transcoding.h265Crf}</H265Crf>
            <EnableHardwareEncoding>${boolStr cfg.transcoding.enableHardwareEncoding}</EnableHardwareEncoding>
            <AllowHevcEncoding>${boolStr (builtins.elem "hevc" cfg.transcoding.hardwareEncodingCodecs)}</AllowHevcEncoding>
            <AllowAv1Encoding>${boolStr (builtins.elem "av1" cfg.transcoding.hardwareEncodingCodecs)}</AllowAv1Encoding>
            <EnableIntelLowPowerH264HwEncoder>${boolStr cfg.transcoding.enableIntelLowPowerEncoding}</EnableIntelLowPowerH264HwEncoder>
            <EnableIntelLowPowerHevcHwEncoder>${boolStr cfg.transcoding.enableIntelLowPowerEncoding}</EnableIntelLowPowerHevcHwEncoder>
            <EnableDecodingColorDepth10HevcRext>${boolStr (builtins.elem "hevcRExt10bit" cfg.transcoding.hardwareDecodingCodecs)}</EnableDecodingColorDepth10HevcRext>
            <EnableDecodingColorDepth12HevcRext>${boolStr (builtins.elem "hevcRExt12bit" cfg.transcoding.hardwareDecodingCodecs)}</EnableDecodingColorDepth12HevcRext>
            <HardwareDecodingCodecs>
              ${lib.optionalString (filteredDecodingCodecs != [])
                (lib.concatMapStringsSep "\n      " (codec: "<string>${escapeXML codec}</string>") filteredDecodingCodecs)}
            </HardwareDecodingCodecs>
          </EncodingOptions>
        '';
        mode = "0644";
      };
    };

    systemd = {
      tmpfiles.settings.jellyfinDirs = {
        "${cfg.dataDir}"."d" = {
          mode = "700";
          inherit (cfg) user group;
        };
        "${cfg.configDir}"."d" = {
          mode = "700";
          inherit (cfg) user group;
        };
        "${cfg.logDir}"."d" = {
          mode = "700";
          inherit (cfg) user group;
        };
        "${cfg.cacheDir}"."d" = {
          mode = "700";
          inherit (cfg) user group;
        };
      };
      services.jellyfin = {
        description = "Jellyfin Media Server";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        # This is mostly follows: https://github.com/jellyfin/jellyfin/blob/master/fedora/jellyfin.service
        # Upstream also disable some hardenings when running in LXC, we do the same with the isContainer option
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          UMask = "0077";
          WorkingDirectory = cfg.dataDir;
          ExecStart = "${getExe cfg.package} --datadir '${cfg.dataDir}' --configdir '${cfg.configDir}' --cachedir '${cfg.cacheDir}' --logdir '${cfg.logDir}'";
          ExecStartPre = lib.optionals cfg.hardwareAcceleration.enable [
            "${pkgs.coreutils}/bin/mkdir -p ${cfg.configDir}"
            "${pkgs.coreutils}/bin/cp /etc/jellyfin/encoding.xml ${cfg.configDir}/encoding.xml"
          ];
          Restart = "on-failure";
          TimeoutSec = 15;
          SuccessExitStatus = [
            "0"
            "143"
          ];

          # Security options:
          NoNewPrivileges = true;
          SystemCallArchitectures = "native";
          # AF_NETLINK needed because Jellyfin monitors the network connection
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
          ];
          RestrictNamespaces = !config.boot.isContainer;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          ProtectControlGroups = !config.boot.isContainer;
          ProtectHostname = true;
          ProtectKernelLogs = !config.boot.isContainer;
          ProtectKernelModules = !config.boot.isContainer;
          ProtectKernelTunables = !config.boot.isContainer;
          LockPersonality = true;
          PrivateTmp = !config.boot.isContainer;
          # needed for hardware acceleration
          PrivateDevices = !cfg.hardwareAcceleration.enable;
          DeviceAllow = lib.optionals (
            cfg.hardwareAcceleration.enable && cfg.hardwareAcceleration.devices != [ ]
          ) (map (device: "${device} rw") cfg.hardwareAcceleration.devices);
          PrivateUsers = true;
          RemoveIPC = true;

          SystemCallFilter = [
            "~@clock"
            "~@aio"
            "~@chown"
            "~@cpu-emulation"
            "~@debug"
            "~@keyring"
            "~@memlock"
            "~@module"
            "~@mount"
            "~@obsolete"
            "~@privileged"
            "~@raw-io"
            "~@reboot"
            "~@setuid"
            "~@swap"
          ];
          SystemCallErrorNumber = "EPERM";
        };
      };
    };

    users.users = mkIf (cfg.user == "jellyfin") {
      jellyfin = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "jellyfin") {
      jellyfin = { };
    };

    networking.firewall = mkIf cfg.openFirewall {
      # from https://jellyfin.org/docs/general/networking/index.html
      allowedTCPPorts = [
        8096
        8920
      ];
      allowedUDPPorts = [
        1900
        7359
      ];
    };

  };

  meta.maintainers = with maintainers; [
    minijackson
    fsnkty
  ];
}

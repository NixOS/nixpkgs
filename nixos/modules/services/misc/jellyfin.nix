{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkIf
    mkDefault
    getExe
    maintainers
    mkEnableOption
    mkOption
    mkPackageOption
    boolToString
    escapeXML
    nameValuePair
    optionalString
    concatMapStringsSep
    escapeShellArg
    literalExpression
    ;
  inherit (lib.types)
    bool
    enum
    ints
    nullOr
    path
    str
    submodule
    ;
  cfg = config.services.jellyfin;
  filteredDecodingCodecs = builtins.filter (
    c: c != "hevcRExt10bit" && c != "hevcRExt12bit" && cfg.transcoding.hardwareDecodingCodecs.${c}
  ) (builtins.attrNames cfg.transcoding.hardwareDecodingCodecs);
  encodingXmlText = ''
    <?xml version="1.0" encoding="utf-8"?>
    <EncodingOptions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <HardwareAccelerationType>${cfg.hardwareAcceleration.type}</HardwareAccelerationType>
      ${optionalString (
        cfg.hardwareAcceleration.type == "vaapi" && cfg.hardwareAcceleration.device != null
      ) "<VaapiDevice>${escapeXML cfg.hardwareAcceleration.device}</VaapiDevice>"}
      ${optionalString (
        cfg.hardwareAcceleration.type == "qsv" && cfg.hardwareAcceleration.device != null
      ) "<OpenclDevice>${escapeXML cfg.hardwareAcceleration.device}</OpenclDevice>"}
      <EncodingThreadCount>${
        if cfg.transcoding.threadCount != null then toString cfg.transcoding.threadCount else "-1"
      }</EncodingThreadCount>
      <EnableThrottling>${boolToString cfg.transcoding.throttleTranscoding}</EnableThrottling>
      <EnableTonemapping>${boolToString cfg.transcoding.enableToneMapping}</EnableTonemapping>
      <EnableSubtitleExtraction>${boolToString cfg.transcoding.enableSubtitleExtraction}</EnableSubtitleExtraction>
      <H264Crf>${toString cfg.transcoding.h264Crf}</H264Crf>
      <H265Crf>${toString cfg.transcoding.h265Crf}</H265Crf>
      <EnableHardwareEncoding>${boolToString cfg.transcoding.enableHardwareEncoding}</EnableHardwareEncoding>
      <AllowHevcEncoding>${boolToString cfg.transcoding.hardwareEncodingCodecs.hevc}</AllowHevcEncoding>
      <AllowAv1Encoding>${boolToString cfg.transcoding.hardwareEncodingCodecs.av1}</AllowAv1Encoding>
      <EnableIntelLowPowerH264HwEncoder>${boolToString cfg.transcoding.enableIntelLowPowerEncoding}</EnableIntelLowPowerH264HwEncoder>
      <EnableIntelLowPowerHevcHwEncoder>${boolToString cfg.transcoding.enableIntelLowPowerEncoding}</EnableIntelLowPowerHevcHwEncoder>
      <EnableDecodingColorDepth10HevcRext>${boolToString cfg.transcoding.hardwareDecodingCodecs.hevcRExt10bit}</EnableDecodingColorDepth10HevcRext>
      <EnableDecodingColorDepth12HevcRext>${boolToString cfg.transcoding.hardwareDecodingCodecs.hevcRExt12bit}</EnableDecodingColorDepth12HevcRext>
      <HardwareDecodingCodecs>
        ${concatMapStringsSep "\n    " (
          codec: "<string>${escapeXML codec}</string>"
        ) filteredDecodingCodecs}
      </HardwareDecodingCodecs>
    </EncodingOptions>
  '';
  encodingXmlFile = pkgs.writeText "encoding.xml" encodingXmlText;
  codecListToType =
    desc: list:
    submodule {
      options = builtins.listToAttrs (
        map (
          name:
          nameValuePair name (mkOption {
            type = bool;
            default = false;
            description = "Enable ${desc} for ${name} codec.";
          })
        ) list
      );
    };
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
        defaultText = literalExpression ''"''${cfg.dataDir}/config"'';
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
        defaultText = literalExpression ''"''${cfg.dataDir}/log"'';
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

        device = mkOption {
          type = nullOr path;
          default = null;
          example = "/dev/dri/renderD128";
          description = ''
            Path to the hardware acceleration device that Jellyfin should use.
            For obscure configurations, additional devices can be added via
            {option}`systemd.services.jellyfin.serviceConfig.DeviceAllow`.
          '';
        };

        # see MediaBrowser.Model/Entities/HardwareAccelerationType.cs in jellyfin source
        type = mkOption {
          type = enum [
            "none"
            "amf"
            "qsv"
            "nvenc"
            "v4l2m2m"
            "vaapi"
            # videotoolbox is MacOS-only
            "rkmpp"
          ];
          default = "none";
          description = ''
            The method of hardware acceleration. See [Hardware Acceleration](https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration) for more details.
          '';
        };
      };

      forceEncodingConfig = mkOption {
        type = bool;
        default = false;
        description = ''
          Whether to overwrite Jellyfin's `encoding.xml` configuration file on each service start.

          When enabled, the encoding configuration specified in {option}`services.jellyfin.transcoding`
          and {option}`services.jellyfin.hardwareAcceleration` will be applied on every service restart.
          A backup of the existing `encoding.xml` will be created at `encoding.xml.backup-$timestamp`.

          ::: {.warning}
          Enabling this option means that any changes made to transcoding settings through
          Jellyfin's web dashboard will be lost on the next service restart. The NixOS configuration
          becomes the single source of truth for encoding settings.
          :::

          When disabled (the default), the encoding configuration is only written if no `encoding.xml`
          exists yet. This allows settings to be changed through Jellyfin's web dashboard and persist
          across restarts, but means the NixOS configuration options will be ignored after the initial setup.
        '';
      };

      transcoding = {
        maxConcurrentStreams = mkOption {
          type = nullOr ints.positive;
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
          type = nullOr ints.positive;
          default = null;
          example = 4;
          description = ''
            Number of threads to use when transcoding.
            Set to null to use automatic detection.
          '';
        };

        hardwareDecodingCodecs = mkOption {
          type = codecListToType "hardware decoding" [
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
          ];
          default = { };
          example = {
            vp9 = true;
            h264 = true;
          };
          description = ''
            Which codecs to enable for hardware decoding.
          '';
        };

        hardwareEncodingCodecs = mkOption {
          type = codecListToType "hardware encoding" [
            "hevc"
            "av1"
          ];
          default = { };
          example = {
            av1 = true;
          };
          description = ''
            Which codecs to enable for hardware encoding. h264 is always enabled.
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
          type = ints.between 0 51;
          default = 23;
          description = ''
            Constant Rate Factor (CRF) for H.264 encoding. Lower values result in better quality. Range: 0-51.
          '';
        };

        h265Crf = mkOption {
          type = ints.between 0 51;
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
        assertion = cfg.hardwareAcceleration.enable -> cfg.hardwareAcceleration.device != null;
        message = "services.jellyfin.hardwareAcceleration.device cannot be null when hardware acceleration is enabled.";
      }
    ];

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

        preStart = mkIf cfg.hardwareAcceleration.enable (
          ''
            configDir=${escapeShellArg cfg.configDir}
            encodingXml="$configDir/encoding.xml"
          ''
          + (
            if cfg.forceEncodingConfig then
              ''
                if [[ -e $encodingXml ]]; then
                  # this intentionally removes trailing newlines
                  currentText="$(<"$encodingXml")"
                  configuredText="$(<${encodingXmlFile})"
                  if [[ $currentText == "$configuredText" ]]; then
                    # don't need to do anything
                    exit 0
                  else
                    encodingXmlBackup="$configDir/encoding.xml.backup-$(date -u +"%FT%H_%M_%SZ")"
                    mv --update=none-fail -T "$encodingXml" "$encodingXmlBackup"
                  fi
                fi
                cp --update=none-fail -T ${encodingXmlFile} "$encodingXml"
                chmod u+w "$encodingXml"
              ''
            else
              ''
                if [[ -e $encodingXml ]]; then
                  # this intentionally removes trailing newlines
                  currentText="$(<"$encodingXml")"
                  configuredText="$(<${encodingXmlFile})"
                  if [[ $currentText != "$configuredText" ]]; then
                    echo "WARN: $encodingXml already exists and is different from the configured settings. transcoding options NOT applied." >&2
                    echo "WARN: Set config.services.jellyfin.forceEncodingConfig = true to override." >&2
                  fi
                else
                  cp --update=none-fail -T ${encodingXmlFile} "$encodingXml"
                  chmod u+w "$encodingXml"
                fi
              ''
          )
        );

        # This is mostly follows: https://github.com/jellyfin/jellyfin/blob/master/fedora/jellyfin.service
        # Upstream also disable some hardenings when running in LXC, we do the same with the isContainer option
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          UMask = "0077";
          WorkingDirectory = cfg.dataDir;
          ExecStart = "${getExe cfg.package} --datadir '${cfg.dataDir}' --configdir '${cfg.configDir}' --cachedir '${cfg.cacheDir}' --logdir '${cfg.logDir}'";
          Restart = "on-failure";
          TimeoutSec = 15;
          SuccessExitStatus = [
            "0"
            "143"
          ];

          # Security options:
          CapabilityBoundingSet = [ "" ];
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
          ProcSubset = "pid";
          ProtectControlGroups = !config.boot.isContainer;
          ProtectClock = true;
          ProtectHostname = true;
          ProtectKernelLogs = !config.boot.isContainer;
          ProtectKernelModules = !config.boot.isContainer;
          ProtectKernelTunables = !config.boot.isContainer;
          ProtectProc = "invisible";
          ProtectSystem = true;
          LockPersonality = true;
          PrivateTmp = !config.boot.isContainer;
          # needed for hardware acceleration
          # PrivateDevices defaults to false for backwards compatibility - users may have
          # hardware acceleration set up outside of NixOS configuration
          PrivateDevices = mkDefault false;
          DeviceAllow = mkIf cfg.hardwareAcceleration.enable [ "${cfg.hardwareAcceleration.device} rw" ];
          PrivateUsers = true;
          RemoveIPC = true;

          SystemCallFilter = [
            "@system-service"
            "~@privileged"
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

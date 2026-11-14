{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.galene-stt;
in
{
  options = {
    services.galene-stt = {
      enable = lib.mkEnableOption "Galene Speech-to-Text bot";

      package = lib.mkPackageOption pkgs "galene-stt" { };

      groupUrl = lib.mkOption {
        type = lib.types.str;
        example = "https://galene.example.org:8443/group/public/";
        description = "URL of the Galene group to connect to.";
      };

      model = lib.mkOption {
        type = lib.types.path;
        example = "/var/lib/whisper/ggml-medium.bin";
        description = ''
          Path to the whisper.cpp model file (GGML format). Upstream recommends at least
          the 'medium' model for useful real-time transcription.
        '';
      };

      username = lib.mkOption {
        type = lib.types.str;
        default = "speech-to-text";
        description = ''
          Username to use for login. The user must exist in the Galene group with
          the 'caption' permission (or 'message' permission if `chat` is enabled).
        '';
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.externalPath;
        default = null;
        example = "/run/keys/stt-password";
        description = "File containing the password for login.";
      };

      caption = lib.mkOption {
        type = lib.types.bool;
        default = !cfg.chat;
        defaultText = lib.literalExpression "!config.services.galene-stt.chat";
        description = ''
          Whether to display inferred text as captions in the Galene room.
          Requires the user in Galene to have the 'caption' permission.
          Note that if both `caption` and `chat` are true, `caption` takes precedence upstream.
        '';
      };

      chat = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to display inferred text as chat messages in the Galene room.
          Requires the user in Galene to have the 'message' permission.
        '';
      };

      language = lib.mkOption {
        type = lib.types.str;
        default = "en";
        description = "Language of input, or 'auto' for autodetection.";
      };

      translate = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to translate foreign languages into English.";
      };

      gpu = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to run inference on GPU if possible.";
      };

      insecure = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to skip server certificate verification.";
      };

      silence = lib.mkOption {
        type = lib.types.nullOr lib.types.float;
        default = null;
        example = 0.07;
        description = "Maximum volume required to start a new phrase (default: 0.07).";
      };

      silenceTime = lib.mkOption {
        type = lib.types.nullOr lib.types.float;
        default = null;
        example = 0.3;
        description = "Seconds of silence required to start a new phrase (default: 0.3).";
      };

      keepSilence = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to pass silence segments to the engine instead of discarding them.";
      };

      debug = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable protocol debug logging.";
      };

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Extra command-line arguments passed to galene-stt.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.galene-stt = {
      description = "Galene Speech-to-Text bot";
      after = [
        "network-online.target"
      ]
      ++ lib.optional (config.services.galene.enable or false) "galene.service";
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart =
          let
            startScript = pkgs.writeShellScript "galene-stt-start" ''
              ARGS=(
                ${lib.optionalString cfg.caption "-caption"}
                ${lib.optionalString cfg.chat "-chat"}
                ${lib.optionalString cfg.debug "-debug"}
                ${lib.optionalString cfg.insecure "-insecure"}
                ${lib.optionalString (!cfg.gpu) "-gpu=false"}
                ${lib.optionalString cfg.translate "-translate"}
                ${lib.optionalString cfg.keepSilence "-keep-silence"}
                ${lib.optionalString (cfg.silence != null) "-silence ${toString cfg.silence}"}
                ${lib.optionalString (cfg.silenceTime != null) "-silence-time ${toString cfg.silenceTime}"}
                -lang ${lib.escapeShellArg cfg.language}
                -model ${lib.escapeShellArg (toString cfg.model)}
                -username ${lib.escapeShellArg cfg.username}
              )

              if [ -n "''${CREDENTIALS_DIRECTORY:-}" ] && [ -f "''${CREDENTIALS_DIRECTORY}/password" ]; then
                ARGS+=(-password "$(< "''${CREDENTIALS_DIRECTORY}/password")")
              fi

              exec ${lib.getExe cfg.package} "''${ARGS[@]}" ${lib.escapeShellArgs cfg.extraArgs} ${lib.escapeShellArg cfg.groupUrl}
            '';
          in
          "${startScript}";

        LoadCredential = lib.optional (cfg.passwordFile != null) "password:${cfg.passwordFile}";

        Restart = "always";
        RestartSec = "5s";

        # Hardening
        DynamicUser = true;
        SupplementaryGroups = [
          "render"
          "video"
        ];

        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        DeviceAllow = [
          "/dev/dri"
          "char-drm"
          "char-kfd"
          "char-nvidiactl"
          "char-nvidia-caps"
          "char-nvidia-frontend"
          "char-nvidia-uvm"
        ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = false; # Required for GPU acceleration
        PrivateTmp = true;
        PrivateUsers = true;
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
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
      };
    };
  };

  meta = { inherit (pkgs.galene-stt.meta) teams maintainers; };
}

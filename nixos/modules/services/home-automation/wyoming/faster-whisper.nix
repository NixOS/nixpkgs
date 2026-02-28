{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.wyoming.faster-whisper;

  inherit (lib)
    mapAttrsToList
    mkOption
    mkEnableOption
    mkPackageOption
    optionals
    types
    ;

  inherit (utils)
    escapeSystemdExecArgs
    ;
in

{
  options.services.wyoming.faster-whisper = with types; {
    package = mkPackageOption pkgs "wyoming-faster-whisper" { };

    servers = mkOption {
      default = { };
      description = ''
        Attribute set of wyoming-faster-whisper instances to spawn.
      '';
      type = attrsOf (
        submodule (
          { name, ... }:
          {
            options = {
              enable = mkEnableOption "Wyoming faster-whisper server";

              zeroconf = {
                enable = mkEnableOption "zeroconf discovery" // {
                  default = true;
                };

                name = mkOption {
                  type = str;
                  default = "faster-whisper-${name}";
                  description = ''
                    The advertised name for zeroconf discovery.
                  '';
                };
              };

              sttLibrary = mkOption {
                type = enum [
                  "auto"
                  "faster-whisper"
                  "onnx-asr"
                  "sherpa"
                  "transformers"
                ];
                default = "auto";
                example = "sherpa";
                description = ''
                  Library used for speech-to-text process.

                  When set to `auto` picks a default based on the {option}`language`.
                '';
              };

              model = mkOption {
                type = str;
                default = "auto";
                example = "sherpa-onnx-nemo-parakeet-tdt-0.6b-v3-int8";
                # https://github.com/home-assistant/addons/blob/master/whisper/DOCS.md#option-model
                description = ''
                  Name of the voice model to use. Can also be a HuggingFace model ID or a path to
                  a custom model directory.

                  When set to `auto` picks a default based on the {option}`language`,

                  With {option}`sttLibrary` set to `transformers`, a HuggingFace transformers Whisper model
                  ID from HuggingFace like `openai/whisper-tiny` or `openai/whisper-base` must be used.

                  Compressed models (`int8`) are slightly less accurate, but smaller and faster.
                  Distilled models are uncompressed and faster and smaller than non-distilled models.

                  Available models for faster-whisper:
                  - `tiny-int8` (compressed)
                  - `tiny`
                  - `tiny.en` (English only)
                  - `base-int8` (compressed)
                  - `base`
                  - `base.en` (English only)
                  - `small-int8` (compressed)
                  - `distil-small.en` (distilled, English only)
                  - `small`
                  - `small.en` (English only)
                  - `medium-int8` (compressed)
                  - `distil-medium.en` (distilled, English only)
                  - `medium`
                  - `medium.en` (English only)
                  - `large`
                  - `large-v1`
                  - `distil-large-v2` (distilled, English only)
                  - `large-v2`
                  - `distil-large-v3` (distilled, English only)
                  - `large-v3`
                  - `turbo` (faster than large-v3)
                '';
              };

              uri = mkOption {
                type = strMatching "^(tcp|unix)://.*$";
                example = "tcp://0.0.0.0:10300";
                description = ''
                  URI to bind the wyoming server to.
                '';
              };

              device = mkOption {
                # https://opennmt.net/CTranslate2/python/ctranslate2.models.Whisper.html#
                type = enum [
                  "cpu"
                  "cuda"
                  "auto"
                ];
                default = "cpu";
                description = ''
                  Determines the platform faster-whisper is run on. CPU works everywhere, CUDA requires a compatible NVIDIA GPU.
                '';
              };

              language = mkOption {
                type = enum [
                  # https://github.com/home-assistant/addons/blob/master/whisper/config.yaml#L20
                  "auto"
                  "af"
                  "am"
                  "ar"
                  "as"
                  "az"
                  "ba"
                  "be"
                  "bg"
                  "bn"
                  "bo"
                  "br"
                  "bs"
                  "ca"
                  "cs"
                  "cy"
                  "da"
                  "de"
                  "el"
                  "en"
                  "es"
                  "et"
                  "eu"
                  "fa"
                  "fi"
                  "fo"
                  "fr"
                  "gl"
                  "gu"
                  "ha"
                  "haw"
                  "he"
                  "hi"
                  "hr"
                  "ht"
                  "hu"
                  "hy"
                  "id"
                  "is"
                  "it"
                  "ja"
                  "jw"
                  "ka"
                  "kk"
                  "km"
                  "kn"
                  "ko"
                  "la"
                  "lb"
                  "ln"
                  "lo"
                  "lt"
                  "lv"
                  "mg"
                  "mi"
                  "mk"
                  "ml"
                  "mn"
                  "mr"
                  "ms"
                  "mt"
                  "my"
                  "ne"
                  "nl"
                  "nn"
                  "no"
                  "oc"
                  "pa"
                  "pl"
                  "ps"
                  "pt"
                  "ro"
                  "ru"
                  "sa"
                  "sd"
                  "si"
                  "sk"
                  "sl"
                  "sn"
                  "so"
                  "sq"
                  "sr"
                  "su"
                  "sv"
                  "sw"
                  "ta"
                  "te"
                  "tg"
                  "th"
                  "tk"
                  "tl"
                  "tr"
                  "tt"
                  "uk"
                  "ur"
                  "uz"
                  "vi"
                  "yi"
                  "yue"
                  "yo"
                  "zh"
                ];
                example = "en";
                description = ''
                  The language used to to parse words and sentences.
                '';
              };

              initialPrompt = mkOption {
                type = nullOr str;
                default = null;
                # https://github.com/home-assistant/addons/blob/master/whisper/DOCS.md#option-custom_model_type
                example = ''
                  The following conversation takes place in the universe of
                  Wizard of Oz. Key terms include 'Yellow Brick Road' (the path
                  to follow), 'Emerald City' (the ultimate goal), and 'Ruby
                  Slippers' (the magical tools to succeed). Keep these in mind as
                  they guide the journey.
                '';
                description = ''
                  Optional text to provide as a prompt for the first window. This can be used to provide, or
                  "prompt-engineer" a context for transcription, e.g. custom vocabularies or proper nouns
                  to make it more likely to predict those word correctly.

                  Only supported when the {option}`sttLibrary` is `faster-whisper`.
                '';
              };

              beamSize = mkOption {
                type = ints.unsigned;
                default = 0;
                example = 5;
                description = ''
                  The number of beams to use in beam search.

                  The default (`0`) will use 1 beam on ARM systems (assumes an ARM SBC) and 5 everywhere else.
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
          }
        )
      );
    };
  };

  config =
    let
      inherit (lib)
        mapAttrs'
        mkIf
        nameValuePair
        ;
    in
    mkIf (cfg.servers != { }) {
      assertions = mapAttrsToList (server: options: {
        assertion = options.sttLibrary != "faster-whisper" -> options.initialPrompt == null;
        message = "wyoming-faster-whisper/${server}: Initial prompt is only supported when using `faster-whisper` as `sttLibrary`.";
      }) cfg.servers;

      systemd.services = mapAttrs' (
        server: options:
        let
          finalPackage = cfg.package.overridePythonAttrs (oldAttrs: {
            dependencies =
              oldAttrs.dependencies
              ++ optionals options.zeroconf.enable oldAttrs.optional-dependencies.zeroconf
              ++ optionals (
                options.sttLibrary == "onnx-asr" || options.sttLibrary == "auto" && options.language == "ru"
              ) oldAttrs.optional-dependencies.onnx_asr
              ++ optionals (
                options.sttLibrary == "sherpa-onnx" || options.sttLibrary == "auto" && options.language == "en"
              ) oldAttrs.optional-dependencies.sherpa
              ++ optionals (options.sttLibrary == "transformers") oldAttrs.optional-dependencies.transformers;
          });
        in
        nameValuePair "wyoming-faster-whisper-${server}" {
          inherit (options) enable;
          description = "Wyoming faster-whisper server instance ${server}";
          wants = [
            "network-online.target"
          ];
          after = [
            "network-online.target"
          ];
          wantedBy = [
            "multi-user.target"
          ];
          # https://github.com/rhasspy/wyoming-faster-whisper/issues/27
          # https://github.com/NixOS/nixpkgs/issues/429974
          environment."HF_HOME" = "/tmp";
          serviceConfig = {
            DynamicUser = true;
            User = "wyoming-faster-whisper";
            StateDirectory = [ "wyoming/faster-whisper" ];
            # https://github.com/home-assistant/addons/blob/master/whisper/rootfs/etc/s6-overlay/s6-rc.d/whisper/run
            ExecStart = escapeSystemdExecArgs (
              [
                (lib.getExe finalPackage)
                "--data-dir"
                "/var/lib/wyoming/faster-whisper"
                "--uri"
                options.uri
                "--device"
                options.device
                "--stt-library"
                options.sttLibrary
                "--model"
                options.model
                "--language"
                options.language
                "--beam-size"
                options.beamSize
              ]
              ++ lib.optionals options.zeroconf.enable [
                "--zeroconf"
                options.zeroconf.name
              ]
              ++ lib.optionals (options.initialPrompt != null) [
                "--initial-prompt"
                options.initialPrompt
              ]
              ++ options.extraArgs
            );
            CapabilityBoundingSet = "";
            DeviceAllow =
              if
                builtins.elem options.device [
                  "cuda"
                  "auto"
                ]
              then
                [
                  # https://docs.nvidia.com/dgx/pdf/dgx-os-5-user-guide.pdf
                  "char-nvidia-uvm"
                  "char-nvidia-frontend"
                  "char-nvidia-caps"
                  "char-nvidiactl"
                ]
              else
                "";
            DevicePolicy = "closed";
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            PrivateUsers = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectControlGroups = true;
            ProtectProc = "invisible";
            # "all" is required because faster-whisper accesses /proc/cpuinfo to determine cpu capabilities
            ProcSubset = "all";
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
            ]
            ++ lib.optionals options.zeroconf.enable [
              # Zeroconf support require network interface enumeration
              "AF_NETLINK"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
            ];
            UMask = "0077";
          };
        }
      ) cfg.servers;
    };
}

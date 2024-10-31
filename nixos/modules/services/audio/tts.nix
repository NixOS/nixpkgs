{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.services.tts;
in

{
  options.services.tts = let
    inherit (lib) literalExpression mkOption mkEnableOption types;
  in  {
    servers = mkOption {
      type = types.attrsOf (types.submodule (
        { ... }: {
          options = {
            enable = mkEnableOption "Coqui TTS server";

            port = mkOption {
              type = types.port;
              example = 5000;
              description = ''
                Port to bind the TTS server to.
              '';
            };

            model = mkOption {
              type = types.nullOr types.str;
              default = "tts_models/en/ljspeech/tacotron2-DDC";
              example = null;
              description = ''
                Name of the model to download and use for speech synthesis.

                Check `tts-server --list_models` for possible values.

                Set to `null` to use a custom model.
              '';
            };

            useCuda = mkOption {
              type = types.bool;
              default = false;
              example = true;
              description = ''
                Whether to offload computation onto a CUDA compatible GPU.
              '';
            };

            extraArgs = mkOption {
              type = types.listOf types.str;
              default = [];
              description = ''
                Extra arguments to pass to the server commandline.
              '';
            };
          };
        }
      ));
      default = {};
      example = literalExpression ''
        {
          english = {
            port = 5300;
            model = "tts_models/en/ljspeech/tacotron2-DDC";
          };
          german = {
            port = 5301;
            model = "tts_models/de/thorsten/tacotron2-DDC";
          };
          dutch = {
            port = 5302;
            model = "tts_models/nl/mai/tacotron2-DDC";
          };
        }
      '';
      description = ''
        TTS server instances.
      '';
    };
  };

  config = let
    inherit (lib) mkIf mapAttrs' nameValuePair optionalString concatMapStringsSep escapeShellArgs;
  in mkIf (cfg.servers != {}) {
    systemd.services = mapAttrs' (server: options:
      nameValuePair "tts-${server}" {
        description = "Coqui TTS server instance ${server}";
        after = [
          "network-online.target"
        ];
        wantedBy = [
          "multi-user.target"
        ];
        path = with pkgs; [
          espeak-ng
        ];
        environment.HOME = "/var/lib/tts";
        serviceConfig = {
          DynamicUser = true;
          User = "tts";
          StateDirectory = "tts";
          ExecStart = "${pkgs.tts}/bin/tts-server --port ${toString options.port}"
            + optionalString (options.model != null) " --model_name ${options.model}"
            + optionalString (options.useCuda) " --use_cuda"
            + (concatMapStringsSep " " escapeShellArgs options.extraArgs);
          CapabilityBoundingSet = "";
          DeviceAllow = if options.useCuda then [
            # https://docs.nvidia.com/dgx/pdf/dgx-os-5-user-guide.pdf
            "/dev/nvidia1"
            "/dev/nvidia2"
            "/dev/nvidia3"
            "/dev/nvidia4"
            "/dev/nvidia-caps/nvidia-cap1"
            "/dev/nvidia-caps/nvidia-cap2"
            "/dev/nvidiactl"
            "/dev/nvidia-modeset"
            "/dev/nvidia-uvm"
            "/dev/nvidia-uvm-tools"
          ] else "";
          DevicePolicy = "closed";
          LockPersonality = true;
          # jit via numba->llvmpipe
          MemoryDenyWriteExecute = false;
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
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
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
      }) cfg.servers;
  };
}

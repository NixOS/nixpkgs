{ config, lib, options, pkgs, ...}:

with lib;

let
  cfg = config.services.comfyui;
  defaultUser = "comfyui";
  defaultGroup = defaultUser;
  service-name = "comfyui";
  mkComfyUIPackage = cfg: cfg.package.override {
    modelsPath = "${cfg.dataPath}/models";
    inputPath = "${cfg.dataPath}/input";
    outputPath = "${cfg.dataPath}/output";
    customNodes = cfg.customNodes;
    models = cfg.models;
  };
in
{
  options = {
    services.comfyui = {
      enable = mkEnableOption
        ("The most powerful and modular stable diffusion GUI with a graph/nodes interface.");

      dataPath = mkOption {
        type = types.str;
        default = "/var/lib/${service-name}";
        description = "Path to the folders which stores models, custom nodes, input and output files.";
      };

      # TODO: This should probably use the global system cudaSupport by default
      # and then allow overrides as necessary.
      cudaSupport = mkOption {
        type = types.bool;
        default = false;
        description = "Whether or not to enable CUDA for NVidia GPU acceleration.";
        defaultText = literalExpression "false";
        example = literalExpression "true";
      };

      rocmSupport = mkOption {
        type = types.bool;
        default = false;
        description = "Whether or not to enable ROCM for ATi GPU acceleration.";
        defaultText = literalExpression "false";
        example = literalExpression "true";
      };

      package = mkOption {
        type = types.package;
        default = (
          if config.cudaSupport
          then pkgs.comfyui-cuda
          else if config.rocmSupport
          then pkgs.comfyui-rocm
          else pkgs.comfyui-cpu
        );
        defaultText = literalExpression "pkgs.comfyui";
        example = literalExpression "pkgs.comfyui-rocm";
        description = "ComfyUI base package to use.";
      };

      user = mkOption {
        type = types.str;
        default = defaultUser;
        example = "yourUser";
        description = ''
          The user to run ComfyUI as.
          By default, a user named `${defaultUser}` will be created whose home
          directory will contain input, output, custom nodes and models.
        '';
      };

      group = mkOption {
        type = types.str;
        default = defaultGroup;
        example = "yourGroup";
        description = ''
          The group to run ComfyUI as.
          By default, a group named `${defaultUser}` will be created.
        '';
      };

      useCPU = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Uses the CPU for everything. Very slow, but needed if there is no hardware acceleration.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 8188;
        description = "Set the listen port for the Web UI and API.";
      };

      customNodes = mkOption {
        type = types.listOf types.package;
        default = [];
        description = "custom nodes to add to the ComfyUI setup. Expects a list of packages from pkgs.comfyui-custom-nodes";
      };

      listen = mkOption {
        type = types.str;
        # Assume a higher security posture by default.
        default = "127.0.0.1";
        description = "The net mask to listen to.";
        example = "0.0.0.0";
      };

      cors-origin-domain = mkOption {
        type = types.str;
        default = "disabled";
        description = ''The CORS domain to bless.  Use "disabled" to disable.  This must include a port'';
        example = "foo.com:443";
      };

      cuda-malloc = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = ''
          Force cuda-malloc.  Leave null to default.
        '';
      };

      max-upload-size = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          Max upload size.  Leave null to default.
        '';
      };

      multi-user = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable a simple multi-user mode.  This is helpful for separating user
          settings but offers nothing in terms of security.
        '';
      };

      cuda-device = mkOption {
        type = types.nullOr types.str;
        description = ''The CUDA device to use.  Query for this using lspci or lshw.  Leave as null to auto-detect.'';
        default = null;
      };

      verbose = mkOption {
        type = types.bool;
        description = ''Use verbose logging.'';
        default = false;
      };

      cross-attention = mkOption {
        type = types.nullOr (types.enum [
          "pytorch"
          "quad"
          "split"
        ]);
        description = ''Indicate which cross attention comfyui should use.'';
        default = null;
      };

      preview-method = mkOption {
        type = types.nullOr (types.enum [
          "none"
          "auto"
          "latent2rgb"
          "taesd"
        ]);
        description = ''How to preview images being generated.'';
        default = null;
      };

      # Argument dump:
      #  usage: comfyui [-h] [--listen [IP]] [--port PORT]
      #                 [--enable-cors-header [ORIGIN]]
      #                 [--max-upload-size MAX_UPLOAD_SIZE]
      #                 [--extra-model-paths-config PATH [PATH ...]]
      #                 [--output-directory OUTPUT_DIRECTORY]
      #                 [--temp-directory TEMP_DIRECTORY]
      #                 [--input-directory INPUT_DIRECTORY] [--auto-launch]
      #                 [--disable-auto-launch] [--cuda-device DEVICE_ID]
      #                 [--cuda-malloc | --disable-cuda-malloc]
      #                 [--dont-upcast-attention] [--force-fp32 | --force-fp16]
      #                 [--bf16-unet | --fp16-unet | --fp8_e4m3fn-unet | --fp8_e5m2-unet]
      #                 [--fp16-vae | --fp32-vae | --bf16-vae] [--cpu-vae]
      #                 [--fp8_e4m3fn-text-enc | --fp8_e5m2-text-enc | --fp16-text-enc | --fp32-text-enc]
      #                 [--directml [DIRECTML_DEVICE]] [--disable-ipex-optimize]
      #                 [--preview-method [none,auto,latent2rgb,taesd]]
      #                 [--use-split-cross-attention | --use-quad-cross-attention | --use-pytorch-cross-attention]
      #                 [--disable-xformers]
      #                 [--gpu-only | --highvram | --normalvram | --lowvram | --novram | --cpu]
      #                 [--disable-smart-memory] [--deterministic]
      #                 [--dont-print-server] [--quick-test-for-ci]
      #                 [--windows-standalone-build] [--disable-metadata]
      #                 [--multi-user] [--verbose]
      extraArgs = mkOption {
        type = types.attrsOf types.str;
        default = {};
        defaultText = literalExpression ''
          {
            disable-xformers = true;
            preview-method = "auto";
            verbose = true;
          }
        '';
        description = ''
          Additional arguments to be passed to comfyui.
        '';
      };

      models = mkOption (let
        src-option = mkOption {
          type = types.attrsOf types.package;
          default = {};
          description = ''
            A key value pair of names to fetchers for ComfyUI models.
          '';
        };
      in {
        type = types.submodule {
          options = {
            checkpoints    = src-option;
            clip           = src-option;
            clip_vision    = src-option;
            configs        = src-option;
            controlnet     = src-option;
            embeddings     = src-option;
            loras          = src-option;
            upscale_models = src-option;
            vae            = src-option;
            vae_approx     = src-option;
          };
        };
        default = {
          checkpoints = {};
          clip = {};
          clip_vision = {};
          configs = {};
          controlnet = {};
          embeddings = {};
          loras = {};
          upscale_models = {};
          vae = {};
          vae_approx = {};
        };
        description = ''
          Models for ComfyUI to use.  These are categorized by the model type
          (checkpoints, loras, vae, etc.).  Each of those are an attrset of
          names of the model (like `juggernaught-xl`) and a fetcher indicating
          the URL, type, and SHA of the model.
        '';
      });
    };
  };

  config = mkIf cfg.enable {
    users.users = mkIf (cfg.user == defaultUser) {
      ${defaultUser} =
        { group = cfg.group;
          home  = cfg.dataPath;
          createHome = true;
          description = "ComfyUI daemon user";
          isSystemUser = true;
        };
    };

    users.groups = mkIf (cfg.group == defaultGroup) {
      ${defaultGroup} = {};
    };

    systemd.services.comfyui = let
      package = mkComfyUIPackage cfg;
    in {
      description = "ComfyUI Service";
      wantedBy = [ "multi-user.target" ];
      environment = {
        DATA = cfg.dataPath;
      };

      preStart = let
        inherit (lib.trivial) throwIfNot;
        inherit (lib) isAttr isString;
        inherit (lib.strings) concatStrings intersperse;
        inherit (lib.lists) flatten;
        inherit (lib.attrsets) attrValues mapAttrsToList;
        join = (sep: (xs: concatStrings (intersperse sep xs)));
        join-lines = join "\n";
        src-to-symlink = path: name: (
          throwIfNot (isString path) "path must be a string."
          throwIfNot (isString name) "name must be a string."
            lib.traceVal ''
             ln -snf ${path}/${name} $out
            ''
        );

        # Take all of the model files for the various model types defined in the
        # config of `models`, and translate it into a series of symlink shell
        # invocations.  The destination corresponds to the definitions in
        # `config-data`.
        # ex:
        #
        # linkModels
        #   "/var/lib/comfyui/models"
        #   {
        #     checkpoints = {
        #       "sdxxl.safetensors" = pkgs.fetchurl {
        #         url = "foo.com/sdxxl-v123";
        #         sha256 = "sha-string";
        #       };
        #     };
        #     upscale_modules = {
        #       "controlnet.pth" = {
        #         fancy-pth = pkgs.fetchurl {
        #           url = "foo.com/fancy-pth-v456";
        #           sha256 = "sha-string";
        #         };
        #       };
        #     };
        #   }
        # Returns: ''
        # ln -snf <checkpoints.drv> /var/lib/comfyui/models/checkpoints
        # ln -snf <upscale_modules.drv> /var/lib/comfyui/models/upscale_modules
        # ''
        #
        linkModels = base-path: models:
          throwIfNot (isString base-path) "base-path must be a string."
            throwIfNot (isAttrs models) "models must be an attrset."
            (join-lines (builtins.map
              (x: ''
                  ln -snf ${x.drv} ${cfg.dataPath}/models/${x.model-type}
                '')
              (flatten
                (mapAttrsToList
                  (type: models-by-name: {
                    model-type = type;
                    drv = pkgs.linkFarm "comfyui-models-${type}" (
                      mapAttrsToList (name: path: {
                        inherit name path;
                      }) models-by-name
                    );
                  })
                  models
                )
              )
            ))
        ;
      in ''
        mkdir -p ${cfg.dataPath}/input
        mkdir -p ${cfg.dataPath}/output
        ln -snf ${package}/custom_nodes ${cfg.dataPath}/custom_nodes
        ln -snf ${package}/extra_model_paths.yaml ${cfg.dataPath}/extra_model_paths.yaml
        mkdir -p ${cfg.dataPath}/models
        ${linkModels "${cfg.dataPath}/models" cfg.models}
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        # These directories must be relative to /var/lib.  Absolute paths are
        # will error with:
        # <path-to-unit>: StateDirectory= path is absolute, ignoring: <abs-path>
        RuntimeDirectory = [ service-name ];
        StateDirectory = [ service-name ];
        WorkingDirectory = "/run/${service-name}";
        ExecStart = let
          args = cli.toGNUCommandLine {} ({
            cpu = cfg.useCPU;
            enable-cors-header = cfg.cors-origin-domain;
            cuda-device = cfg.cuda-device;
            listen = cfg.listen;
            max-upload-size = cfg.max-upload-size;
            multi-user = cfg.multi-user;
            port = cfg.port;
            verbose = cfg.verbose;
          }
          // (
            if cfg.cuda-malloc != null
            then (
              if cfg.cuda-malloc
              then { cuda-malloc = true; }
              else { disable-cuda-malloc = true; }
            )
            else {}
          )
          // (lib.optionalAttrs (cfg.cross-attention != null) {
            "use-${cfg.cross-attention}-cross-attention" = true;
          })
          // cfg.extraArgs);
        in ''${package}/bin/comfyui ${toString args}'';
        # comfyui is prone to crashing on long slow workloads.
        Restart = "always";
        StartLimitBurst = 3;
      };
      unitConfig = {
        # Prevent it from restarting _too_ much though.  Stop if three times a
        # minute.  This might need a better default from someone with better
        # sysadmin chops.
        StartLimitIntervalSec = "1m";
      };
    };
  };
}

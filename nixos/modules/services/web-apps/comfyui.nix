{ config, lib, options, pkgs, ...}:

with lib;

let
  cfg = config.services.comfyui;
  defaultUser = "comfyui";
  defaultGroup = defaultUser;
  mkComfyUIPackage = cfg: cfg.package.override {
    modelsPath = "${cfg.dataPath}/models";
    inputPath = "${cfg.dataPath}/input";
    outputPath = "${cfg.dataPath}/output";
    customNodes = cfg.customNodes;
  };
in
{
  options = {
    services.comfyui = {
      enable = mkEnableOption
        (mdDoc "The most powerful and modular stable diffusion GUI with a graph/nodes interface.");

      dataPath = mkOption {
        type = types.str;
        default = "/var/lib/comfyui";
        description = mdDoc "path to the folders which stores models, custom nodes, input and output files";
      };

      package = mkOption {
        type = types.package;
        default = (
          if config.cudaSupport
          then pkgs.comfyui-cuda
          else if config.rocmSupport
          then pkgs.comfyui-rocm
          else pkgs.comfyui
        );
        defaultText = literalExpression "pkgs.comfyui";
        example = literalExpression "pkgs.comfyui-rocm";
        description = mdDoc "ComfyUI base package to use";
      };

      user = mkOption {
        type = types.str;
        default = defaultUser;
        example = "yourUser";
        description = mdDoc ''
          The user to run ComfyUI as.
          By default, a user named `${defaultUser}` will be created whose home
          directory will contain input, output, custom nodes and models.
        '';
      };

      group = mkOption {
        type = types.str;
        default = defaultGroup;
        example = "yourGroup";
        description = mdDoc ''
          The group to run ComfyUI as.
          By default, a group named `${defaultUser}` will be created.
        '';
      };

      useCPU = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc ''
          Uses the CPU for everything. Very slow, but needed if there is no hardware acceleration.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 8188;
        description = mdDoc "Set the listen port for the Web UI and API.";
      };

      customNodes = mkOption {
        type = types.listOf types.package;
        default = [];
        description = mdDoc "custom nodes to add to the ComfyUI setup. Expects a list of packages from pkgs.comfyui-custom-nodes";
      };

      extraArgs = mkOption {
        type = types.str;
        default = "";
        example = "--preview-method auto";
        description = mdDoc ''
          Additional arguments to be passed to comfyui
        '';
      };
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

    systemd.services.comfyui = {
      description = "ComfyUI Service";
      wantedBy = [ "multi-user.target" ];
      environment = {
        DATA = cfg.dataPath;
      };

      preStart = ''
        mkdir -p $DATA/input
        mkdir -p $DATA/output
        mkdir -p $DATA/custom_nodes
        mkdir -p $DATA/models
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = let
          args = cli.toGNUCommandLine {} {
            cpu = cfg.useCPU;
            port = cfg.port;
          };
        in ''
          ${mkComfyUIPackage cfg}/bin/comfyui ${toString args} ${cfg.extraArgs}
        '';
        StateDirectory = cfg.dataPath;
        Restart = "always"; # comfyui is prone to crashing on long slow workloads.
      };
    };
  };
}

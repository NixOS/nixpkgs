{ config, lib, pkgs, ... }:
let
  inherit (lib) types;

  cfg = config.services.ollama;
  ollamaPackage = cfg.package.override {
    inherit (cfg) acceleration;
    linuxPackages = config.boot.kernelPackages // {
      nvidia_x11 = config.hardware.nvidia.package;
    };
  };
in
{
  options = {
    services.ollama = {
      enable = lib.mkEnableOption "ollama server for local large language models";
      package = lib.mkPackageOption pkgs "ollama" { };
      home = lib.mkOption {
        type = types.str;
        default = "%S/ollama";
        example = "/home/foo";
        description = ''
          The home directory that the ollama service is started in.
        '';
      };
      models = lib.mkOption {
        type = types.str;
        default = "%S/ollama/models";
        example = "/path/to/ollama/models";
        description = ''
          The directory that the ollama service will read models from and download new models to.
        '';
      };
      listenAddress = lib.mkOption {
        type = types.str;
        default = "127.0.0.1:11434";
        example = "0.0.0.0:11111";
        description = ''
          The address which the ollama server HTTP interface binds and listens to.
        '';
      };
      acceleration = lib.mkOption {
        type = types.nullOr (types.enum [ false "rocm" "cuda" ]);
        default = null;
        example = "rocm";
        description = ''
          What interface to use for hardware acceleration.

          - `null`: default behavior
            if `nixpkgs.config.rocmSupport` is enabled, uses `"rocm"`
            if `nixpkgs.config.cudaSupport` is enabled, uses `"cuda"`
            otherwise defaults to `false`
          - `false`: disable GPU, only use CPU
          - `"rocm"`: supported by most modern AMD GPUs
          - `"cuda"`: supported by most modern NVIDIA GPUs
        '';
      };
      environmentVariables = lib.mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          HOME = "/tmp";
          OLLAMA_LLM_LIBRARY = "cpu";
        };
        description = ''
          Set arbitrary environment variables for the ollama service.

          Be aware that these are only seen by the ollama server (systemd service),
          not normal invocations like `ollama run`.
          Since `ollama run` is mostly a shell around the ollama server, this is usually sufficient.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.ollama = {
      description = "Server for local large language models";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = cfg.environmentVariables // {
        HOME = cfg.home;
        OLLAMA_MODELS = cfg.models;
        OLLAMA_HOST = cfg.listenAddress;
      };
      serviceConfig = {
        ExecStart = "${lib.getExe ollamaPackage} serve";
        WorkingDirectory = cfg.home;
        StateDirectory = [ "ollama" ];
        DynamicUser = true;
      };
    };

    environment.systemPackages = [ ollamaPackage ];
  };

  meta.maintainers = with lib.maintainers; [ abysssol onny ];
}

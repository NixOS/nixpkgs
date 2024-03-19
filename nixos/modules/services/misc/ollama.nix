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
      listenAddress = lib.mkOption {
        type = types.str;
        default = "127.0.0.1:11434";
        example = "0.0.0.0:11111";
        description = ''
          The address which the ollama server HTTP interface binds and listens to.
        '';
      };
      acceleration = lib.mkOption {
        type = types.nullOr (types.enum [ "rocm" "cuda" ]);
        default = null;
        example = "rocm";
        description = ''
          What interface to use for hardware acceleration.

          - `rocm`: supported by modern AMD GPUs
          - `cuda`: supported by modern NVIDIA GPUs
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
        HOME = "%S/ollama";
        OLLAMA_MODELS = "%S/ollama/models";
        OLLAMA_HOST = cfg.listenAddress;
      };
      serviceConfig = {
        ExecStart = "${lib.getExe ollamaPackage} serve";
        WorkingDirectory = "%S/ollama";
        StateDirectory = [ "ollama" ];
        DynamicUser = true;
      };
    };

    environment.systemPackages = [ ollamaPackage ];
  };

  meta.maintainers = with lib.maintainers; [ abysssol onny ];
}

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
      enable = lib.mkEnableOption (
        lib.mdDoc "Server for local large language models"
      );
      listenAddress = lib.mkOption {
        type = types.str;
        default = "127.0.0.1:11434";
        description = lib.mdDoc ''
          Specifies the bind address on which the ollama server HTTP interface listens.
        '';
      };
      acceleration = lib.mkOption {
        type = types.nullOr (types.enum [ "rocm" "cuda" ]);
        default = null;
        example = "rocm";
        description = lib.mdDoc ''
          Specifies the interface to use for hardware acceleration.

          - `rocm`: supported by modern AMD GPUs
          - `cuda`: supported by modern NVIDIA GPUs
        '';
      };
      package = lib.mkPackageOption pkgs "ollama" { };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      services.ollama = {
        wantedBy = [ "multi-user.target" ];
        description = "Server for local large language models";
        after = [ "network.target" ];
        environment = {
          HOME = "%S/ollama";
          OLLAMA_MODELS = "%S/ollama/models";
          OLLAMA_HOST = cfg.listenAddress;
        };
        serviceConfig = {
          ExecStart = "${lib.getExe ollamaPackage} serve";
          WorkingDirectory = "/var/lib/ollama";
          StateDirectory = [ "ollama" ];
          DynamicUser = true;
        };
      };
    };

    environment.systemPackages = [ ollamaPackage ];
  };

  meta.maintainers = with lib.maintainers; [ abysssol onny ];
}

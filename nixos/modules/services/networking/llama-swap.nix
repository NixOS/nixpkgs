{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.llama-swap;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yml" cfg.settings;
in
{
  options.services.llama-swap = {
    enable = lib.mkEnableOption "enable the llama-swap service";

    package = lib.mkPackageOption pkgs "llama-swap" { };

    port = lib.mkOption {
      default = 8080;
      example = 11343;
      type = lib.types.port;
      description = ''
        Port that llama-swap listens on.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the firewall for llama-swap.
        This adds `services.llama-swap.port` to `networking.firewall.allowedTCPPorts`.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      description = ''
        llama-swap configuration. Refer to https://github.com/mostlygeek/llama-swap for details on supported values.
      '';
      example = ''
          {
          healthCheckTimeout = 60;
          models = {
            "deepcoder-14b" = {
              proxy = "http://127.0.0.1:8009";
              cmd = "$\{
            (pkgs.llama-cpp.override { rocmSupport = true; })
            }/bin/llama-server -m /var/lib/llama-cpp/models/agentica-org_DeepCoder-14B-Preview-Q6_K_L.gguf -md /var/lib/llama-cpp/models/agentica-org_DeepCoder-1.5B-Preview-Q6_K_L.gguf --port 8009 --ctx-size 16384 --flash-attn --n-gpu-layers 49 --n-gpu-layers-draft 29 --cache-type-k q8_0 --cache-type-v q8_0 --temp 0.6 --top-p 0.95 --log-colors --prio-batch 2 --prio 2 --no-webui";
            };
          };
        };
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.llama-swap = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      description = "llama-swap is a light weight, transparent proxy server that provides automatic model swapping to llama.cpp's server.";
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --listen :${toString cfg.port} --config ${configFile}";
        Restart = "on-failure";
        RestartSec = 3;
        Type = "exec";
        DynamicUser = true;
      };
    };
    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}

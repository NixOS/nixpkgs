{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.nvidia-gpu;
  inherit (lib) mkOption types concatStringsSep;
in
{
  port = 9835;

  extraOpts = {
    nvidiaSmiCommand = mkOption {
      type = types.str;
      default = "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
      defaultText = lib.literalExpression ''"''${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi"'';
      description = ''
        Path or command to be used for the nvidia-smi executable
      '';
    };
    queryFieldNames = mkOption {
      type = types.str;
      default = "AUTO";
      description = ''
        Comma-separated list of the query fields. You can find out possible fields by running `nvidia-smi --help-query-gpus`. The value `AUTO` will
        automatically detect the fields to query.
      '';
    };
    telemetryPath = mkOption {
      type = types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-nvidia-gpu-exporter}/bin/nvidia_gpu_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path ${cfg.telemetryPath} \
          --nvidia-smi-command ${cfg.nvidiaSmiCommand} \
          --query-field-names ${cfg.queryFieldNames} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      PrivateDevices = false;
    };
  };
}

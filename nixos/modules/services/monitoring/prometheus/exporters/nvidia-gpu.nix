{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.nvidia-gpu;
  inherit (lib)
    types
    concatStringsSep
    ;
in
{
  port = 9835;
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-nvidia-gpu-exporter}/bin/nvidia_gpu_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --nvidia-smi-command ${config.hardware.nvidia.package.bin}/bin/nvidia-smi \
          ${concatStringsSep " " cfg.extraFlags}
      '';
      PrivateDevices = false;
    };
    wantedBy = [ "multi-user.target" ];
  };
}

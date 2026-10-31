{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.prometheus.exporters.nvidia-gpu;
  inherit (lib)
    cli
    concatStringsSep
    filterAttrs
    mkOption
    mkPackageOption
    types
    ;
in
{
  port = 9835;
  extraOpts = {
    package = mkPackageOption pkgs "prometheus-nvidia-gpu-exporter" { };
    settings = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf (
          types.oneOf [
            types.bool
            types.str
            (types.listOf types.str)
          ]
        );
        options = {
          "collect.backend" = mkOption {
            type = types.enum [
              "exec"
              "nvml"
              "demo"
            ];
            default = "exec";
            description = "How to collect GPU metrics.";
          };
          "nvidia-smi-command" = mkOption {
            type = types.str;
            default = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi";
            defaultText = lib.literalExpression ''
              "''${config.hardware.nvidia.package.bin}/bin/nvidia-smi"
            '';
            description = "Path or command to be used for the nvidia-smi executable.";
          };
          "web.listen-address" = mkOption {
            type = types.str;
            default = "${cfg.listenAddress}:${toString cfg.port}";
            defaultText = lib.literalExpression ''
              "''${config.services.prometheus.exporters.nvidia-gpu.listenAddress}:''${toString config.services.prometheus.exporters.nvidia-gpu.port}"
            '';
            description = "Addresses on which to expose metrics and web interface.";
          };
        };
      };
      description = "Command line flags from the --help text of the exporter.";
    };
  };
  serviceOpts = {
    serviceConfig =
      let
        settings = filterAttrs (
          # specifying nvidia-smi-command when collect.backend isn't 'exec' errors
          n: v: if n == "nvidia-smi-command" && cfg.settings."collect.backend" != "exec" then false else true
        ) cfg.settings;
      in
      {
        ExecStart = ''
          ${lib.getExe cfg.package} \
            ${utils.escapeSystemdExecArgs (cli.toCommandLineGNU { explicitBool = false; } settings)} \
            ${concatStringsSep " " cfg.extraFlags}
        '';
        PrivateDevices = false;
      };
    wantedBy = [ "multi-user.target" ];
  };
}

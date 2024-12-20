{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.corefreq;
  kernelPackages = config.boot.kernelPackages;
in
{
  options = {
    programs.corefreq = {
      enable = lib.mkEnableOption "Whether to enable the corefreq daemon and kernel module";

      package = lib.mkOption {
        type = lib.types.package;
        default = kernelPackages.corefreq;
        defaultText = lib.literalExpression "config.boot.kernelPackages.corefreq";
        description = ''
          The corefreq package to use.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    boot.extraModulePackages = [ cfg.package ];
    boot.kernelModules = [ "corefreqk" ];

    # Create a systemd service for the corefreq daemon
    systemd.services.corefreq = {
      description = "CoreFreq daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = lib.getExe' cfg.package "corefreqd";
      };
    };
  };
}

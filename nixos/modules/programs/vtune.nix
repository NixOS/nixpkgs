{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.programs.vtune;
in
{
  options.programs.vtune = {
    enable = mkEnableOption "VTune Profiler";

    package = mkPackageOption pkgs "intel-oneapi-vtune" {
      nullable = true;
      extraDescription = ''
        Set to `null` to install only the kernel module.
      '';
    };

    modulePackage = mkOption {
      type = types.nullOr types.package;
      default = config.boot.kernelPackages.intel-vtune-sepdk.override {
        intel-oneapi-vtune = config.programs.package or pkgs.intel-oneapi-vtune;
      };
      defaultText = ''
        config.boot.kernelPackages.intel-vtune-sepdk.override {
          intel-oneapi-vtune = config.programs.vtune.package or pkgs.intel-oneapi-vtune;
        }
      '';
      example = "config.boot.kernelPackages.intel-vtune-sepdk";
      description = ''
        The package to use for the VTune Profiler kernel module.
        Set to `null` to disable the kernel module.
        An user should be in the `vtune` group to use the module.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.package != null) { environment.systemPackages = [ cfg.package ]; })

    (mkIf (cfg.modulePackage != null) {
      boot.extraModulePackages = [ cfg.modulePackage ];

      environment.systemPackages = [ cfg.modulePackage ];

      users.groups.vtune = { };

      systemd.services.vtune-sep5 = {
        description = "Load VTune SEP5 driver";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${cfg.modulePackage}/bin/insmod-sep --load-in-tree-driver";
          ExecStop = "${cfg.modulePackage}/bin/rmmod-sep";
          RemainAfterExit = true;
        };
      };
    })
  ]);

  meta.maintainers = [ lib.maintainers.xzfc ];
}

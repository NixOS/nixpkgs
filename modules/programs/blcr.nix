{ config, pkgs, ... }:

let
  inherit (pkgs.lib) mkOption mkIf;
  cfg = config.environment.blcr;
  blcrPkg = config.boot.kernelPackages.blcr;
in

{
  ###### interface

  options = {
    environment.blcr.enable = mkOption {
      default = false;
      description =
        "Wheter to enable support for the BLCR checkpointing tool.";
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    boot.kernelModules = [ "blcr" "blcr_imports" ];
    boot.extraModulePackages = [ blcrPkg ];
    environment.systemPackages = [ blcrPkg ];
  };
}

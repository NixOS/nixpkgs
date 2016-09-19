{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.environment.blcr;
  blcrPkg = config.boot.kernelPackages.blcr;
in

{
  ###### interface

  options = {
    environment.blcr.enable = mkEnableOption "support for the BLCR checkpointing tool";
  };

  ###### implementation

  config = mkIf cfg.enable {
    boot.kernelModules = [ "blcr" "blcr_imports" ];
    boot.extraModulePackages = [ blcrPkg ];
    environment.systemPackages = [ blcrPkg ];
  };
}

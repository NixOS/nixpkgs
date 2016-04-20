{ config, lib, ... }:

with lib;

let
  cfg = config.environment.blcr;
  kp = config.boot.kernelPackages;
in

{
  ###### interface

  options = {
    environment.blcr.enable = mkEnableOption' {
      name = "support for the BLCR checkpointing tool";
      #asserts #package = literalPackage' kp "kernelPackages" "blcr";
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    boot.kernelModules = [ "blcr" "blcr_imports" ];
    boot.extraModulePackages = [ kp.blcr ];
    environment.systemPackages = [ kp.blcr ];
  };
}

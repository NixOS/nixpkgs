{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.hardware.mwProCapture;

  kernelPackages = config.boot.kernelPackages;

in

{

  options.hardware.mwProCapture.enable = mkEnableOption "Magewell Pro Capture family kernel module";

  config = mkIf cfg.enable {

    assertions = singleton {
      assertion = versionAtLeast kernelPackages.kernel.version "3.2";
      message = "Magewell Pro Capture family module is not supported for kernels older than 3.2";
    };

    boot.kernelModules = [ "ProCapture" ];

    environment.systemPackages = [ kernelPackages.mwprocapture ];

    boot.extraModulePackages = [ kernelPackages.mwprocapture ];

  };

}

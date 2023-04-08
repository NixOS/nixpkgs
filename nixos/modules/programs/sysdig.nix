{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.sysdig;
in {
  options.programs.sysdig.enable = mkEnableOption (lib.mdDoc "sysdig");

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.sysdig ];
    boot.extraModulePackages = [ config.boot.kernelPackages.sysdig ];
  };
}

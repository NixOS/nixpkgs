{ config, lib, pkgs, ... }:

let
  cfg = config.programs.sysdig;
in {
  options.programs.sysdig.enable = lib.mkEnableOption "sysdig, a tracing tool";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.sysdig ];
    boot.extraModulePackages = [ config.boot.kernelPackages.sysdig ];
  };
}

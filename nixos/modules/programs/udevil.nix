{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.udevil;

in {
  options.programs.udevil.enable = mkEnableOption "udevil";

  config = mkIf cfg.enable {
    security.wrappers.udevil.source = "${lib.getBin pkgs.udevil}/bin/udevil";
  };
}

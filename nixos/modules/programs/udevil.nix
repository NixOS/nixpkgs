{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.udevil;

in {
  options.programs.udevil.enable = mkEnableOption (lib.mdDoc "udevil");

  config = mkIf cfg.enable {
    security.wrappers.udevil =
      { setuid = true;
        owner = "root";
        group = "root";
        source = "${lib.getBin pkgs.udevil}/bin/udevil";
      };
  };
}

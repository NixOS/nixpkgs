{ config, lib, pkgs, ... }:

let
  cfg = config.programs.mouse-actions;
in
  {
    options.programs.mouse-actions = {
      enable = lib.mkEnableOption ''
        mouse-actions udev rules. This is a prerequisite for using mouse-actions without being root
      '';
    };
    config = lib.mkIf cfg.enable {
      services.udev.packages = [ pkgs.mouse-actions ];
    };
  }

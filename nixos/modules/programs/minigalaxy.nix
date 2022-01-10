{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.minigalaxy;

  minigalaxy = pkgs.minigalaxy.override {
    withWine = cfg.withWine;
  };
in {
  options.programs.minigalaxy = {
    enable = mkEnableOption "minigalaxy";

    withWine = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Include wine in minigalaxy's PATH
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ minigalaxy ];
  };

  meta.maintainers = with maintainers; [ nickjanus ];
}

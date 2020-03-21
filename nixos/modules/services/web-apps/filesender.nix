{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.filesender;
in {
  options.services.filesender = {
    enable = mkEnableOption "filesender";
  };

  config = mkIf cfg.enable {
  };
}

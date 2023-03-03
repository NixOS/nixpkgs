{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.programs.extra-container;
in {
  options = {
    programs.extra-container.enable = mkEnableOption (lib.mdDoc ''
      extra-container, a tool for running declarative NixOS containers
      without host system rebuilds
    '');
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.extra-container ];
    boot.extraSystemdUnitPaths = [ "/etc/systemd-mutable/system" ];
  };
}

{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.iftop;
in {
  options = {
    programs.iftop.enable = mkEnableOption "iftop + setcap wrapper";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.iftop ];
    security.wrappers.iftop = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+p";
      source = "${pkgs.iftop}/bin/iftop";
    };
  };
}

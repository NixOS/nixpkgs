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
      source = "${pkgs.iftop}/bin/iftop";
      capabilities = "cap_net_raw+p";
    };
  };
}

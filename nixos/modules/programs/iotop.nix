{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.iotop;
in {
  options = {
    programs.iotop.enable = mkEnableOption "iotop + setcap wrapper";
  };
  config = mkIf cfg.enable {
    security.wrappers.iotop = {
      source = "${pkgs.iotop}/bin/iotop";
      capabilities = "cap_net_admin+p";
    };
  };
}

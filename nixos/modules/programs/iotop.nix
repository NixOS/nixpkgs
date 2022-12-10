{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.iotop;
in {
  options = {
    programs.iotop.enable = mkEnableOption (lib.mdDoc "iotop + setcap wrapper");
  };
  config = mkIf cfg.enable {
    security.wrappers.iotop = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_admin+p";
      source = "${pkgs.iotop}/bin/iotop";
    };
  };
}

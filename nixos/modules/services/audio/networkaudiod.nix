{ config, lib, pkgs, ... }:

with lib;

let
  name = "networkaudiod";
  cfg = config.services.networkaudiod;
in {
  options = {
    services.networkaudiod = {
      enable = mkEnableOption (lib.mdDoc "Networkaudiod (NAA)");
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ pkgs.networkaudiod ];
    systemd.services.networkaudiod.wantedBy = [ "multi-user.target" ];
  };
}

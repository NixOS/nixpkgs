{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.xastir;
in {
  meta.maintainers = with maintainers; [ melling ];

  options.programs.xastir = {
    enable = mkEnableOption (mdDoc "Xastir Graphical APRS client");
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ xastir ];
    security.wrappers.xastir = {
      source = "${pkgs.xastir}/bin/xastir";
      capabilities = "cap_net_raw+p";
      owner = "root";
      group = "root";
    };
  };
}

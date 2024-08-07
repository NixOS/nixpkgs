{ config, lib, pkgs, ... }:

let
  cfg = config.programs.xastir;
in {
  meta.maintainers = with lib.maintainers; [ melling ];

  options.programs.xastir = {
    enable = lib.mkEnableOption "Xastir Graphical APRS client";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ xastir ];
    security.wrappers.xastir = {
      source = "${pkgs.xastir}/bin/xastir";
      capabilities = "cap_net_raw+p";
      owner = "root";
      group = "root";
    };
  };
}

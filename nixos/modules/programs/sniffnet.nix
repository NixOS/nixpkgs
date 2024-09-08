{ config, lib, pkgs, ... }:

let
  cfg = config.programs.sniffnet;
in

{
  options = {
    programs.sniffnet = {
      enable = lib.mkEnableOption "sniffnet, a network traffic monitor application";
    };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.sniffnet = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw,cap_net_admin=eip";
      source = "${pkgs.sniffnet}/bin/sniffnet";
    };
  };

  meta.maintainers = with lib.maintainers; [ figsoda ];
}

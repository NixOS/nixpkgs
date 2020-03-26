{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pxe;
  netboot = pkgs.callPackage ./netboot.nix {};
in
{
  meta.maintainers = with maintainers; [ bbigras ];

  options = {
    services.pxe = {
      enable = mkEnableOption "Pxe";
    };
  };

  config = mkIf cfg.enable {
    services.pixiecore = {
      enable = true;
      mode = "boot";
      kernel = "${netboot}/bzImage";
      port = 8080;
      statusPort = 8080;
    };
  };
}

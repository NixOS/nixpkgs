{ config, lib, pkgs, ... }:

let
  cfg = config.programs.labwc;
in
{
  meta.maintainers = with lib.maintainers; [ AndersonTorres ];

  options.programs.labwc = {
    enable = lib.mkEnableOption "labwc";
    package = lib.mkPackageOption pkgs "labwc" { };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      environment.systemPackages = [ cfg.package ];

      xdg.portal.config.wlroots.default = lib.mkDefault [ "wlr" "gtk" ];

      # To make a labwc session available for certain DMs like SDDM
      services.displayManager.sessionPackages = [ cfg.package ];
    }
    (import ./wayland-session.nix { inherit lib pkgs; })
  ]);
}

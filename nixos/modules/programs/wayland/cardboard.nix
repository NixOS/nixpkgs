{ config, lib, pkgs, ... }:

let
  cfg = config.programs.cardboard;
in
{
  meta.maintainers = with lib.maintainers; [ AndersonTorres ];

  options.programs.cardboard = {
    enable = lib.mkEnableOption "cardboard";

    package = lib.mkPackageOption pkgs "cardboard" { };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      environment.systemPackages = [ cfg.package ];

      # To make a cardboard session available for certain DMs like SDDM
      services.displayManager.sessionPackages = [ cfg.package ];
    }
    (import ./wayland-session.nix { inherit lib pkgs; })
  ]);
}

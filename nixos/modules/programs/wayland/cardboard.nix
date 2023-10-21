{ config, lib, pkgs, ... }:

let
  cfg = config.programs.cardboard;
in
{
  meta.maintainers = with lib.maintainers; [ AndersonTorres ];

  options.programs.cardboard = {
    enable = lib.mkEnableOption (lib.mdDoc "cardboard");

    package = lib.mkOption {
      type = with lib.types; nullOr package;
      default = pkgs.cardboard;
      defaultText = lib.literalExpression "pkgs.cardboard";
      description = lib.mdDoc ''
        cardboard package to use.
      '';
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      environment.systemPackages = [ cfg.package ];

      # To make a cardboard session available for certain DMs like SDDM
      services.xserver.displayManager.sessionPackages = [ cfg.package ];
    }
    (import ./wayland-session.nix { inherit lib pkgs; })
  ]);
}

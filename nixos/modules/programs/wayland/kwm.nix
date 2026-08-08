{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.kwm;
in
{
  options.programs.kwm = {
    enable = lib.mkEnableOption "kwm";
    package = lib.mkPackageOption pkgs "kwm" { };
    withUWSM = lib.mkEnableOption "uwsm (Unified Wayland Session Manager) to run river without a display manager, activating `graphical-session.target` for the portal and XDG autostart services";
    extraPackages = lib.mkOption {
      type = with lib.types; listOf package;
      default = with pkgs; [
        swaylock
        foot
        dmenu
      ];

      defaultText = lib.literalExpression ''
        with pkgs; [ swaylock foot dmenu ];
      '';

      example = lib.literalExpression ''
        with pkgs; [ alacritty wmenu kanshi ]
      '';

      description = ''
        Extra packages to be installed system wide.  See [useful
        software suggested by
        river](https://codeberg.org/river/wiki/src/branch/main/pages/useful-software.md)
        for a list of useful software.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    programs.river = {
      enable = true;
      inherit (cfg) extraPackages withUWSM;
    };
  };

  meta.maintainers = with lib.maintainers; [ yiyu ];
}

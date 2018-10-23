{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.sway-beta;
  swayPackage = cfg.package;
in {
  options.programs.sway-beta = {
    enable = mkEnableOption ''
      Sway, the i3-compatible tiling Wayland compositor. This module will be removed after the final release of Sway 1.0
    '';

    package = mkOption {
      type = types.package;
      default = pkgs.sway-beta;
      defaultText = "pkgs.sway-beta";
      description = ''
        The package to be used for `sway`.
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
        xwayland dmenu
      ];
      defaultText = literalExample ''
        with pkgs; [ xwayland dmenu ];
      '';
      example = literalExample ''
        with pkgs; [
          xwayland
          i3status i3status-rust
          termite rofi light
        ]
      '';
      description = ''
        Extra packages to be installed system wide.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ swayPackage ] ++ cfg.extraPackages;
    security.pam.services.swaylock = {};
    hardware.opengl.enable = mkDefault true;
    fonts.enableDefaultFonts = mkDefault true;
    programs.dconf.enable = mkDefault true;
  };

  meta.maintainers = with lib.maintainers; [ gnidorah primeos colemickens ];
}


{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.sway-beta;
  swayPackage = cfg.package;

  swayWrapped = pkgs.writeShellScriptBin "sway" ''
    ${cfg.extraSessionCommands}
    exec ${pkgs.dbus.dbus-launch} --exit-with-session ${swayPackage}/bin/sway
  '';
  swayJoined = pkgs.symlinkJoin {
    name = "sway-joined";
    paths = [ swayWrapped swayPackage ];
  };
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

    extraSessionCommands = mkOption {
      type = types.lines;
      default = "";
      example = ''
        export SDL_VIDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
      description = ''
        Shell commands executed just before Sway is started.
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
        xwayland rxvt_unicode dmenu
      ];
      defaultText = literalExample ''
        with pkgs; [ xwayland rxvt_unicode dmenu ];
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
    environment.systemPackages = [ swayJoined ] ++ cfg.extraPackages;
    security.pam.services.swaylock = {};
    hardware.opengl.enable = mkDefault true;
    fonts.enableDefaultFonts = mkDefault true;
    programs.dconf.enable = mkDefault true;
  };

  meta.maintainers = with lib.maintainers; [ gnidorah primeos colemickens ];
}

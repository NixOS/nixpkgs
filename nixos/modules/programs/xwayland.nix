{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.xwayland;

in

{
  options.programs.xwayland = {

    enable = mkEnableOption ''
      Xwayland X server allows running X programs on a Wayland compositor.
    '';

    defaultFontPath = mkOption {
      type = types.str;
      default = optionalString config.fonts.fontDir.enable
        "/run/current-system/sw/share/X11/fonts";
      description = ''
        Default font path. Setting this option causes Xwayland to be rebuilt.
      '';
    };

    package = mkOption {
      type = types.path;
      description = "The Xwayland package";
    };

  };

  config = mkIf cfg.enable {

    # Needed by some applications for fonts and default settings
    environment.pathsToLink = [ "/share/X11" ];

    environment.systemPackages = [ cfg.package ];

    programs.xwayland.package = pkgs.xwayland.override (oldArgs: {
      inherit (cfg) defaultFontPath;
    });

  };
}

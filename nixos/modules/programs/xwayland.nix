{ config, lib, pkgs, ... }:

let
  cfg = config.programs.xwayland;

in

{
  options.programs.xwayland = {

    enable = lib.mkEnableOption "Xwayland (an X server for interfacing X11 apps with the Wayland protocol)";

    defaultFontPath = lib.mkOption {
      type = lib.types.str;
      default = lib.optionalString config.fonts.fontDir.enable
        "/run/current-system/sw/share/X11/fonts";
      defaultText = lib.literalExpression ''
        optionalString config.fonts.fontDir.enable "/run/current-system/sw/share/X11/fonts"
      '';
      description = ''
        Default font path. Setting this option causes Xwayland to be rebuilt.
      '';
    };

    package = lib.mkOption {
      type = lib.types.path;
      default = pkgs.xwayland.override (oldArgs: {
        inherit (cfg) defaultFontPath;
      });
      defaultText = lib.literalExpression ''
        pkgs.xwayland.override (oldArgs: {
          inherit (config.programs.xwayland) defaultFontPath;
        })
      '';
      description = "The Xwayland package to use.";
    };

  };

  config = lib.mkIf cfg.enable {

    # Needed by some applications for fonts and default settings
    environment.pathsToLink = [ "/share/X11" ];

    environment.systemPackages = [ cfg.package ];

  };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.xwayland;

in

{
  options.programs.xwayland = {

    enable = mkEnableOption (lib.mdDoc "Xwayland (an X server for interfacing X11 apps with the Wayland protocol)");

    defaultFontPath = mkOption {
      type = types.str;
      default = optionalString config.fonts.fontDir.enable
        "/run/current-system/sw/share/X11/fonts";
      defaultText = literalExpression ''
        optionalString config.fonts.fontDir.enable "/run/current-system/sw/share/X11/fonts"
      '';
      description = lib.mdDoc ''
        Default font path. Setting this option causes Xwayland to be rebuilt.
      '';
    };

    package = mkOption {
      type = types.path;
      default = pkgs.xwayland.override (oldArgs: {
        inherit (cfg) defaultFontPath;
      });
      defaultText = literalExpression ''
        pkgs.xwayland.override (oldArgs: {
          inherit (config.programs.xwayland) defaultFontPath;
        })
      '';
      description = lib.mdDoc "The Xwayland package to use.";
    };

  };

  config = mkIf cfg.enable {

    # Needed by some applications for fonts and default settings
    environment.pathsToLink = [ "/share/X11" ];

    environment.systemPackages = [ cfg.package ];

  };
}

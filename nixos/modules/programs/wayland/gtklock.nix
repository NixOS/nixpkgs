{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.gtklock;
  configFormat = pkgs.formats.ini {
    listToValue = builtins.concatStringsSep ";";
  };

  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkPackageOption
    ;
in
{
  options.programs.gtklock = {
    enable = mkEnableOption "gtklock, a GTK-based lockscreen for Wayland";

    package = mkPackageOption pkgs "gtklock" { };

    config = mkOption {
      type = configFormat.type;
      example = lib.literalExpression ''
        {
          main = {
            idle-hide = true;
            idle-timeout = 10;
          };
        }'';
      description = ''
        Configuration for gtklock.
        See [`gtklock(1)`](https://github.com/jovanlanik/gtklock/blob/master/man/gtklock.1.scd) man page for details.
      '';
    };

    style = mkOption {
      type = with types; nullOr lines;
      default = null;
      description = ''
        CSS Stylesheet for gtklock.
        See [gtklock's wiki](https://github.com/jovanlanik/gtklock/wiki#Styling) for details.
      '';
    };

    modules = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = lib.literalExpression ''
        with pkgs; [
          gtklock-playerctl-module
          gtklock-powerbar-module
          gtklock-userinfo-module
        ]'';
      description = "gtklock modules to load.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gtklock.config.main = lib.mkMerge [
      (lib.mkIf (cfg.style != null) {
        style = "${pkgs.writeText "style.css" cfg.style}";
      })

      (lib.mkIf (cfg.modules != [ ]) {
        modules = map (pkg: "${pkg}/lib/gtklock/${lib.removePrefix "gtklock-" pkg.pname}.so") cfg.modules;
      })
    ];

    environment.etc."xdg/gtklock/config.ini" = lib.mkIf (cfg.config != { }) {
      source = configFormat.generate "config.ini" cfg.config;
    };

    environment.systemPackages = [ cfg.package ];

    security.pam.services.gtklock = { };
  };
}

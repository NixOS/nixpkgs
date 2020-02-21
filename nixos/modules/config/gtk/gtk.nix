{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gtk;
  gtk2 = cfg.enable && cfg.gtk2;

  toGtk2File = key: value:
    let
      value' =
        if isBool value then (if value then "true" else "false")
        else if isString value then "\"${value}\""
        else toString value;
    in
      "${key} = ${value'}";
  toGtk3File = generators.toINI {
    mkKeyValue = key: value:
      let
        value' =
          if isBool value then (if value then "true" else "false")
          else toString value;
      in
        "${key}=${value'}";
  };

  settings =
    optionalAttrs (cfg.font != null)
      { gtk-font-name = cfg.font.name; }
    //
    optionalAttrs (cfg.theme != null)
      { gtk-theme-name = cfg.theme.name; }
    //
    optionalAttrs (cfg.iconTheme != null)
      { gtk-icon-theme-name = cfg.iconTheme.name; }
    //
    optionalAttrs (cfg.cursorTheme != null)
      { gtk-cursor-theme-name = cfg.cursorTheme.name; };

  fontType = types.submodule {
    options = {
      package = mkOption {
        internal = true;
        type = types.nullOr types.package;
        default = null;
      };
      name = mkOption {
        internal = true;
        type = types.str;
      };
    };
  };
  themeType = types.submodule {
    options = {
      package = mkOption {
        internal = true;
        type = types.nullOr types.package;
        default = null;
      };
      name = mkOption {
        internal = true;
        type = types.str;
      };
    };
  };

  optionalPackage = opt:
    optional (opt != null && opt.package != null) opt.package;
in
{
  options = {
    gtk = {
      enable = mkEnableOption "Gtk theming configuration";

      gtk2 = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable theming for obsolete GTK2 engine.
        '';
      };

      font = mkOption {
        type = types.nullOr fontType;
        default = null;
        example = literalExample ''
          {
            name = "Cantarell 11";
            package = pkgs.cantarell-fonts;
          };
        '';
        description = ''
          The font to use in GTK+ applications.
        '';
      };

      iconTheme = mkOption {
        type = types.nullOr themeType;
        default = null;
        example = literalExample ''
          {
            name = "Adwaita";
            package = pkgs.gnome3.adwaita-icon-theme;
          };
        '';
        description = "The icon theme to use.";
      };

      cursorTheme = mkOption {
        type = types.nullOr themeType;
        default = null;
        example = literalExample ''
          {
            name = "Adwaita";
            package = pkgs.gnome3.adwaita-icon-theme;
          };
        '';
        description = "The cursor theme to use.";
      };

      theme = mkOption {
        type = types.nullOr themeType;
        default = null;
        example = literalExample ''
          {
            name = "Adwaita";
            package = pkgs.gnome-themes-extra;
          };
        '';
        description = "The GTK+ theme to use.";
      };
    };
  };

  config = mkMerge [

    (mkIf gtk2 {
      environment.etc."xdg/gtk-2.0/gtkrc".text =
        concatStringsSep "\n" (
          mapAttrsToList toGtk2File settings
        );
    })

    (mkIf cfg.enable {
      environment.systemPackages =
        optionalPackage cfg.font
        ++ optionalPackage cfg.theme
        ++ optionalPackage cfg.iconTheme
        ++ optionalPackage cfg.cursorTheme;

      environment.etc."xdg/gtk-3.0/settings.ini".text =
        toGtk3File { Settings = settings; };

      # TODO: support Wayland/XSettings
      # once https://github.com/NixOS/nixpkgs/issues/54150 is fixed
    })
  ];

  meta.maintainers = [ maintainers.gnidorah ];
}

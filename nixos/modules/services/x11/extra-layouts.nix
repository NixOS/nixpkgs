{ config, lib, pkgs, ... }:

with lib;

let
  layouts = config.services.xserver.extraLayouts;

  layoutOpts = {
    options = {
      description = mkOption {
        type = types.str;
        description = lib.mdDoc "A short description of the layout.";
      };

      languages = mkOption {
        type = types.listOf types.str;
        description =
        lib.mdDoc ''
          A list of languages provided by the layout.
          (Use ISO 639-2 codes, for example: "eng" for english)
        '';
      };

      compatFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          The path to the xkb compat file.
          This file sets the compatibility state, used to preserve
          compatibility with xkb-unaware programs.
          It must contain a `xkb_compat "name" { ... }` block.
        '';
      };

      geometryFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          The path to the xkb geometry file.
          This (completely optional) file describes the physical layout of
          keyboard, which maybe be used by programs to depict it.
          It must contain a `xkb_geometry "name" { ... }` block.
        '';
      };

      keycodesFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          The path to the xkb keycodes file.
          This file specifies the range and the interpretation of the raw
          keycodes sent by the keyboard.
          It must contain a `xkb_keycodes "name" { ... }` block.
        '';
      };

      symbolsFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          The path to the xkb symbols file.
          This is the most important file: it defines which symbol or action
          maps to each key and must contain a
          `xkb_symbols "name" { ... }` block.
        '';
      };

      typesFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          The path to the xkb types file.
          This file specifies the key types that can be associated with
          the various keyboard keys.
          It must contain a `xkb_types "name" { ... }` block.
        '';
      };

    };
  };

  xkb_patched = pkgs.xorg.xkeyboardconfig_custom {
    layouts = config.services.xserver.extraLayouts;
  };

in

{

  ###### interface

  options.services.xserver = {
    extraLayouts = mkOption {
      type = types.attrsOf (types.submodule layoutOpts);
      default = {};
      example = literalExpression
      ''
        {
          mine = {
            description = "My custom xkb layout.";
            languages = [ "eng" ];
            symbolsFile = /path/to/my/layout;
          };
        }
      '';
      description = lib.mdDoc ''
        Extra custom layouts that will be included in the xkb configuration.
        Information on how to create a new layout can be found here:
        <https://www.x.org/releases/current/doc/xorg-docs/input/XKB-Enhancing.html#Defining_New_Layouts>.
        For more examples see
        <https://wiki.archlinux.org/index.php/X_KeyBoard_extension#Basic_examples>
      '';
    };

  };

  ###### implementation

  config = mkIf (layouts != { }) {

    environment.sessionVariables = {
      # runtime override supported by multiple libraries e. g. libxkbcommon
      # https://xkbcommon.org/doc/current/group__include-path.html
      XKB_CONFIG_ROOT = config.services.xserver.xkbDir;
    };

    services.xserver = {
      xkbDir = "${xkb_patched}/etc/X11/xkb";
      exportConfiguration = config.services.xserver.displayManager.startx.enable
        || config.services.xserver.displayManager.sx.enable;
    };

  };

}

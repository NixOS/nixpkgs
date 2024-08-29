{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.environment.xkb;

  layoutOpts = {
    options = {
      description = lib.mkOption {
        type = lib.types.str;
        description = "A short description of the layout.";
      };

      languages = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          A list of languages provided by the layout.
          (Use ISO 639-2 codes, for example: "eng" for english)
        '';
      };

      compatFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          The path to the xkb compat file.
          This file sets the compatibility state, used to preserve
          compatibility with xkb-unaware programs.
          It must contain a `xkb_compat "name" { ... }` block.
        '';
      };

      geometryFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          The path to the xkb geometry file.
          This (completely optional) file describes the physical layout of
          keyboard, which maybe be used by programs to depict it.
          It must contain a `xkb_geometry "name" { ... }` block.
        '';
      };

      keycodesFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          The path to the xkb keycodes file.
          This file specifies the range and the interpretation of the raw
          keycodes sent by the keyboard.
          It must contain a `xkb_keycodes "name" { ... }` block.
        '';
      };

      symbolsFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          The path to the xkb symbols file.
          This is the most important file: it defines which symbol or action
          maps to each key and must contain a
          `xkb_symbols "name" { ... }` block.
        '';
      };

      typesFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          The path to the xkb types file.
          This file specifies the key types that can be associated with
          the various keyboard keys.
          It must contain a `xkb_types "name" { ... }` block.
        '';
      };

    };
  };

  xkb_patched = pkgs.xorg.xkeyboardconfig_custom { layouts = cfg.extraLayouts; };
in
{
  options.environment.xkb = {
    enable = lib.mkEnableOption "XKB - X Keyboard Extension";

    dir = lib.mkOption {
      type = lib.types.path;
      default = "${pkgs.xkeyboard_config}/etc/X11/xkb";
      defaultText = lib.literalExpression ''"''${pkgs.xkeyboard_config}/etc/X11/xkb"'';
      description = ''
        Path to the xkb configs which are symlinked to /etc/X11/xkb and will be used for the `-xkbdir` xserver parameter.
      '';
    };

    layout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = ''
        X keyboard layout, or multiple keyboard layouts separated by commas.
      '';
    };

    extraLayouts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule layoutOpts);
      default = { };
      example = lib.literalExpression ''
        {
           mine = {
            description = "My custom xkb layout.";
            languages = [ "eng" ];
            symbolsFile = /path/to/my/layout;
          };
        }
      '';
      description = ''
        Extra custom layouts that will be included in the xkb configuration.
        Information on how to create a new layout can be found here:
        <https://www.x.org/releases/current/doc/xorg-docs/input/XKB-Enhancing.html#Defining_New_Layouts>.
        For more examples see
        <https://wiki.archlinux.org/index.php/X_KeyBoard_extension#Basic_examples>
      '';
    };

    model = lib.mkOption {
      type = lib.types.str;
      default = "pc104";
      example = "presario";
      description = ''
        X keyboard model.
      '';
    };

    options = lib.mkOption {
      type = lib.types.commas;
      default = "terminate:ctrl_alt_bksp";
      example = "grp:caps_toggle,grp_led:scroll";
      description = ''
        X keyboard options; layout switching goes here.
      '';
    };

    variant = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "colemak";
      description = ''
        X keyboard variant.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      etc."X11/xkb".source = cfg.dir;
      # runtime override supported by multiple libraries e. g. libxkbcommon
      # https://xkbcommon.org/doc/current/group__include-path.html
      sessionVariables.XKB_CONFIG_ROOT = cfg.dir;

      xkb.dir = lib.mkIf (cfg.extraLayouts != { }) "${xkb_patched}/etc/X11/xkb";
    };

    system.checks = lib.singleton (
      pkgs.runCommand "xkb-validated"
        {
          inherit (cfg)
            dir
            model
            layout
            variant
            options
            ;
          nativeBuildInputs = with pkgs.buildPackages; [ xkbvalidate ];
          preferLocalBuild = true;
        }
        ''
          ${lib.optionalString (
            config.environment.sessionVariables ? XKB_CONFIG_ROOT
          ) "export XKB_CONFIG_ROOT=${config.environment.sessionVariables.XKB_CONFIG_ROOT}"}
          XKB_CONFIG_ROOT="$dir" xkbvalidate "$model" "$layout" "$variant" "$options"
          touch "$out"
        ''
    );
  };
}

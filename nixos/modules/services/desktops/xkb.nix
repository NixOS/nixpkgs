{ config, lib, pkgs, ... }:

let
  cfg = config.services.xkb;
in
{
  options.services.xkb = {
    enable = lib.mkEnableOptions "XKB - X Keyboard Extension";

    layout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = ''
        X keyboard layout, or multiple keyboard layouts separated by commas.
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

    dir = lib.mkOption {
      type = lib.types.path;
      default = "${pkgs.xkeyboard_config}/etc/X11/xkb";
      defaultText = lib.literalExpression ''"''${pkgs.xkeyboard_config}/etc/X11/xkb"'';
      description = ''
        Path used for -xkbdir xserver parameter.
      '';
    };
  };

  config = {
    system.checks = lib.singleton (pkgs.runCommand "xkb-validated" {
      inherit (cfg) dir model layout variant options;
      nativeBuildInputs = with pkgs.buildPackages; [ xkbvalidate ];
      preferLocalBuild = true;
    } ''
      ${lib.optionalString (config.environment.sessionVariables ? XKB_CONFIG_ROOT)
        "export XKB_CONFIG_ROOT=${config.environment.sessionVariables.XKB_CONFIG_ROOT}"
      }
      XKB_CONFIG_ROOT="$dir" xkbvalidate "$model" "$layout" "$variant" "$options"
      touch "$out"
    '');
  };
}

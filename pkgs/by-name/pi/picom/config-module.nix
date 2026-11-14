# Configuration of picom, as a module that maps the options to the file that
# picom reads. `pkgs.picom.configFiles` exposes it, so that a system that does
# not use NixOS can also evaluate it. This module needs no packages, thus it is
# a plain module.
{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib) mkOption types;

  pairOf =
    x:
    types.addCheck (types.listOf x) (y: lib.length y == 2)
    // {
      description = "pair of ${x.description}";
    };

  # Basically a tinkered lib.generators.mkKeyValueDefault
  # It either serializes a top-level definition "key: { values };"
  # or an expression "key = { values };"
  mkAttrsString =
    top:
    lib.mapAttrsToList (
      k: v:
      let
        sep = if (top && lib.isAttrs v) then ": " else " = ";
      in
      "${lib.escape [ sep ] k}${sep}${mkValueString v};"
    );

  # This serializes a Nix expression to the libconfig format.
  mkValueString =
    v:
    if types.bool.check v then
      lib.boolToString v
    else if types.int.check v then
      toString v
    else if types.float.check v then
      toString v
    else if types.str.check v then
      ''"${lib.escape [ ''"'' ] v}"''
    else if builtins.isList v then
      "[ ${lib.concatMapStringsSep " , " mkValueString v} ]"
    else if types.attrs.check v then
      "{ ${lib.concatStringsSep " " (mkAttrsString false v)} }"
    else
      throw ''
        invalid expression used in option ${options.settings}:
        ${v}
      '';

  toConf = attrs: lib.concatStringsSep "\n" (mkAttrsString true attrs);

  scalar =
    types.oneOf [
      types.bool
      types.int
      types.float
      types.str
    ]
    // {
      description = "scalar types";
    };

  libConfig =
    types.oneOf [
      scalar
      (types.listOf libConfig)
      (types.attrsOf libConfig)
    ]
    // {
      description = "libconfig type";
    };

  topLevel = types.attrsOf libConfig // {
    description = ''
      libconfig configuration. The format consists of an attributes
      set (called a group) of settings. Each setting can be a scalar type
      (boolean, integer, floating point number or string), a list of
      scalars or a group itself
    '';
  };
in
{
  options = {
    fade = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Fade windows in and out.
      '';
    };

    fadeDelta = mkOption {
      type = types.ints.positive;
      default = 10;
      example = 5;
      description = ''
        Time between fade animation step (in ms).
      '';
    };

    fadeSteps = mkOption {
      type = pairOf (types.numbers.between 0.01 1);
      default = [
        0.028
        0.03
      ];
      example = [
        0.04
        0.04
      ];
      description = ''
        Opacity change between fade steps (in and out).
      '';
    };

    fadeExclude = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "window_type *= 'menu'"
        "name ~= 'Firefox$'"
        "focused = 1"
      ];
      description = ''
        List of conditions of windows that should not be faded.
        See {manpage}`picom(1)` man page for more examples.
      '';
    };

    shadow = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Draw window shadows.
      '';
    };

    shadowOffsets = mkOption {
      type = pairOf types.int;
      default = [
        (-15)
        (-15)
      ];
      example = [
        (-10)
        (-15)
      ];
      description = ''
        Left and right offset for shadows (in pixels).
      '';
    };

    shadowOpacity = mkOption {
      type = types.numbers.between 0 1;
      default = 0.75;
      example = 0.8;
      description = ''
        Window shadows opacity.
      '';
    };

    shadowExclude = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "window_type *= 'menu'"
        "name ~= 'Firefox$'"
        "focused = 1"
      ];
      description = ''
        List of conditions of windows that should have no shadow.
        See {manpage}`picom(1)` man page for more examples.
      '';
    };

    activeOpacity = mkOption {
      type = types.numbers.between 0 1;
      default = 1.0;
      example = 0.8;
      description = ''
        Opacity of active windows.
      '';
    };

    inactiveOpacity = mkOption {
      type = types.numbers.between 0.1 1;
      default = 1.0;
      example = 0.8;
      description = ''
        Opacity of inactive windows.
      '';
    };

    menuOpacity = mkOption {
      type = types.numbers.between 0 1;
      default = 1.0;
      example = 0.8;
      description = ''
        Opacity of dropdown and popup menu.
      '';
    };

    wintypes = mkOption {
      type = types.attrs;
      default = {
        popup_menu = {
          opacity = config.menuOpacity;
        };
        dropdown_menu = {
          opacity = config.menuOpacity;
        };
      };
      defaultText = lib.literalExpression ''
        {
          popup_menu = { opacity = config.${options.menuOpacity}; };
          dropdown_menu = { opacity = config.${options.menuOpacity}; };
        }
      '';
      example = { };
      description = ''
        Rules for specific window types.
      '';
    };

    opacityRules = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "95:class_g = 'URxvt' && !_NET_WM_STATE@:32a"
        "0:_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
      ];
      description = ''
        Rules that control the opacity of windows, in format PERCENT:PATTERN.
      '';
    };

    backend = mkOption {
      type = types.enum [
        "egl"
        "glx"
        "xrender"
        "xr_glx_hybrid"
      ];
      default = "xrender";
      description = ''
        Backend to use: `egl`, `glx`, `xrender` or `xr_glx_hybrid`.
      '';
    };

    vSync = mkOption {
      type = types.either types.bool (
        types.enum [
          "none"
          "drm"
          "opengl"
          "opengl-oml"
          "opengl-swc"
          "opengl-mswc"
        ]
      );
      default = false;
      apply =
        x:
        let
          res = x != "none";
          msg =
            "The type of ${options.vSync} has changed to bool:"
            + " interpreting ${x} as ${lib.boolToString res}";
        in
        if lib.isBool x then x else lib.warn msg res;

      description = ''
        Enable vertical synchronization. Chooses the best method
        (drm, opengl, opengl-oml, opengl-swc, opengl-mswc) automatically.
        The bool value should be used, the others are just for backwards compatibility.
      '';
    };

    settings = mkOption {
      type = topLevel;
      default = { };
      example = lib.literalExpression ''
        blur =
          { method = "gaussian";
            size = 10;
            deviation = 5.0;
          };
      '';
      description = ''
        Picom settings. Use this option to configure Picom settings that no
        other option exposes, or to bypass an option. For the available options
        see the CONFIGURATION FILES section at {manpage}`picom(1)`.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      example = ''
        animations = (
          {
            triggers = [ "open", "show" ];
            preset = "slide-in";
            direction = "up";
            duration = 0.2;
          }
        )
      '';
      description = ''
        Extra configuration lines to append to the picom configuration file.
        Use this for values that `settings` cannot express, such as libconfig
        lists of groups.
      '';
    };
  };

  config = {
    settings = lib.mapAttrs (_: lib.mkDefault) {
      # fading
      fading = config.fade;
      fade-delta = config.fadeDelta;
      fade-in-step = lib.elemAt config.fadeSteps 0;
      fade-out-step = lib.elemAt config.fadeSteps 1;
      fade-exclude = config.fadeExclude;

      # shadows
      inherit (config) shadow;
      shadow-offset-x = lib.elemAt config.shadowOffsets 0;
      shadow-offset-y = lib.elemAt config.shadowOffsets 1;
      shadow-opacity = config.shadowOpacity;
      shadow-exclude = config.shadowExclude;

      # opacity
      active-opacity = config.activeOpacity;
      inactive-opacity = config.inactiveOpacity;
      opacity-rule = config.opacityRules;

      # other options
      inherit (config) backend wintypes;
      vsync = config.vSync;
    };

    portable.files."picom.conf".text = lib.concatStringsSep "\n" [
      (toConf config.settings)
      config.extraConfig
    ];
  };
}

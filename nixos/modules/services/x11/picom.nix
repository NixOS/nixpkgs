{ config, lib, pkgs, ... }:

with lib;
with builtins;

let

  cfg = config.services.picom;

  pairOf = x: with types; addCheck (listOf x) (y: length y == 2);

  floatBetween = a: b: with lib; with types;
    addCheck str (x: versionAtLeast x a && versionOlder x b);

  toConf = attrs: concatStringsSep "\n"
    (mapAttrsToList
      (k: v: let
        sep = if isAttrs v then ":" else "=";
        # Basically a tinkered lib.generators.mkKeyValueDefault
        mkValueString = v:
          if isBool v        then boolToString v
          else if isInt v    then toString v
          else if isFloat v  then toString v
          else if isString v then ''"${escape [ ''"'' ] v}"''
          else if isList v   then "[ "
            + concatMapStringsSep " , " mkValueString v
            + " ]"
          else if isAttrs v  then "{ "
            + concatStringsSep " "
              (mapAttrsToList
                (key: value: "${toString key}=${mkValueString value};")
                v)
            + " }"
          else abort "picom.mkValueString: unexpected type (v = ${v})";
      in "${escape [ sep ] k}${sep}${mkValueString v};")
      attrs);

  configFile = pkgs.writeText "picom.conf" (toConf cfg.settings);

in {

  imports = [
    (mkAliasOptionModule [ "services" "compton" ] [ "services" "picom" ])
  ];

  options.services.picom = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether of not to enable Picom as the X.org composite manager.
      '';
    };

    fade = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Fade windows in and out.
      '';
    };

    fadeDelta = mkOption {
      type = types.addCheck types.int (x: x > 0);
      default = 10;
      example = 5;
      description = ''
        Time between fade animation step (in ms).
      '';
    };

    fadeSteps = mkOption {
      type = pairOf (floatBetween "0.01" "1.01");
      default = [ "0.028" "0.03" ];
      example = [ "0.04" "0.04" ];
      description = ''
        Opacity change between fade steps (in and out).
        (numbers in range 0.01 - 1.0)
      '';
    };

    fadeExclude = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [
        "window_type *= 'menu'"
        "name ~= 'Firefox$'"
        "focused = 1"
      ];
      description = ''
        List of conditions of windows that should not be faded.
        See <literal>picom(1)</literal> man page for more examples.
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
      default = [ (-15) (-15) ];
      example = [ (-10) (-15) ];
      description = ''
        Left and right offset for shadows (in pixels).
      '';
    };

    shadowOpacity = mkOption {
      type = floatBetween "0.0" "1.01";
      default = "0.75";
      example = "0.8";
      description = ''
        Window shadows opacity (number in range 0.0 - 1.0).
      '';
    };

    shadowExclude = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [
        "window_type *= 'menu'"
        "name ~= 'Firefox$'"
        "focused = 1"
      ];
      description = ''
        List of conditions of windows that should have no shadow.
        See <literal>picom(1)</literal> man page for more examples.
      '';
    };

    activeOpacity = mkOption {
      type = floatBetween "0.0" "1.01";
      default = "1.0";
      example = "0.8";
      description = ''
        Opacity of active windows (number in range 0.0 - 1.0).
      '';
    };

    inactiveOpacity = mkOption {
      type = floatBetween "0.1" "1.01";
      default = "1.0";
      example = "0.8";
      description = ''
        Opacity of inactive windows (number in range 0.1 - 1.0).
      '';
    };

    menuOpacity = mkOption {
      type = floatBetween "0.0" "1.01";
      default = "1.0";
      example = "0.8";
      description = ''
        Opacity of dropdown and popup menu (number in range 0.0 - 1.0).
      '';
    };

    wintypes = mkOption {
      type = types.attrs;
      default = { popup_menu = { opacity = cfg.menuOpacity; }; dropdown_menu = { opacity = cfg.menuOpacity; }; };
      example = {};
      description = ''
        Rules for specific window types.
      '';
    };

    opacityRules = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [
        "95:class_g = 'URxvt' && !_NET_WM_STATE@:32a"
        "0:_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
      ];
      description = ''
        Rules that control the opacity of windows, in format PERCENT:PATTERN.
      '';
    };

    backend = mkOption {
      type = types.enum [ "glx" "xrender" "xr_glx_hybrid" ];
      default = "xrender";
      description = ''
        Backend to use: <literal>glx</literal>, <literal>xrender</literal> or <literal>xr_glx_hybrid</literal>.
      '';
    };

    vSync = mkOption {
      type = with types; either bool
        (enum [ "none" "drm" "opengl" "opengl-oml" "opengl-swc" "opengl-mswc" ]);
      default = false;
      apply = x:
        let
          res = x != "none";
          msg = "The type of services.picom.vSync has changed to bool:"
                + " interpreting ${x} as ${boolToString res}";
        in
          if isBool x then x
          else warn msg res;

      description = ''
        Enable vertical synchronization. Chooses the best method
        (drm, opengl, opengl-oml, opengl-swc, opengl-mswc) automatically.
        The bool value should be used, the others are just for backwards compatibility.
      '';
    };

    refreshRate = mkOption {
      type = types.addCheck types.int (x: x >= 0);
      default = 0;
      example = 60;
      description = ''
       Screen refresh rate (0 = automatically detect).
      '';
    };

    settings = let
      configTypes = with types; oneOf [ bool int float str ];
      # types.loaOf converts lists to sets
      loaOf = t: with types; either (listOf t) (attrsOf t);
    in mkOption {
      type = loaOf (types.either configTypes (loaOf (types.either configTypes (loaOf configTypes))));
      default = {};
      description = ''
        Additional Picom configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.picom.settings = let
      # Hard conversion to float, literally lib.toInt but toFloat
      toFloat = str: let
        may_be_float = builtins.fromJSON str;
      in if builtins.isFloat may_be_float
        then may_be_float
        else throw "Could not convert ${str} to float.";
    in {
      # fading
      fading           = mkDefault cfg.fade;
      fade-delta       = mkDefault cfg.fadeDelta;
      fade-in-step     = mkDefault (toFloat (elemAt cfg.fadeSteps 0));
      fade-out-step    = mkDefault (toFloat (elemAt cfg.fadeSteps 1));
      fade-exclude     = mkDefault cfg.fadeExclude;

      # shadows
      shadow           = mkDefault cfg.shadow;
      shadow-offset-x  = mkDefault (elemAt cfg.shadowOffsets 0);
      shadow-offset-y  = mkDefault (elemAt cfg.shadowOffsets 1);
      shadow-opacity   = mkDefault (toFloat cfg.shadowOpacity);
      shadow-exclude   = mkDefault cfg.shadowExclude;

      # opacity
      active-opacity   = mkDefault (toFloat cfg.activeOpacity);
      inactive-opacity = mkDefault (toFloat cfg.inactiveOpacity);

      wintypes         = mkDefault cfg.wintypes;

      opacity-rule     = mkDefault cfg.opacityRules;

      # other options
      backend          = mkDefault cfg.backend;
      vsync            = mkDefault cfg.vSync;
      refresh-rate     = mkDefault cfg.refreshRate;
    };

    systemd.user.services.picom = {
      description = "Picom composite manager";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      # Temporarily fixes corrupt colours with Mesa 18
      environment = mkIf (cfg.backend == "glx") {
        allow_rgb10_configs = "false";
      };

      serviceConfig = {
        ExecStart = "${pkgs.picom}/bin/picom --config ${configFile}";
        RestartSec = 3;
        Restart = "always";
      };
    };

    environment.systemPackages = [ pkgs.picom ];
  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}

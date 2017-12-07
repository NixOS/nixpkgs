{ config, lib, pkgs, ... }:

with lib;
with builtins;

let

  cfg = config.services.compton;

  floatBetween = a: b: with lib; with types;
    addCheck str (x: versionAtLeast x a && versionOlder x b);

  pairOf = x: with types; addCheck (listOf x) (y: lib.length y == 2);

  opacityRules = optionalString (length cfg.opacityRules != 0)
    (concatMapStringsSep ",\n" (rule: ''"${rule}"'') cfg.opacityRules);

  configFile = pkgs.writeText "compton.conf"
    (optionalString cfg.fade ''
      # fading
      fading = true;
      fade-delta    = ${toString cfg.fadeDelta};
      fade-in-step  = ${elemAt cfg.fadeSteps 0};
      fade-out-step = ${elemAt cfg.fadeSteps 1};
      fade-exclude  = ${toJSON cfg.fadeExclude};
    '' + 
    optionalString cfg.shadow ''

      # shadows
      shadow = true;
      shadow-offset-x = ${toString (elemAt cfg.shadowOffsets 0)};
      shadow-offset-y = ${toString (elemAt cfg.shadowOffsets 1)};
      shadow-opacity  = ${cfg.shadowOpacity};
      shadow-exclude  = ${toJSON cfg.shadowExclude};
    '' + ''

      # opacity
      active-opacity   = ${cfg.activeOpacity};
      inactive-opacity = ${cfg.inactiveOpacity};
      menu-opacity     = ${cfg.menuOpacity};

      opacity-rule = [
        ${opacityRules}
      ];

      # other options
      backend = ${toJSON cfg.backend};
      vsync = ${toJSON cfg.vSync};
      refresh-rate = ${toString cfg.refreshRate};
    '' + cfg.extraOptions);

in {

  options.services.compton = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether of not to enable Compton as the X.org composite manager.
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
        See <literal>compton(1)</literal> man page for more examples.
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
        See <literal>compton(1)</literal> man page for more examples.
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
      type = types.enum [ "glx" "xrender" ];
      default = "xrender";
      description = ''
        Backend to use: <literal>glx</literal> or <literal>xrender</literal>.
      '';
    };

    vSync = mkOption {
      type = types.enum [
        "none" "drm" "opengl"
        "opengl-oml" "opengl-swc" "opengl-mswc"
      ];
      default = "none";
      example = "opengl-swc";
      description = ''
        Enable vertical synchronization using the specified method.
        See <literal>compton(1)</literal> man page an explanation.
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

    package = mkOption {
      type = types.package;
      default = pkgs.compton;
      defaultText = "pkgs.compton";
      example = literalExample "pkgs.compton";
      description = ''
        Compton derivation to use.
      '';
    };

    extraOptions = mkOption {
      type = types.lines;
      default = "";
      example = ''
        unredir-if-possible = true;
        dbe = true;
      '';
      description = ''
        Additional Compton configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.compton = {
      description = "Compton composite manager";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/compton --config ${configFile}";
        RestartSec = 3;
        Restart = "always";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };

}

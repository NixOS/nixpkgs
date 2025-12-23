{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.picom;

  # Restore the specific "pairOf" type to satisfy "more specific types" requirement
  pairOf =
    x:
    with types;
    addCheck (listOf x) (y: length y == 2)
    // {
      description = "pair of ${x.description}";
    };

  # Standard libconfig format
  libconfig = pkgs.formats.libconfig { };

in
{
  imports = [
    (mkAliasOptionModule [ "services" "compton" ] [ "services" "picom" ])
    (mkRemovedOptionModule [ "services" "picom" "refreshRate" ] ''
      This option corresponds to `refresh-rate`, which has been unused
      since picom v6 and was subsequently removed by upstream.
      See https://github.com/yshui/picom/commit/bcbc410
    '')
    (mkRemovedOptionModule [ "services" "picom" "experimentalBackends" ] ''
      This option was removed by upstream since picom v10.
    '')
  ];

  options.services.picom = {
    enable = mkEnableOption "Picom as the X.org composite manager";

    package = mkPackageOption pkgs "picom" { };

    fade = mkOption {
      type = types.bool;
      default = false;
      description = "Fade windows in and out.";
    };

    fadeDelta = mkOption {
      type = types.ints.positive;
      default = 10;
      description = "Time between fade animation step (in ms).";
    };

    fadeSteps = mkOption {
      type = pairOf (types.numbers.between 0.01 1);
      default = [
        0.028
        0.03
      ];
      description = "Opacity change between fade steps (in and out).";
    };

    fadeExclude = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of conditions of windows that should not be faded.";
    };

    shadow = mkOption {
      type = types.bool;
      default = false;
      description = "Draw window shadows.";
    };

    shadowOffsets = mkOption {
      type = pairOf types.int;
      default = [
        (-15)
        (-15)
      ];
      description = "Left and right offset for shadows (in pixels).";
    };

    shadowOpacity = mkOption {
      type = types.numbers.between 0 1;
      default = 0.75;
      description = "Window shadows opacity.";
    };

    shadowExclude = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of conditions of windows that should have no shadow.";
    };

    activeOpacity = mkOption {
      type = types.numbers.between 0 1;
      default = 1.0;
      description = "Opacity of active windows.";
    };

    inactiveOpacity = mkOption {
      type = types.numbers.between 0.1 1;
      default = 1.0;
      description = "Opacity of inactive windows.";
    };

    menuOpacity = mkOption {
      type = types.numbers.between 0 1;
      default = 1.0;
      description = "Opacity of dropdown and popup menu.";
    };

    wintypes = mkOption {
      type = types.attrs;
      default = {
        popup_menu = {
          opacity = cfg.menuOpacity;
        };
        dropdown_menu = {
          opacity = cfg.menuOpacity;
        };
      };
      description = "Rules for specific window types.";
    };

    opacityRules = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Rules that control the opacity of windows.";
    };

    backend = mkOption {
      type = types.enum [
        "egl"
        "glx"
        "xrender"
        "xr_glx_hybrid"
      ];
      default = "xrender";
      description = "Backend to use.";
    };

    vSync = mkOption {
      type =
        with types;
        either bool (enum [
          "none"
          "drm"
          "opengl"
          "opengl-oml"
          "opengl-swc"
          "opengl-mswc"
        ]);
      default = false;
      apply =
        x:
        let
          res = x != "none";
          msg = "The type of services.picom.vSync has changed to bool: interpreting ${toString x} as ${boolToString res}";
        in
        if isBool x then x else warn msg res;
      description = "Enable vertical synchronization.";
    };

    settings = mkOption {
      description = ''
        Picom configuration. Options defined here will take precedence over
        top-level options.
      '';
      type = libconfig.type;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    # Merge the legacy options into the new settings system
    services.picom.settings = mapAttrs (n: v: mkDefault v) {
      fading = cfg.fade;
      fade-delta = cfg.fadeDelta;
      fade-in-step = elemAt cfg.fadeSteps 0;
      fade-out-step = elemAt cfg.fadeSteps 1;
      fade-exclude = cfg.fadeExclude;
      shadow = cfg.shadow;
      shadow-offset-x = elemAt cfg.shadowOffsets 0;
      shadow-offset-y = elemAt cfg.shadowOffsets 1;
      shadow-opacity = cfg.shadowOpacity;
      shadow-exclude = cfg.shadowExclude;
      active-opacity = cfg.activeOpacity;
      inactive-opacity = cfg.inactiveOpacity;
      wintypes = cfg.wintypes;
      opacity-rule = cfg.opacityRules;
      backend = cfg.backend;
      vsync = cfg.vSync;
    };

    systemd.user.services.picom = {
      description = "Picom composite manager";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      environment = mkIf (cfg.backend == "glx") {
        allow_rgb10_configs = "false";
      };

      serviceConfig = {
        ExecStart = "${getExe cfg.package} --config ${libconfig.generate "picom.conf" cfg.settings}";
        RestartSec = 3;
        Restart = "always";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.arsenik;
in
{
  options.services.arsenik = {
    enable = lib.mkEnableOption "A 33-key layout that works with all keyboards.";
    package = lib.mkPackageOption pkgs "arsenik" { };
    tap_timeout = lib.mkOption {
      default = 200;
      description = "The key must be pressed twice in XX ms to enable repetitions.";
      type = lib.types.int;
    };
    hold_timeout = lib.mkOption {
      default = 200;
      description = "The key must be held XX ms to become a layer shift.";
      type = lib.types.int;
    };
    long_hold_timeout = lib.mkOption {
      default = 300;
      description = "Slightly higher value for typing keys, to prevent unexpected hold effect.";
      type = lib.types.int;
    };
    mac = lib.mkOption {
      default = false;
      description = "Original key arrangement on your keyboard: Mac or PC.";
      type = lib.types.bool;
    };
    anglemod = lib.mkOption {
      default = false;
      description = ''
        Choose here if you want to add an angle mod: ZXCVB are shifted to the left.
        See https://colemakmods.github.io/ergonomic-mods/angle.html for more details.
      '';
      type = lib.types.bool;
    };
    wide = lib.mkOption {
      default = false;
      description = "The right hand is moved one key to the right.";
      type = lib.types.bool;
    };
    lt = lib.mkOption {
      default = false;
      description = "Enable layer-taps.";
      type = lib.types.bool;
    };
    hrm = lib.mkOption {
      default = false;
      description = "Enable homerow.";
      type = lib.types.bool;
    };
    lafayette = lib.mkOption {
      default = false;
      description = "Add AltGr programmation layer like Ergo‑L";
      type = lib.types.bool;
    };
    num = lib.mkOption {
      default = false;
      description = "Add NumRow layer";
      type = lib.types.bool;
    };
    vim = lib.mkOption {
      default = false;
      description = "Navigation layer: ESDF or HJKL?";
      type = lib.types.bool;
    };
    run = lib.mkOption {
      default = "M-p";
      description = "The keyboard shortcut of your application launcher.";
      type = lib.types.str;
    };
    layout = lib.mkOption {
      default = "ergol";
      description = ''
        Your keyboard layout. Possible values are:
        ergol qwerty-lafayette qwerty azerty qwertz bepo optimot
      '';
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.wide -> cfg.anglemod;
        message = "service.arsenik.wide requires service.arsenik.anglemod";
      }
      {
        assertion = cfg.hrm -> cfg.lt;
        message = "service.arsenik.hrm requires service.arsenik.lt";
      }
    ];

    services.kanata =
      let
        src = "${cfg.package}/share/arsenik";
        defsrc = "${if cfg.mac then "mac" else "pc"}${if cfg.wide then "_wide" else ""}${
          if cfg.anglemod then "_anglemod" else ""
        }";
        base = "base${if cfg.lt then "_lt" else ""}${if cfg.hrm then "_hrm" else ""}";
        symbols = "symbols_${if cfg.lafayette then "lafayette" else "noop"}${
          if cfg.num then "_num" else ""
        }";
        navigation = "navigation${if cfg.vim then "_vim" else ""}";
        alias = "${cfg.layout}_${if cfg.mac then "mac" else "pc"}";
      in
      {
        enable = true;
        keyboards.arsenik.config = ''
          (defvar
            tap_timeout ${builtins.toString cfg.tap_timeout}
            hold_timeout ${builtins.toString cfg.hold_timeout}
            long_hold_timeout ${builtins.toString cfg.long_hold_timeout}
          )
          (include ${src}/defsrc/${defsrc}.kbd)
          (include ${src}/deflayer/${base}.kbd)
          (include ${src}/deflayer/${symbols}.kbd)
          (include ${src}/deflayer/${navigation}.kbd)
          (defalias run ${cfg.run})
          (include ${src}/defalias/${alias}.kbd)
        '';
      };
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.kanata-config-aekeynox;

  src = "${cfg.package}/share/kanata-config-aekeynox";

  removedArsenikOption =
    name:
    lib.mkRemovedOptionModule [ "services" "arsenik" name ] ''
      services.arsenik has been replaced by services.kanata-config-aekeynox,
      whose options follow the sections of upstream's kanata.kbd.
      See the NixOS 26.11 release notes.
    '';
in
{
  imports = map removedArsenikOption [
    "enable"
    "package"
    "tap_timeout"
    "hold_timeout"
    "long_hold_timeout"
    "mac"
    "anglemod"
    "wide"
    "lt"
    "hrm"
    "lafayette"
    "num"
    "vim"
    "run"
    "layout"
  ];

  options.services.kanata-config-aekeynox = {
    enable = lib.mkEnableOption "the Arsenik keymap, implemented with kanata";

    package = lib.mkPackageOption pkgs "kanata-config-aekeynox" { };

    devices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "/dev/input/by-id/usb-0000_0000-event-kbd" ];
      description = ''
        Paths to keyboard devices.

        An empty list, the default value, lets kanata detect which
        input devices are keyboards and intercept them all.
      '';
    };

    geometry = lib.mkOption {
      type = lib.types.enum [
        "iso"
        "ansi"
      ];
      default = "iso";
      description = ''
        Pick the configuration matching your keyboard:
        ISO (a.k.a. 102/105 keys) or ANSI (a.k.a. 101/104 keys).
        If the key next to the left Shift is `Z`, your keyboard is ANSI.
      '';
    };

    fingerAssignment = lib.mkOption {
      type = lib.types.enum [
        "layout"
        "layout_anglemod"
        "layout_wide_anglemod"
      ];
      default = "layout";
      description = ''
        Angle-mods can be enabled here, i.e. ZXCVB can be shifted to the left.
        More details here: <https://colemakmods.github.io/ergonomic-mods/angle.html>

        - `layout`: standard finger assignment
        - `layout_anglemod`: ZXCVB are shifted to the left
        - `layout_wide_anglemod`: angle-mod + right hand shifted by one key
      '';
    };

    flavor = lib.mkOption {
      type = lib.types.enum [
        "flavor_ez"
        "flavor_tt"
        "flavor_hrm"
      ];
      default = "flavor_ez";
      description = ''
        Dual keys can be enabled here:
        - `EZ`: no dual keys
          = standard keyboard behavior
        - `TT`: thumb-taps
          - the right thumb key brings the `Symbols` layer
          - a long press on the space bar brings the `Navigation` layer
          - a quick tap on the left/right thumb key makes Backspace/Enter
        - `HRM`: thumb-taps + home row mods
          - the left thumb key becomes Shift
          - SDF/JKL become Meta/Ctrl/Alt when held

        - `flavor_ez`: standard keyboard behavior
        - `flavor_tt`: thumb taps
        - `flavor_hrm`: thumb taps + home row mods

        Note: the other layers are only reachable with `flavor_tt` or `flavor_hrm`.
      '';
    };

    hostLayout = lib.mkOption {
      type = lib.types.enum [
        "qwerty"
        "qwertz"
        "azerty"
        "lafayette"
        "ergol"
        "bepo"
      ];
      default = "qwerty";
      description = ''
        The whole `Symbols` layer and some `Navigation` shortcuts depend on the host
        keyboard layout, i.e. the layout defined in your system settings.
        Pick your aliases accordingly.
      '';
    };

    base = lib.mkOption {
      type = lib.types.enum [
        "base"
        "base/colemak"
        "base/colemak_dh"
        "base/dvorak"
        "base/ergol"
        "base/lafayette"
      ];
      default = "base";
      description = ''
        The `Base` layer can be either:
        - the hardware layout (`base.kbd`)
          => your keyboard follows the host layout (= default behavior),
             which is defined in your system settings.
        - an emulated layout (`base/*.kbd`)
          => your keyboard follows this emulated layout instead of the host layout.
          /!\ This works perfectly with ASCII layout such as QWERTY ANSI,
              but has limitations with non-ASCII layouts.
          /!\ Make sure that the expected host layout (e.g. QWERTY, AZERTY)
              has been selected in `hostLayout`.

        - `base`: no emulation
        - `base/colemak`: QWERTY to Colemak
        - `base/colemak_dh`: QWERTY to Colemak-DH
        - `base/dvorak`: QWERTY to Dvorak
        - `base/ergol`: AZERTY to Ergo-L
        - `base/lafayette`: AZERTY to QWERTY-Lafayette
      '';
    };

    symbols = lib.mkOption {
      type = lib.types.enum [
        "symbols"
        "symbols_altgr"
      ];
      default = "symbols";
      description = ''
        Triggered by Sym (right thumb key).
        - by default, brings a Symbols layer
        - with the `altgr` variant, the right thumb key becomes AltGr/Option

        - `symbols`: programming symbols
        - `symbols_altgr`: AltGr/Option layer
      '';
    };

    numbers = lib.mkOption {
      type = lib.types.enum [
        "numpad"
        "numrow"
      ];
      default = "numpad";
      description = ''
        Triggered by Sym+Shift.

        - `numpad`: right-hand numpad, like on the default Navigation layer
        - `numrow`: numbers on the home row, Shift+numbers on the top row
      '';
    };

    navigation = lib.mkOption {
      type = lib.types.enum [
        "navigation"
        "navigation_vim"
      ];
      default = "navigation";
      description = ''
        Triggered by a long press on the spacebar.

        - `navigation`: arrows on ESDF, NumPad under the right hand
        - `navigation_vim`: arrows on HJKL, advanced keys under the left hand
      '';
    };

    tappingTerm = lib.mkOption {
      type = lib.types.ints.positive;
      default = 300;
      description = ''
        Minimum press time (ms) for "tap-preferred" dual keys: Nav and homerow mods.
        Below this value, these keys just produce Space or a homerow letter.
        Keep this value high if you struggle with home row mods.
      '';
    };

    holdingTerm = lib.mkOption {
      type = lib.types.ints.positive;
      default = 150;
      description = ''
        Maximum press time (ms) for "hold-preferred" dual keys: Enter and Backspace.
        Above this value, these keys just behave as modifiers (Shift and Symbols).
        Keep this value low if you trigger Enter by mistake.
      '';
    };

    quickTap = lib.mkOption {
      type = lib.types.ints.positive;
      default = 200;
      description = "Maximum time (ms) for a double key press to enable repetitions.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.kanata = {
      enable = true;
      keyboards.aekeynox = {
        inherit (cfg) devices;
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defvar
            TAPPING_TERM ${toString cfg.tappingTerm}
            HOLDING_TERM ${toString cfg.holdingTerm}
            QUICK_TAP ${toString cfg.quickTap}
            HM1 lalt
            HM2 lctl
            HM3 lmet
          )
          (include ${src}/defsrc/${cfg.geometry}.kbd)
          (include ${src}/defsrc/${cfg.fingerAssignment}.kbd)
          (include ${src}/defcfg/${cfg.flavor}.kbd)
          (include ${src}/defalias/${cfg.hostLayout}.kbd)
          (include ${src}/deflayer/${cfg.base}.kbd)
          (include ${src}/deflayer/${cfg.symbols}.kbd)
          (include ${src}/deflayer/numlock.kbd)
          (include ${src}/deflayer/${cfg.numbers}.kbd)
          (include ${src}/deflayer/${cfg.navigation}.kbd)
          (include ${src}/deflayer/funmedia.kbd)
        '';
      };
    };
  };
}

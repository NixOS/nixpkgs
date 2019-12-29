{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.sway;

  wrapperOptions = types.submodule {
    options =
      let
        mkWrapperFeature  = default: description: mkOption {
          type = types.bool;
          inherit default;
          example = !default;
          description = "Whether to make use of the ${description}";
        };
      in {
        base = mkWrapperFeature true ''
          base wrapper to execute extra session commands and prepend a
          dbus-run-session to the sway command.
        '';
        gtk = mkWrapperFeature false ''
          wrapGAppsHook wrapper to execute sway with required environment
          variables for GTK applications.
        '';
    };
  };

  swayPackage = pkgs.sway.override {
    extraSessionCommands = cfg.extraSessionCommands;
    extraOptions = cfg.extraOptions;
    withBaseWrapper = cfg.wrapperFeatures.base;
    withGtkWrapper = cfg.wrapperFeatures.gtk;
  };
in {
  options.programs.sway = {
    enable = mkEnableOption ''
      Sway, the i3-compatible tiling Wayland compositor. You can manually launch
      Sway by executing "exec sway" on a TTY. Copy /etc/sway/config to
      ~/.config/sway/config to modify the default configuration. See
      https://github.com/swaywm/sway/wiki and "man 5 sway" for more information.
      Please have a look at the "extraSessionCommands" example for running
      programs natively under Wayland'';

    wrapperFeatures = mkOption {
      type = wrapperOptions;
      default = { };
      example = { gtk = true; };
      description = ''
        Attribute set of features to enable in the wrapper.
      '';
    };

    extraSessionCommands = mkOption {
      type = types.lines;
      default = "";
      example = ''
        export SDL_VIDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
      description = ''
        Shell commands executed just before Sway is started.
      '';
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [
        "--verbose"
        "--debug"
        "--unsupported-gpu"
        "--my-next-gpu-wont-be-nvidia"
      ];
      description = ''
        Command line arguments passed to launch Sway. Please DO NOT report
        issues if you use an unsupported GPU (proprietary drivers).
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
        swaylock swayidle
        xwayland rxvt_unicode dmenu
      ];
      defaultText = literalExample ''
        with pkgs; [ swaylock swayidle xwayland rxvt_unicode dmenu ];
      '';
      example = literalExample ''
        with pkgs; [
          xwayland
          i3status i3status-rust
          termite rofi light
        ]
      '';
      description = ''
        Extra packages to be installed system wide.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.extraSessionCommands != "" -> cfg.wrapperFeatures.base;
        message = ''
          The extraSessionCommands for Sway will not be run if
          wrapperFeatures.base is disabled.
        '';
      }
    ];
    environment = {
      systemPackages = [ swayPackage ] ++ cfg.extraPackages;
      etc = {
        "sway/config".source = mkOptionDefault "${swayPackage}/etc/sway/config";
        #"sway/security.d".source = mkOptionDefault "${swayPackage}/etc/sway/security.d/";
        #"sway/config.d".source = mkOptionDefault "${swayPackage}/etc/sway/config.d/";
      };
    };
    security.pam.services.swaylock = {};
    hardware.opengl.enable = mkDefault true;
    fonts.enableDefaultFonts = mkDefault true;
    programs.dconf.enable = mkDefault true;
    # To make a Sway session available if a display manager like SDDM is enabled:
    services.xserver.displayManager.sessionPackages = [ swayPackage ];
  };

  meta.maintainers = with lib.maintainers; [ gnidorah primeos colemickens ];
}

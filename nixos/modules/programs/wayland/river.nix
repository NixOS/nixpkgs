{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.river;
in {
  options.programs.river = {
    enable = mkEnableOption (lib.mdDoc "river, a dynamic tiling Wayland compositor");

    package = mkPackageOption pkgs "river" {
      nullable = true;
      extraDescription = ''
        Set to `null` to not add any River package to your path.
        This should be done if you want to use the Home Manager River module to install River.
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
        swaylock
        foot
        dmenu
      ];
      defaultText = literalExpression ''
        with pkgs; [ swaylock foot dmenu ];
      '';
      example = literalExpression ''
        with pkgs; [
          termite rofi light
        ]
      '';
      description = lib.mdDoc ''
        Extra packages to be installed system wide. See
        [Common X11 apps used on i3 with Wayland alternatives](https://github.com/swaywm/sway/wiki/i3-Migration-Guide#common-x11-apps-used-on-i3-with-wayland-alternatives)
        for a list of useful software.
      '';
    };
  };

  config =
    mkIf cfg.enable (mkMerge [
      {
        environment.systemPackages = optional (cfg.package != null) cfg.package ++ cfg.extraPackages;

        # To make a river session available if a display manager like SDDM is enabled:
        services.xserver.displayManager.sessionPackages = optionals (cfg.package != null) [ cfg.package ];

        # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1050913
        xdg.portal.config.river.default = mkDefault [ "wlr" "gtk" ];
      }
      (import ./wayland-session.nix { inherit lib pkgs; })
    ]);

  meta.maintainers = with lib.maintainers; [ GaetanLepage ];
}

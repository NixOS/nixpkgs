{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.river;

  wayland-lib = import ./lib.nix { inherit lib; };

  # River does not export WAYLAND_DISPLAY to the systemd activation
  # environment, so UWSM would never see the session become ready.  Run
  # `uwsm finalize` before river's usual init executable.
  uwsmInit = pkgs.writeShellScript "river-uwsm-init" ''
    ${lib.getExe config.programs.uwsm.package} finalize
    init="''${XDG_CONFIG_HOME:-$HOME/.config}/river/init"
    if [ -x "$init" ]; then
      exec "$init"
    fi
  '';
in
{
  options.programs.river = {
    enable = lib.mkEnableOption "river, a non-monolithic Wayland compositor";

    package =
      lib.mkPackageOption pkgs "river" {
        nullable = true;
        extraDescription = ''
          If the package is not overridable with `xwaylandSupport`, then the module option
          {option}`xwayland` will have no effect.

          Set to `null` to not add any River package to your path.
          This should be done if you want to use the Home Manager River module to install River.
        '';
      }
      // {
        apply =
          p:
          if p == null then
            null
          else
            wayland-lib.genFinalPackage p {
              xwaylandSupport = cfg.xwayland.enable;
            };
      };

    xwayland.enable = lib.mkEnableOption "XWayland" // {
      default = true;
    };

    withUWSM = lib.mkEnableOption "UWSM (Unified Wayland Session Manager) to run river without a display manager while still activating `graphical-session.target` for the portal and XDG autostart services";

    extraPackages = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      example = lib.literalExpression ''
        with pkgs; [ alacritty rofi light ]
      '';
      description = ''
        Extra packages to be installed system wide.  River needs a window
        manager implementing the river-window-management-v1 protocol, such as
        kwm.  See [useful software suggested by
        river](https://codeberg.org/river/wiki/src/branch/main/pages/useful-software.md).
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = !config.programs.river-classic.enable;
            message = "programs.river and programs.river-classic both install a `river` binary and session; enable only one of them.";
          }
        ];

        environment.systemPackages = lib.optional (cfg.package != null) cfg.package ++ cfg.extraPackages;

        # To make a river session available if a display manager like SDDM is enabled:
        services.displayManager.sessionPackages = lib.optional (cfg.package != null) cfg.package;

        # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1050913
        xdg.portal.config.river.default = lib.mkDefault [
          "wlr"
          "gtk"
        ];
      }

      (import ./wayland-session.nix {
        inherit lib pkgs;
        enableXWayland = cfg.xwayland.enable;
      })

      (lib.mkIf cfg.withUWSM {
        assertions = [
          {
            assertion = cfg.package != null;
            message = "programs.river.withUWSM needs programs.river.package to be set, since the UWSM entry runs river by store path.";
          }
        ];

        programs.uwsm = {
          enable = true;
          waylandCompositors.river = lib.mkIf (cfg.package != null) {
            prettyName = lib.mkDefault "River";
            comment = lib.mkDefault "River compositor managed by UWSM";
            binPath = lib.mkDefault (lib.getExe cfg.package);
            extraArgs = lib.mkDefault [
              "-c"
              "${uwsmInit}"
            ];
          };
        };
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [ yiyu ];
}

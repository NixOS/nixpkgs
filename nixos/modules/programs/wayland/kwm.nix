{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.kwm;
  river = config.programs.river.package;

  # River does not export WAYLAND_DISPLAY to the systemd activation
  # environment, so signal readiness to UWSM before starting kwm.
  uwsmInit = pkgs.writeShellScript "kwm-uwsm-init" ''
    ${lib.getExe config.programs.uwsm.package} finalize
    exec ${lib.getExe cfg.package}
  '';
in
{
  options.programs.kwm = {
    enable = lib.mkEnableOption "kwm";
    package = lib.mkPackageOption pkgs "kwm" {
      example = ''
        pkgs.kwm.override {
          conf = ./config.zon;
        }
      '';
    };
    withUWSM = lib.mkEnableOption "starting kwm on river through uwsm (Unified Wayland Session Manager), which works without a display manager and activates `graphical-session.target` for the portal and XDG autostart services";
    extraPackages = lib.mkOption {
      type = with lib.types; listOf package;
      default = with pkgs; [
        foot
        wmenu
      ];

      defaultText = lib.literalExpression ''
        with pkgs; [ foot wmenu ];
      '';

      example = lib.literalExpression ''
        with pkgs; [ alacritty fuzzel kanshi ]
      '';

      description = ''
        Extra packages to be installed system wide.  The defaults are the
        terminal and launcher that kwm's default configuration starts.  See
        [useful software suggested by
        river](https://codeberg.org/river/wiki/src/branch/main/pages/useful-software.md).
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        # kwm starts kwim by store path; kwim is also on PATH for `kwim list`
        # and `kwim apply`, which kwm(1) points users to, and for its manuals
        environment.systemPackages = [
          cfg.package
          pkgs.kwim
        ];

        # Session that runs `river -c kwm`, listed before the bare river session
        services.displayManager.sessionPackages = lib.mkBefore [ cfg.package ];

        # Session file sets XDG_CURRENT_DESKTOP to kwm:wlroots
        xdg.portal.config.kwm.default = lib.mkDefault [
          "wlr"
          "gtk"
        ];

        programs.river = {
          enable = true;
          inherit (cfg) extraPackages;
        };
      }

      (lib.mkIf cfg.withUWSM {
        assertions = [
          {
            assertion = river != null;
            message = "programs.kwm.withUWSM needs programs.river.package to be set, since the UWSM entry runs river by store path.";
          }
        ];

        programs.uwsm = {
          enable = true;
          waylandCompositors.kwm = lib.mkIf (river != null) {
            prettyName = lib.mkDefault "kwm";
            comment = lib.mkDefault "kwm on the River compositor managed by UWSM";
            binPath = lib.mkDefault (lib.getExe river);
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

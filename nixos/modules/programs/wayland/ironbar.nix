{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.ironbar;
in
{
  options.programs.ironbar = {
    enable = lib.mkEnableOption "ironbar, a customizable gtk-layer-shell wlroots/sway bar written in Rust";

    package = lib.mkPackageOption pkgs "ironbar" { };

    systemd.target = lib.mkOption {
      type = lib.types.str;
      description = ''
        The systemd target that will automatically start the Ironbar service.
      '';
      default = "graphical-session.target";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd = {
      packages = [ cfg.package ];
      user.services.ironbar.wantedBy = [ cfg.systemd.target ];
    };
  };

  meta.maintainers = with lib.maintainers; [ lonerOrz ];
}

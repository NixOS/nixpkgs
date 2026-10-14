{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.kanshi;
in
{
  options.services.kanshi = {
    enable = lib.mkEnableOption "kanshi, a Wayland daemon that automatically configures outputs";
    package = lib.mkPackageOption pkgs "kanshi" { };
    systemd.target = lib.mkOption {
      type = lib.types.str;
      description = ''
        The systemd target that will automatically start the Kanshi service.
      '';
      default = "graphical-session.target";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.kanshi ];

    systemd.user.services.kanshi = {
      unitConfig = {
        Description = "Dynamic output configuration";
        Documentation = "man:kanshi(1)";
        ConditionEnvironment = "WAYLAND_DISPLAY";
        PartOf = cfg.systemd.target;
        Requires = cfg.systemd.target;
        After = cfg.systemd.target;
      };

      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "always";
      };

      wantedBy = [ cfg.systemd.target ];
    };
  };
  meta.maintainers = [ lib.maintainers.macaquinyho ];
}

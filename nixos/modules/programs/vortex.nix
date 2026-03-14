{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.vortex;
in
{
  options.programs.vortex = {
    enable = lib.mkEnableOption "Vortex mod manager from Nexus Mods";

    package = lib.mkPackageOption pkgs "vortex" { };

    dataDir = lib.mkOption {
      type = lib.types.str;
      description = "Vortex data directory.";
    };

    downloadsDir = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.dataDir}/downloads";
      description = "Directory for downloaded mod archives.";
    };

    stagingDir = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Directory for mod staging (per-game subdirs created by Vortex).";
    };
  };

  meta.maintainers = with lib.maintainers; [ caniko ];

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    xdg.mime.defaultApplications = {
      "x-scheme-handler/nxm" = "vortex.desktop";
    };

    systemd.tmpfiles.rules =
      [
        "d ${cfg.dataDir} 0775 root users -"
        "d ${cfg.downloadsDir} 0775 root users -"
      ]
      ++ lib.optionals (cfg.stagingDir != null) [
        "d ${cfg.stagingDir} 0775 root users -"
      ];
  };
}

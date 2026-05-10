{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.wl-clip-persist;
in
{
  meta.maintainers = with lib.maintainers; [ xavwe ];

  options.services.wl-clip-persist = {
    enable = lib.mkEnableOption "Keep Wayland clipboard even after programs close";

    package = lib.mkPackageOption pkgs "wl-clip-persist" { };

    clipboard = lib.mkOption {
      type = lib.types.enum [
        "regular"
        "primary"
        "both"
      ];
      default = "regular";
      description = ''
        The clipboard to persist
      '';
    };

    extraFlags = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = ''
        Extra flags to pass to wl-clip-persist
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.wl-clip-persist = {
      enable = true;
      description = "wl-clip-persist daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "${lib.getExe cfg.package} --clipboard ${cfg.clipboard} ${lib.escapeShellArgs cfg.extraFlags}";
    };
  };
}

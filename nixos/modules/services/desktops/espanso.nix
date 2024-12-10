{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.espanso;
in
{
  meta = {
    maintainers = with lib.maintainers; [ numkem ];
  };

  options = {
    services.espanso = {
      enable = mkEnableOption "Espanso";
      package = mkPackageOption pkgs "espanso" {
        example = "pkgs.espanso-wayland";
      };
    };
  };

  config = mkIf cfg.enable {
    services.espanso.package = mkIf cfg.wayland pkgs.espanso-wayland;
    systemd.user.services.espanso = {
      description = "Espanso daemon";
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} daemon";
        Restart = "on-failure";
      };
      wantedBy = [ "default.target" ];
    };

    environment.systemPackages = [ cfg.package ];
  };
}

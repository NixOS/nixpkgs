{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.espanso;
in
{
  meta = {
    maintainers = with lib.maintainers; [
      n8henrie
      numkem
    ];
  };

  options = {
    services.espanso = {
      enable = lib.mkEnableOption "Espanso";
      package = lib.mkPackageOption pkgs "espanso" {
        example = "pkgs.espanso-wayland";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.espanso = lib.mkIf (cfg.package.waylandSupport or false) {
      capabilities = "cap_dac_override+p";
      owner = "root";
      group = "root";
      source = lib.getExe (cfg.package.override { securityWrapperPath = config.security.wrapperDir; });
    };
    systemd.user.services.espanso = {
      description = "Espanso daemon";
      serviceConfig = {
        ExecStart = "${
          if (cfg.package.waylandSupport or false) then
            "${config.security.wrapperDir}/espanso"
          else
            lib.getExe cfg.package
        } daemon";
        Restart = "on-failure";
      };
      wantedBy = [ "graphical-session.target" ];
    };

    environment.systemPackages = [ cfg.package ];
  };
}

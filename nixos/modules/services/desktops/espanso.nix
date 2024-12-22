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

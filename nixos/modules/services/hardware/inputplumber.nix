{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.inputplumber;
in
{
  options.services.inputplumber = {
    enable = mkEnableOption "InputPlumber";
    package = mkPackageOption pkgs "inputplumber" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.inputplumber = {
      description = "InputPlumber Service";
      wantedBy = [ "multi-user.target" ];
      environment = {
        XDG_DATA_DIRS = "/run/current-system/sw/share";
      };
      restartIfChanged = true;

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "on-failure";
        RestartSec = "5";
      };
    };
  };

  meta.maintainers = with maintainers; [ shadowapex ];
}

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.elephant;
in
{
  options.services.elephant = {
    enable = lib.mkEnableOption "Elephant application launcher backend";

    package = lib.mkPackageOption pkgs "elephant" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.elephant = {
      description = "Elephant application launcher backend";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Restart = "always";
        RestartSec = 10;
        ExecStart = "${cfg.package}/bin/elephant";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [
    saadndm
  ];
}

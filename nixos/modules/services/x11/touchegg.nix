{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.touchegg;

in
{
  meta = {
    maintainers = lib.teams.pantheon.members;
  };

  ###### interface
  options.services.touchegg = {
    enable = lib.mkEnableOption "touchegg, a multi-touch gesture recognizer";

    package = lib.mkPackageOption pkgs "touchegg" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    systemd.services.touchegg = {
      description = "Touchegg Daemon";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/touchegg --daemon";
        Restart = "on-failure";
      };
      wantedBy = [ "multi-user.target" ];
    };

    environment.systemPackages = [ cfg.package ];
  };
}

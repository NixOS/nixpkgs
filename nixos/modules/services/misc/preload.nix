{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.preload;
in {
  meta = { maintainers = pkgs.preload.meta.maintainers; };

  options.services.preload = {
    enable = mkEnableOption "preload";
    package = mkPackageOption pkgs "preload" { };
  };

  config = mkIf cfg.enable {
    systemd.services.preload = {
      description = "Loads data into ram during idle time of CPU.";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        EnvironmentFile = "${cfg.package}/etc/conf.d/preload";
        ExecStart = "${getExe cfg.package} -l '' --foreground $PRELOAD_OPTS";
        Type = "simple";
        # Only preload data during CPU idle time
        IOSchedulingClass = 3;
        DynamicUser = true;
        StateDirectory = "preload";
      };
    };
  };
}

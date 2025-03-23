{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.preload;
in
{
  meta = {
    maintainers = pkgs.preload.meta.maintainers;
  };

  options.services.preload = {
    enable = lib.mkEnableOption "preload";
    package = lib.mkPackageOption pkgs "preload" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.preload = {
      description = "Loads data into ram during idle time of CPU.";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        EnvironmentFile = "${cfg.package}/etc/conf.d/preload";
        ExecStart = "${lib.getExe cfg.package} -l '' --foreground $PRELOAD_OPTS";
        Type = "simple";
        # Only preload data during CPU idle time
        IOSchedulingClass = 3;
        DynamicUser = true;
        StateDirectory = "preload";
      };
    };
  };
}

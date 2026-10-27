{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.framework-control;
in
{
  meta.maintainers = [ lib.maintainers.ozturkkl ];

  options.services.framework-control = {
    enable = lib.mkEnableOption "Framework Control device hardware service";
    package = lib.mkPackageOption pkgs "framework-control" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.framework-control = {
      description = "Framework Control Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      # framework-control shells out to framework_tool at runtime for hardware access
      path = [ pkgs.framework-tool ];

      serviceConfig = {
        Type = "simple";
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        RestartSec = "5s";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
      };
    };
  };
}

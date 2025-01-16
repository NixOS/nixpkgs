{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe'
    mkDefault
    mkEnableOption
    mkIf
    mkPackageOption
    ;

  cfg = config.services.ultraleap;
in
{
  options.services.ultraleap = {
    enable = mkEnableOption "Ultraleap hand tracking service";

    servicePackage = mkPackageOption pkgs "ultraleap-hand-tracking-service" { };
    layerPackage = mkPackageOption pkgs "openxr-ultraleap-layer" { };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ cfg.servicePackage ];

    systemd.tmpfiles.settings."10-ultraleap"."/etc/ultraleap".d = {
      user = "leap";
      group = "leap";
      mode = "0755";
    };

    systemd.services."ultraleap-hand-tracking-service" = {
      description = "Ultraleap Tracking Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        "LIBTRACK_IS_SERVICE" = mkDefault "1";
      };

      serviceConfig = {
        Type = "exec";
        ExecStart = getExe' cfg.servicePackage "leapd";
        User = "leap";
        Group = "leap";
        KillMode = "process";
        KillSignal = "SIGINT";
        Restart = "on-failure";
        LogsDirectory = "leap";
      };
    };

    environment.systemPackages = [
      cfg.servicePackage
      cfg.layerPackage
    ];
    environment.pathsToLink = [ "/share/openxr" ];

    users.users.leap = {
      isSystemUser = true;
      group = "leap";
      # udev rules from -service grant access to plugdev
      extraGroups = [ "plugdev" ];
    };
    users.groups.leap = { };
  };

  meta.maintainers = with lib.maintainers; [
    Scrumplex
    pandapip1
  ];
}

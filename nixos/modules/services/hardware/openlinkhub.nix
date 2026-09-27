{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.openlinkhub;
in
{
  options.services.openlinkhub = {
    enable = lib.mkEnableOption "OpenLinkHub device controller and WebUI";
    package = lib.mkPackageOption pkgs "openlinkhub" { };
  };

  config = lib.mkIf cfg.enable {
    users.groups.openlinkhub = { };
    users.users.openlinkhub = {
      isSystemUser = true;
      group = "openlinkhub";
    };

    services.udev.packages = [ cfg.package ];

    systemd.services.openlinkhub = {
      description = "OpenLinkHub device controller and WebUI";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = "openlinkhub";
        Group = "openlinkhub";
        StateDirectory = "openlinkhub";
        WorkingDirectory = "/var/lib/openlinkhub";
        ExecStartPre = "${cfg.package.provision} /var/lib/openlinkhub";
        ExecStart = "${cfg.package}/opt/OpenLinkHub/OpenLinkHub";
        Restart = "on-failure";
      };
    };
  };
}

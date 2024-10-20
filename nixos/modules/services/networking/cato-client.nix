{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  cfg = config.services.cato-client;
in
{
  options.services.cato-client = {
    enable = mkEnableOption "cato-client service";
    package = mkPackageOption pkgs "cato-client" { };
  };

  config = mkIf cfg.enable {
    #users.users = {
    #  cato-client = {
    #    isSystemUser = true;
    #    group = "cato-client";
    #    description = "Cato Client daemon user";
    #  };
    #};
    users.groups = {
      cato-client = { };
    };

    systemd.services.cato-client = {
      enable = true;
      description = "Cato Networks Linux client - connects tunnel to Cato cloud";
      after = [ "network.target" ];

      serviceConfig = {
        Type = "simple";
        #User = "cato-client";
        User = "root";
        Group = "cato-client";
        ExecStart = "${cfg.package}/bin/cato-clientd systemd";
        WorkingDirectory = "${cfg.package}";
        Restart = "always";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}

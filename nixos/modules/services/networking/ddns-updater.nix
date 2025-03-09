{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.ddns-updater;
in
{
  options.services.ddns-updater = {
    enable = lib.mkEnableOption "Container to update DNS records periodically with WebUI for many DNS providers";

    package = lib.mkPackageOption pkgs "ddns-updater" { };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Environment variables to be set for the ddns-updater service. DATADIR is ignored to enable using systemd DynamicUser. For full list see https://github.com/qdm12/ddns-updater";
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.ddns-updater = {
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment = cfg.environment // {
        DATADIR = "%S/ddns-updater";
      };
      unitConfig = {
        Description = "DDNS-updater service";
      };
      serviceConfig = {
        TimeoutSec = "5min";
        ExecStart = lib.getExe cfg.package;
        RestartSec = 30;
        DynamicUser = true;
        StateDirectory = "ddns-updater";
        Restart = "on-failure";
      };
    };
  };
}

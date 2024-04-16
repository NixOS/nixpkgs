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

    environmentalVariables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Environment variables to be set for the ddns-updater service. For full list see https://github.com/qdm12/ddns-updater";
      default = {
        LISTENING_ADDRESS = ":8000";
        DATADIR = "/updater/data";
      };
    };

    user = lib.mkOption {
      type = lib.types.str;
      description = "User to run service as. Owns DATADIR";
      default = "ddns-updater";
    };
  };

  config = lib.mkIf cfg.enable {
    services.ddns-updater.environmentalVariables = {
      LISTENING_ADDRESS = lib.mkDefault ":8000";
      DATADIR = lib.mkDefault "/updater/data";
    };

    systemd.services.ddns-updater = {
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        Description = "DDNS-updater service";
        After = [ "network.target" ];
      };
      serviceConfig = {
        TimeoutSec = "5min";
        Environment =
          let
            envVars = lib.attrsets.mapAttrsToList (name: value: name + "=" + value) cfg.environmentalVariables;
          in
          envVars;
        ExecStart = "${cfg.package}/bin/ddns-updater";
        RestartSec = 30;
        Restart = "on-failure";
        User = "${cfg.user}";
      };
    };

    users.users.${cfg.user} = {
      description = "DDNS Updater service user";
      home = cfg.environmentalVariables.DATADIR;
      createHome = true;
      isSystemUser = true;
      group = "${cfg.user}";
    };

    users.groups.${cfg.user} = { };
  };
}

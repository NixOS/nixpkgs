{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.prowlarr;
  servarr = import ./settings-options.nix { inherit lib pkgs; };
in
{
  options = {
    services.prowlarr = {
      enable = lib.mkEnableOption "Prowlarr, an indexer manager/proxy for Torrent trackers and Usenet indexers";

      package = lib.mkPackageOption pkgs "prowlarr" { };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the Prowlarr web interface.";
      };

      settings = servarr.mkServarrSettingsOptions "prowlarr" 9696;

      environmentFiles = servarr.mkServarrEnvironmentFiles "prowlarr";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.prowlarr = {
      description = "Prowlarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = servarr.mkServarrSettingsEnvVars "PROWLARR" cfg.settings // {
        HOME = "/var/empty";
      };

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "prowlarr";
        EnvironmentFile = cfg.environmentFiles;
        ExecStart = "${lib.getExe cfg.package} -nobrowser -data=/var/lib/prowlarr";
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.server.port ];
    };
  };
}

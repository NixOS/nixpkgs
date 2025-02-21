{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.prowlarr;
  servarr = import ./servarr/settings-options.nix { inherit lib pkgs; };
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

      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          Environment file to pass secret configuration values.

          Each line must follow the `PROWLARR__SECTION__KEY=value` pattern.
          Please consult the documentation at the [wiki](https://wiki.servarr.com/useful-tools#using-environment-variables-for-config).
        '';
      };
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

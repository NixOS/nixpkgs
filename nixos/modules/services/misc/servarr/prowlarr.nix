{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.prowlarr;
  servarr = import ./settings-options.nix { inherit lib pkgs; };
  isCustomDataDir = cfg.dataDir != "/var/lib/prowlarr";
in
{
  options = {
    services.prowlarr = {
      enable = lib.mkEnableOption "Prowlarr, an indexer manager/proxy for Torrent trackers and Usenet indexers";

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/prowlarr";
        description = ''
          The directory where Prowlarr stores its data files.

          Note: A bind mount will be used to mount the directory at the expected location
          if a different value than `/var/lib/prowlarr` is used.
        '';
      };

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
    systemd = {
      services.prowlarr = {
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

      tmpfiles.settings."10-prowlarr".${cfg.dataDir}.d = lib.mkIf isCustomDataDir {
        user = "root";
        group = "root";
        mode = "0700";
      };

      mounts = lib.optional isCustomDataDir {
        what = cfg.dataDir;
        where = "/var/lib/private/prowlarr";
        options = "bind";
        wantedBy = [ "local-fs.target" ];
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.server.port ];
    };
  };
}

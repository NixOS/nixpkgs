{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prowlarr;

in
{
  options = {
    services.prowlarr = {
      enable = mkEnableOption "Prowlarr, an indexer manager/proxy for Torrent trackers and Usenet indexers";

      package = mkPackageOption pkgs "prowlarr" { };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/prowlarr/.config/Prowlarr";
        description = "The directory where Prowlarr stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the Prowlarr web interface.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.settings."10-prowlarr".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services.prowlarr = {
      description = "Prowlarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "prowlarr";
        ExecStart = "${lib.getExe cfg.package} -nobrowser -data='${cfg.dataDir}'";
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 9696 ];
    };
  };
}

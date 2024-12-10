{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.prowlarr;

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
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.prowlarr = {
      description = "Prowlarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "prowlarr";
        ExecStart = "${lib.getExe cfg.package} -nobrowser -data=/var/lib/prowlarr";
        Restart = "on-failure";
      };
      environment.HOME = "/var/empty";
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 9696 ];
    };
  };
}

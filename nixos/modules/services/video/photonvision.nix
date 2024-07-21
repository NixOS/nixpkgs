{ config, pkgs, lib, ... }:

let
  cfg = config.services.photonvision;
in
{
  options = {
    services.photonvision = {
      enable = lib.mkEnableOption "PhotonVision";

      package = lib.mkPackageOption pkgs "photonvision" {};

      openFirewall = lib.mkOption {
        description = ''
          Whether to open the required ports in the firewall.
        '';
        default = false;
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.photonvision = {
      description = "PhotonVision, the free, fast, and easy-to-use computer vision solution for the FIRST Robotics Competition";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;

        # ephemeral root directory
        RuntimeDirectory = "photonvision";
        RootDirectory = "/run/photonvision";

        # setup persistent state and logs directories
        StateDirectory = "photonvision";
        LogsDirectory = "photonvision";

        BindReadOnlyPaths = [
          # mount the nix store read-only
          "/nix/store"

          # the JRE reads the user.home property from /etc/passwd
          "/etc/passwd"
        ];
        BindPaths = [
          # mount the configuration and logs directories to the host
          "/var/lib/photonvision:/photonvision_config"
          "/var/log/photonvision:/photonvision_config/logs"
        ];

        # for PhotonVision's dynamic libraries, which it writes to /tmp
        PrivateTmp = true;
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 5800 ];
      allowedTCPPortRanges = [{ from = 1180; to = 1190; }];
    };
  };
}

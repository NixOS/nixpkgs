{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hqplayerd;
  pkg = pkgs.hqplayerd;
in {
  options = {
    services.hqplayerd = {
      enable = mkEnableOption "HQPlayer Embedded";

      licenseFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Path to the HQPlayer license key file.

          Without this, the service will run in trial mode and restart every 30
          minutes.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open TCP port 8088 in the firewall for the server.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      etc = {
        "hqplayer/hqplayerd4-key.xml" = mkIf (cfg.licenseFile != null) { source = cfg.licenseFile; };
        "modules-load.d/taudio2.conf".source = "${pkg}/etc/modules-load.d/taudio2.conf";
      };
      systemPackages = [ pkg ];
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8088 ];
    };

    services.udev.packages = [ pkg ];

    systemd = {
      mounts = [{
        description = "HQPlayer daemon state";
        options = "bind";
        partOf = [ "hqplayerd.service" ];
        what = "/var/lib/hqplayerd";
        where = "/var/hqplayer";
      }];

      services.hqplayerd = {
        description = "HQPlayer daemon";
        wantedBy = [ "multi-user.target" ];
        requires = [ "network-online.target" "sound.target" "systemd-udev-settle.service" ];
        after = [ "network-online.target" "sound.target" "systemd-udev-settle.service" "local-fs.target" "remote-fs.target" ];

        unitConfig.RequiresMountsFor = "/var/hqplayer";

        serviceConfig = {
          ExecStart = "${pkg}/bin/hqplayerd";

          DynamicUser = true;
          User = "hqplayer";
          Group = "hqplayer";
          SupplementaryGroups = [ "audio" ];

          Restart = "on-failure";
          RestartSec = 5;

          StateDirectory = "hqplayerd";

          Nice = -10;
          IOSchedulingClass = "realtime";
          LimitMEMLOCK = "1G";
          LimitNICE = -10;
          LimitRTPRIO = 98;
        };

        preStart = ''
          mkdir -p /var/lib/hqplayerd/{home,web}
          cp -r -f ${pkg}/var/lib/hqplayerd/web /var/lib/hqplayerd/
        '';
      };
    };
  };
}

{ config, pkgs, lib, ... }:

with pkgs;
with lib;

let
  cfg = config.services.jitsi-meet.jitsi-meet;
in {
  options = {
    services.jitsi-meet.jitsi-meet = {
      enable = mkEnableOption "jitsi-meet";

      user = mkOption {
        type = types.str;
        default = "nobody";
        description = ''
          User name under which jitsi-meet shall be started.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "nogroup";
        description = ''
          Group under which jitsi-meet shall be started.
        '';
      };

      configjs = mkOption {
        type = types.str;
        description = "config.js";
        default = ''
          var config = {
            hosts: {
              domain: 'jitsi.example.com',
              muc: 'conference.jitsi.example.com',
              bridge: 'jitsi-videobridge.jitsi.example.com'
              },
              useNicks: false,
              bosh: '//jitsi.example.com/http-bind',
              desktopSharing: 'false'
            };
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.jitsi-meet = {
      description = "jitsi-meet";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStartPre = "+${pkgs.coreutils}/bin/mkdir -p /run/jitsi-meet";
        ExecStart = "+${pkgs.coreutils}/bin/ln -sf ${pkgs.writeText "config.js" cfg.configjs} /run/jitsi-meet/config.js";
        ExecStop = "+${pkgs.coreutils}/bin/rm -f /run/jitsi-meet/config.js";
        PrivateTmp = true;
        WorkingDirectory = "/tmp";
      };
    };
  };
}

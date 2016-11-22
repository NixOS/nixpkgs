{ config, pkgs, lib, ... }:

with pkgs;
with lib;

let
  cfg = config.services.jitsi.jitsi-meet;
in {
  options = rec {
    services.jitsi.jitsi-meet = {
      enable = mkEnableOption "jitsi-meet";

      user = mkOption {
        type = types.str;
        default = "root";
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

      hostname = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          Sets the hostname.
        '';
      };

      domain = mkOption {
        type = types.str;
        default = "localdomain";
        description = ''
          Sets the domain.
        '';
      };

      configuration = mkOption {
        type = types.str;
        description = "config.js";
        default = ''
          var config = {
            hosts: {
              domain: '${cfg.hostname}.${cfg.domain}',
              muc: 'conference.${cfg.hostname}.${cfg.domain}',
              bridge: 'jitsi-videobridge.${cfg.hostname}.${cfg.domain}'
            },
            useNicks: false,
            bosh: '//${cfg.hostname}.${cfg.domain}/http-bind',
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

      script = ''
        ${pkgs.coreutils}/bin/mkdir -p /run/jitsi-meet
        ${pkgs.coreutils}/bin/ln -sf ${pkgs.writeText "config.js" cfg.configuration} /run/jitsi-meet/config.js
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "oneshot";
        PrivateTmp = true;
        WorkingDirectory = "/tmp";
      };
    };
  };
}

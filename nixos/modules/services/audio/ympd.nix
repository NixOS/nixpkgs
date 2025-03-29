{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ympd;
in
{

  ###### interface

  options = {

    services.ympd = {

      enable = lib.mkEnableOption "ympd, the MPD Web GUI";

      webPort = lib.mkOption {
        type = lib.types.either lib.types.str lib.types.port; # string for backwards compat
        default = "8080";
        description = "The port where ympd's web interface will be available.";
        example = "ssl://8080:/path/to/ssl-private-key.pem";
      };

      mpd = {
        host = lib.mkOption {
          type = lib.types.str;
          default = "localhost";
          description = "The host where MPD is listening.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = config.services.mpd.network.port;
          defaultText = lib.literalExpression "config.services.mpd.network.port";
          description = "The port where MPD is listening.";
          example = 6600;
        };
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    systemd.services.ympd = {
      description = "Standalone MPD Web GUI written in C";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        ExecStart = ''
          ${pkgs.ympd}/bin/ympd \
            --host ${cfg.mpd.host} \
            --port ${toString cfg.mpd.port} \
            --webport ${toString cfg.webPort}
        '';

        DynamicUser = true;
        NoNewPrivileges = true;

        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ProtectHome = "tmpfs";

        PrivateTmp = true;
        PrivateDevices = true;
        PrivateIPC = true;

        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;

        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        SystemCallFilter = [
          "@system-service"
          "~@process"
          "~@setuid"
        ];
      };
    };

  };

}

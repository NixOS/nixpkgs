{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ympd;
in {

  ###### interface

  options = {

    services.ympd = {

      enable = mkEnableOption (lib.mdDoc "ympd, the MPD Web GUI");

      webPort = mkOption {
        type = types.either types.str types.port; # string for backwards compat
        default = "8080";
        description = lib.mdDoc "The port where ympd's web interface will be available.";
        example = "ssl://8080:/path/to/ssl-private-key.pem";
      };

      mpd = {
        host = mkOption {
          type = types.str;
          default = "localhost";
          description = lib.mdDoc "The host where MPD is listening.";
        };

        port = mkOption {
          type = types.int;
          default = config.services.mpd.network.port;
          defaultText = literalExpression "config.services.mpd.network.port";
          description = lib.mdDoc "The port where MPD is listening.";
          example = 6600;
        };
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.ympd = {
      description = "Standalone MPD Web GUI written in C";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.ympd}/bin/ympd --host ${cfg.mpd.host} --port ${toString cfg.mpd.port} --webport ${toString cfg.webPort} --user nobody";
    };

  };

}

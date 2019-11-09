{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.calibre-server;

in

{

  ###### interface

  options = {
    services.calibre-server = {
      enable = mkEnableOption "calibre-server";

      libraryDir = mkOption {
        description = ''
          The directory where the Calibre library to serve is.
        '';
        type = types.path;
      };

      listenAddress = mkOption {
        default = "::";
        example = "127.0.0.1";
        description = ''
          The interface on which to listen for connections. The value "::" will
          listen on all available IPv4 and IPv6 addresses.
        '';
        type = types.str;
      };

      port = mkOption {
        default = 8080;
        description = ''
          The port the Calibre server should listen on.
        '';
        type = types.int;
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.calibre-server =
      {
        description = "Calibre Server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "calibre-server";
          Restart = "always";
          ExecStart = "${pkgs.calibre}/bin/calibre-server --listen-on ${cfg.listenAddress} --port ${toString cfg.port} ${cfg.libraryDir}";
        };
      };

    environment.systemPackages = [ pkgs.calibre ];

    users.users.calibre-server = {
        uid = config.ids.uids.calibre-server;
        group = "calibre-server";
      };

    users.groups.calibre-server = {
        gid = config.ids.gids.calibre-server;
      };

  };
}

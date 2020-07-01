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
          ExecStart = "${pkgs.calibre}/bin/calibre-server ${cfg.libraryDir}";
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

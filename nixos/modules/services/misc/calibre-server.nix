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
        default = "/tmp/calibre-server";
        description = ''
          The directory where the Calibre library to serve is.
          '';
      };

      user = mkOption {
        type = types.str;
        default = "calibre-server";
        description = "User account under which calibre-server runs.";
      };

      group = mkOption {
        type = types.str;
        default = "calibre-server";
        description = "Group account under which calibre-server runs.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.calibre-server =
      {
        description = "calibre-server, an OPDS server for a Calibre library";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "${cfg.user}";
          Restart = "always";
          ExecStart = "${pkgs.calibre}/bin/calibre-server --with-library=${cfg.libraryDir}";
        };

      };

    environment.systemPackages = [ pkgs.calibre ];

    users.extraUsers = optionalAttrs (cfg.user == "calibre-server") (singleton
      { name = "calibre-server";
        group = cfg.group;
        uid = config.ids.uids.calibre-server;
      });

    users.extraGroups = optionalAttrs (cfg.group == "calibre-server") (singleton
      { name = "calibre-server";
        gid = config.ids.gids.calibre-server;
      });

  };

}

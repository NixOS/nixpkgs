{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.calibre-server;

in

{

  ###### interface

  options = {

    services.calibre-server = {

      enable = mkEnableOption' {
        name = "calibre-server";
        package = literalPackage pkgs "pkgs.calibre";
      };

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
          ExecStart = "${pkgs.calibre}/bin/calibre-server --with-library=${cfg.libraryDir}";
        };

      };

    environment.systemPackages = [ pkgs.calibre ];

    users.extraUsers.calibre-server = {
        uid = config.ids.uids.calibre-server;
        group = "calibre-server";
      };

    users.extraGroups.calibre-server = {
        gid = config.ids.gids.calibre-server;
      };

  };

}

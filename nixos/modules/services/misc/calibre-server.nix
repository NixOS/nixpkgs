{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.calibre-server;

in

{
  imports = [
    (mkChangedOptionModule [ "services" "calibre-server" "libraryDir" ] [ "services" "calibre-server" "libraries" ]
      (config:
        let libraryDir = getAttrFromPath [ "services" "calibre-server" "libraryDir" ] config;
        in [ libraryDir ]
      )
    )
  ];

  ###### interface

  options = {
    services.calibre-server = {

      enable = mkEnableOption "calibre-server";

      libraries = mkOption {
        description = ''
          The directories of the libraries to serve. They must be readable for the user under which the server runs.
        '';
        type = types.listOf types.path;
      };

      user = mkOption {
        description = "The user under which calibre-server runs.";
        type = types.str;
        default = "calibre-server";
      };

      group = mkOption {
        description = "The group under which calibre-server runs.";
        type = types.str;
        default = "calibre-server";
      };

      userdb = mkOption {
        description = ''
          The path to the user database.
                      If null, run without authentification.
                      Database must be created by hand using calibre-server --userdb PATH --manage-users.'';
        type = types.path;
        default = null;
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.calibre-server = {
      description = "Calibre Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        Restart = "always";
        ExecStart = ''
          ${pkgs.calibre}/bin/calibre-server
                  ${
                    if cfg.userdb == null then
                      ""
                    else
                      "--enable-auth --userdb " + cfg.userdb
                  }
          ${lib.concatStringsSep " " cfg.libraries} '';
      };

    };

    environment.systemPackages = [ pkgs.calibre ];

    users.users = optionalAttrs (cfg.user == "calibre-server") {
      calibre-server = {
        home = "/var/lib/calibre-server";
        createHome = true;
        uid = config.ids.uids.calibre-server;
        group = cfg.group;
      };
    };

    users.groups = optionalAttrs (cfg.group == "calibre-server") {
      calibre-server = {
        gid = config.ids.gids.calibre-server;
      };
    };

  };

}

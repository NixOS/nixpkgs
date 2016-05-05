{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    services.dictd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the DICT.org dictionary server.
        '';
      };

      DBs = mkOption {
        type = types.listOf types.package;
        default = [];
        example = [ pkgs.dictdDBs.nld2eng ];
        description = ''List of databases to make available.'';
      };

    };

  };


  ###### implementation

  config = let dictdb = pkgs.dictDBCollector { dictlist = map (x: {
               name = x.name;
               filename = x; } ) config.services.dictd.DBs; };
  in mkIf config.services.dictd.enable {

    # get the command line client on system path to make some use of the service
    environment.systemPackages = [ pkgs.dict ];

    users.extraUsers = singleton
      { name = "dictd";
        group = "dictd";
        description = "DICT.org dictd server";
        home = "${dictdb}/share/dictd";
        uid = config.ids.uids.dictd;
      };

    users.extraGroups = singleton
      { name = "dictd";
        gid = config.ids.gids.dictd;
      };

    systemd.services.dictd = {
      description = "DICT.org Dictionary Server";
      wantedBy = [ "multi-user.target" ];
      environment = { LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive"; };
      serviceConfig.Type = "forking";
      script = "${pkgs.dict}/sbin/dictd -s -c ${dictdb}/share/dictd/dictd.conf --locale en_US.UTF-8";
    };
  };
}

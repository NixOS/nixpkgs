{ config, lib, pkgs, ... }:
let
  cfg = config.services.monetdb;
  monetdbUser = "monetdb";
in
with lib;
{

  ###### interface

  options = {

    services.monetdb = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable MonetDB database server.";
      };

      package = mkOption {
        type = types.path;
        description = "MonetDB package to use.";
      };

      dbfarmDir = mkOption {
        type = types.path;
        default = "/var/lib/monetdb";
        description = ''
          Specifies location of Monetdb dbfarm (keeps database and auxiliary files).
        '';
      };

      port = mkOption {
        default = "50000";
        example = "50000";
        description = "Port to listen on.";
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers.monetdb = 
      { name = monetdbUser;
        uid = config.ids.uids.monetdb;
        description = "monetdb user";
        home = cfg.dbfarmDir;
      };

    users.extraGroups.monetdb.gid = config.ids.gids.monetdb;

    environment.systemPackages = [ cfg.package ];

    systemd.services.monetdb =
      { description = "MonetDB Server";

        wantedBy = [ "multi-user.target" ];

        after = [ "network.target" ];

        path = [ cfg.package ];

        preStart =
          ''
            # Initialise the database.
            if ! test -e ${cfg.dbfarmDir}/.merovingian_properties; then
                mkdir -m 0700 -p ${cfg.dbfarmDir}
                chown -R ${monetdbUser} ${cfg.dbfarmDir}
                ${cfg.package}/bin/monetdbd create ${cfg.dbfarmDir}
                ${cfg.package}/bin/monetdbd set port=${cfg.port} ${cfg.dbfarmDir}
            fi
          '';

        serviceConfig.ExecStart = "${cfg.package}/bin/monetdbd start -n ${cfg.dbfarmDir}";

        serviceConfig.ExecStop = "${cfg.package}/bin/monetdbd stop ${cfg.dbfarmDir}";

        unitConfig.RequiresMountsFor = "${cfg.dbfarmDir}";
      };

  };

}

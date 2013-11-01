{ config, pkgs, ... }:
let
  cfg = config.services.fourStore;
  stateDir = "/var/lib/4store";
  fourStoreUser = "fourstore";
  run = "${pkgs.su}/bin/su -s ${pkgs.stdenv.shell} ${fourStoreUser}";
in
with pkgs.lib;
{

  ###### interface

  options = {

    services.fourStore = {

      enable = mkOption {
        default = false;
        description = "Whether to enable 4Store RDF database server.";
      };

      database = mkOption {
        default = "";
        description = "RDF database name. If it doesn't exist, it will be created. Databases are stored in ${stateDir}.";
      };

      options = mkOption {
        default = "";
        description = "Extra CLI options to pass to 4Store.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = singleton
      { assertion = cfg.enable -> cfg.database != "";
        message = "Must specify 4Store database name.";
      };

    users.extraUsers = singleton
      { name = fourStoreUser;
        uid = config.ids.uids.fourStore;
        description = "4Store database user";
        home = stateDir;
      };

    services.avahi.enable = true;

    jobs.fourStore = {
      name = "4store";
      startOn = "filesystem";

      preStart = ''
        mkdir -p ${stateDir}/
        chown ${fourStoreUser} ${stateDir}
        if ! test -e "${stateDir}/${cfg.database}"; then
          ${run} -c '${pkgs.rdf4store}/bin/4s-backend-setup ${cfg.database}'
        fi
      '';

      exec = ''
        ${run} -c '${pkgs.rdf4store}/bin/4s-backend -D ${cfg.options} ${cfg.database}'
      '';
    };

  };

}

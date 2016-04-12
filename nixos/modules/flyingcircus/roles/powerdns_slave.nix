{ config, lib, pkgs, ... }: with lib;
let
    cfg = config.flyingcircus.roles.powerdns_slave;

    sqlite_db_structure = builtins.readFile ./powerdns_slave.sql;
    int_database = "/srv/powerdns/pdns-int.sqlite";

in

{

  options = {

    flyingcircus.roles.powerdns_slave = {

      enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable the Flying Circus Powerdns server role.";
      };
    };
  };


  config = mkIf cfg.enable {

    flyingcircus.roles.powerdns.enable = true;

    environment.etc."local/powerdns/pdns-int.conf".text = ''
      local-address = 172.22.49.45
      local-ipv6 = 2a02:248:101:63::1184

      slave = true
      launch = gsqlite3
      gsqlite3-database = ${int_database}
      # Xxx
    '';

    system.activationScripts.fcio-powerdns_slave = ''
      if [ ! -e ${int_database} ]; then
        cat <<EOF | sudo -u powerdns ${pkgs.sqlite}/bin/sqlite3 ${int_database}
        ${sqlite_db_structure}
      EOF
      fi
    '';

    # Since we store data in sqlite we need to be able to interact with it.
    environment.systemPackages = [ pkgs.sqlite ];


  };
}

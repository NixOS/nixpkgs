{ config, pkgs, ... }:

with pkgs.lib;

# unixODBC drivers (this solution is not perfect.. Because the user has to
# ask the admin to add a driver.. but it's simple and works

{
  ###### interface

  options = {
    environment.unixODBCDrivers = mkOption {
      default = [];
      example = literalExample "map (x : x.ini) (with pkgs.unixODBCDrivers; [ mysql psql psqlng ] )";
      description = ''
        Specifies Unix ODBC drivers to be registered in
        <filename>/etc/odbcinst.ini</filename>.  You may also want to
        add <literal>pkgs.unixODBC</literal> to the system path to get
        a command line client to connnect to ODBC databases.
      '';
    };
  };

  ###### implementation

  config = mkIf (config.environment.unixODBCDrivers != []) {

    environment.etc."odbcinst.ini".text =
      let inis = config.environment.unixODBCDrivers;
      in pkgs.lib.concatStringsSep "\n" inis;

  };

}

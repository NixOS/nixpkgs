{ config, lib, pkgs, ... }:

with lib;

# unixODBC drivers (this solution is not perfect.. Because the user has to
# ask the admin to add a driver.. but it's simple and works

let
  iniDescription = pkg: ''
    [${pkg.fancyName}]
    Description = ${pkg.meta.description}
    Driver = ${pkg}/${pkg.driver}
  '';

in {
  ###### interface

  options = {
    environment.unixODBCDrivers = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExample "with pkgs.unixODBCDrivers; [ sqlite psql ]";
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
    environment.etc."odbcinst.ini".text = concatMapStringsSep "\n" iniDescription config.environment.unixODBCDrivers;
  };

}

{ config, lib, ... }:

with lib;

# unixODBC drivers (this solution is not perfect.. Because the user has to
# ask the admin to add a driver.. but it's simple and works

let
  iniDescription = pkg: ''
    [${pkg.fancyName}]
    Description = ${pkg.meta.description}
    Driver = ${pkg}/${pkg.driver}
  '';

in
{
  ###### interface

  options = {
    environment.unixODBCDrivers = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression "with pkgs.unixODBCDrivers; [ sqlite psql ]";
      description = ''
        Specifies Unix ODBC drivers to be registered in
        {file}`/etc/odbcinst.ini`.  You may also want to
        add `pkgs.unixODBC` to the system path to get
        a command line client to connect to ODBC databases.
      '';
    };
  };

  ###### implementation

  config = mkIf (config.environment.unixODBCDrivers != [ ]) {
    environment.etc."odbcinst.ini".text =
      concatMapStringsSep "\n" iniDescription
        config.environment.unixODBCDrivers;
  };

}

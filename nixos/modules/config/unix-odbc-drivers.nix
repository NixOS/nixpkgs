{ config, lib, pkgs, ... }:

with lib;

# unixODBC drivers (this solution is not perfect.. Because the user has to
# ask the admin to add a driver.. but it's simple and works

let
  cfg = config.environment.odbc;

  driverManagers = {
    "libiodbc" = pkgs.libiodbc;
    "unixODBC" = pkgs.unixODBC;
  };

  iniDescription = pkg: {
    "${pkg.fancyName}" = {
      Description = pkg.meta.description;
      Driver = "${pkg}/${pkg.driver}";
    };
  };
  toOdbcinstIni = drvs: generators.toINI {}
    # merge drivers together by fancy name & convert to ini
    (foldl' mergeAttrs {}
      (map iniDescription drvs));

in {
  ###### interface

  options = {
    environment.odbc.drivers = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExample "with pkgs.odbcDrivers; [ sqlite psql ]";
      description = ''
        Specifies ODBC drivers to be registered in
        <filename>/etc/odbcinst.ini</filename>.
        Every driver is given the specified <literal>odbcDriverManager</literal>
        as argument. Drivers in <literal>pkgs.odbcDrivers</literal> are
        guaranteed to support that interface.
      '';
    };

    environment.odbc.driverManager = mkOption {
      type = types.enum (mapAttrsToList (name: _: name) driverManagers);
      # this is chosen because libiodbc is actively maintained (2016)
      default = "libiodbc";
      description = ''
        ODBC driver manager to use. This will determine how drivers are
        built and what interface the user gets for DSN management.
        The driver manager tooling is put into <literal>systemPackages</literal>.
      '';
    };


    # deprecated
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

  config = mkMerge [
    (mkIf (config.environment.unixODBCDrivers != []) {
      environment.etc."odbcinst.ini".text =
        toOdbcinstIni config.environment.unixODBCDrivers;
    })

    (mkIf (cfg.drivers != []) {
      environment.etc."odbcinst.ini".text =
        let drvs' = map (drv: drv.override
                          # compile drivers with correct driverManager
                          { odbcDriverManager = cfg.driverManager; }) cfg.drivers;
        in toOdbcinstIni drvs';
      # add driver manager tooling to systemPackages
      environment.systemPackages = [ driverManagers."${cfg.driverManager}" ];
    })

    # deprecate unixODBCDrivers
    (mkIf (config.environment.unixODBCDrivers != []) {
      # deprecated Nov '16
      warnings = [ "`environment.unixODBCDrivers` is deprecated. Please use `environment.odbc.*` instead." ];
      assertions = [
        { assertion = (config.environment.unixODBCDrivers != [])
            -> ! ((cfg.driverManager != "libiodbc") || (cfg.drivers != []));
          message = "If you want to use something from `environment.odbc` you can’t use `environment.unixODBCDrivers`.";
        }
      ];
    })
  ];

}

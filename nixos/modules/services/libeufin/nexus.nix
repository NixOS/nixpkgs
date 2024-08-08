{
  lib,
  config,
  options,
  pkgs,
  ...
}:
# TODO: refactor shared code with the bank
let
  this = config.services.libeufin.nexus;
  serviceName = "libeufin-nexus";
  dbinitServiceName = "libeufin-nexus-dbinit";
  inherit (config.services.libeufin) configFile;

  # Mandatory configuration values
  # See https://docs.taler.net/libeufin/nexus-manual.html#setting-up-the-ebics-subscriber
  mandatoryOptions = [
    {
      name = "CURRENCY";
      description = "Name of the fiat currency.";
      example = "CHF";
    }
    {
      name = "HOST_BASE_URL";
      description = "URL of the EBICS server.";
      example = "https://ebics.postfinance.ch/ebics/ebics.aspx";
    }
    {
      name = "BANK_DIALECT";
      description = ''
        Name of the following combination: EBICS version and ISO20022
        recommendations that Nexus would honor in the communication with the
        bank.

        Currently only the "postfinance" or "gls" value is supported.
      '';
      example = "postfinance";
    }
    {
      name = "HOST_ID";
      description = "Name of the EBICS host.";
      example = "PFEBICS";
    }
    {
      name = "USER_ID";
      description = ''
        User ID of the EBICS subscriber.

        This value must be assigned by the bank after having activated a new EBICS subscriber.
      '';
      example = "PFC00563";
    }
    {
      name = "PARTNER_ID";
      description = ''
        Partner ID of the EBICS subscriber.

        This value must be assigned by the bank after having activated a new EBICS subscriber.
      '';
      example = "PFC00563";
    }
    {
      name = "IBAN";
      description = "IBAN of the bank account that is associated with the EBICS subscriber.";
      example = "CH7789144474425692816";
    }
    {
      name = "BIC";
      description = "BIC of the bank account that is associated with the EBICS subscriber.";
      example = "POFICHBEXXX";
    }
    {
      name = "NAME";
      description = "Legal entity that is associated with the EBICS subscriber.";
      example = "John Smith S.A.";
    }
  ];
in
{
  options.services.libeufin.nexus = {
    enable = lib.mkEnableOption "EBICS facilitator and component of the libeufin core banking system";
    package = lib.mkPackageOption pkgs "libeufin" { };
    debug = lib.mkEnableOption "debug logging";

    settings = lib.mkOption {
      description = ''
        Configuration options for the libeufin nexus config file.

        For a list of all possible options, please see the man page [`libeufin-nexus.conf(5)`](https://docs.taler.net/manpages/libeufin-nexus.conf.5.html)
      '';
      type = lib.types.submodule {
        inherit (options.services.libeufin.settings.type.nestedTypes) freeformType;
        options = {
          nexus-ebics = lib.pipe mandatoryOptions [
            (map (option: {
              inherit (option) name;
              value = lib.mkOption {
                type = lib.types.str;
                default = "You must set `libeufin.nexus.nexus-ebics.${option.name}`";
                defaultText = "None, you must set this yourself.";
                inherit (option) description example;
              };
            }))
            lib.listToAttrs
          ];
          nexus-httpd = {
            PORT = lib.mkOption {
              type = lib.types.port;
              default = 8084;
              description = ''
                The port on which libeufin-bank should listen.
              '';
            };
          };
          # TODO: should nexus be in a different DB?
          libeufin-nexusdb-postgres = {
            CONFIG = lib.mkOption {
              type = lib.types.str;
              internal = true;
              default = "postgresql:///${serviceName}";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf this.enable {
    services.libeufin = {
      inherit (this) enable settings;
    };

    systemd.services =
      let
        nexusExe = "${lib.getExe' this.package serviceName}";
      in
      {
        ${serviceName} = {
          serviceConfig = {
            DynamicUser = true;
            User = serviceName;
            ExecStart = "${nexusExe} serve -c ${configFile}" + lib.optionalString this.debug " -L debug";
            StateDirectory = serviceName;
            ReadWritePaths = [ "/var/lib/${serviceName}" ];
          };
          requires = [ "${dbinitServiceName}.service" ];
          after = [ "${dbinitServiceName}.service" ];
          wantedBy = [ "multi-user.target" ]; # TODO slice?
        };
        ${dbinitServiceName} = {
          path = [ config.services.postgresql.package ];
          script = "${nexusExe} dbinit -c ${configFile}" + lib.optionalString this.debug " -L debug";
          serviceConfig = {
            Type = "oneshot";
            DynamicUser = true;
            User = serviceName;
          };
          requires = [ "postgresql.service" ];
          after = [ "postgresql.service" ];
        };
      };

    services.postgresql.enable = true;
    services.postgresql.ensureDatabases = [ serviceName ];
    services.postgresql.ensureUsers = [
      {
        name = serviceName;
        ensureDBOwnership = true;
      }
    ];
  };
}

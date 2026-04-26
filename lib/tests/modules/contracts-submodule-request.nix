# Tests that contract requests support submodule-typed options.
#
# Defines a contract whose request has a `connection` submodule (with `host`
# and `port` sub-options) alongside a flat `name` option.  The provider reads
# both and produces a result string, verifying the full structure survives the
# want -> requests -> provider -> results round-trip.
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkOption types;

  connectionContractDef = {
    meta = {
      description = "Contract with a submodule-typed request for testing.";
      maintainers = [ ];
    };
    interface = {
      request = {
        name = mkOption {
          description = "Service name.";
          type = types.str;
        };
        connection = mkOption {
          description = "Connection parameters.";
          type = types.submodule {
            options = {
              host = mkOption {
                description = "Hostname.";
                type = types.str;
              };
              port = mkOption {
                description = "Port number.";
                type = types.int;
              };
            };
          };
        };
      };
      result.url = mkOption {
        description = "Constructed URL.";
        type = types.str;
      };
    };
  };

  evaluated = lib.evalOption (mkOption { type = lib.contract.templateType; }) connectionContractDef;
  inherit (evaluated) mkProviderType;
in
{
  imports = [ lib.contract.module ];

  options.meta = mkOption {
    type = types.attrs;
    default = { };
  };

  options.services.urlbuilder.connection = mkOption {
    default = config.contracts.connection.requests;
    type = mkProviderType {
      fulfill =
        { name, connection }:
        {
          url = "${name}://${connection.host}:${toString connection.port}";
        };
    };
  };

  config = {
    contractTypes.connection = connectionContractDef;

    contracts.connection.want.myapp.db = {
      request = {
        name = "postgresql";
        connection = {
          host = "db.example.com";
          port = 5432;
        };
      };
    };

    contracts.connection.providers.urlbuilder.module = options.services.urlbuilder.connection;
    contracts.connection.defaultProviderName = "urlbuilder";
  };
}

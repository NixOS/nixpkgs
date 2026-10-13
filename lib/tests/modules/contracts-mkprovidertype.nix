# Providers that use `mkProviderType`.
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.contractTypes) number connection;
in
{
  imports = [ lib.contract.module ];

  options = {
    increment = mkOption {
      type = number.mkProviderType {
        overrides.request.value.default = 5;
        fulfill = request: { value = request.value + 1; };
      };
    };

    locate = mkOption {
      type = number.mkProviderType {
        providerOptions.factor = mkOption {
          type = types.int;
          default = 1;
        };
        fulfill' =
          {
            request,
            name,
            loc,
            instance,
          }:
          {
            value = request.value * instance.providerOptions.factor;
            text = "${name} ${lib.concatStringsSep "." loc}";
          };
      };
    };

    urlbuilder = mkOption {
      type = connection.mkProviderType {
        fulfill =
          { scheme, connection }:
          {
            url = "${scheme}://${connection.host}:${toString connection.port}";
          };
      };
    };
  };

  config = lib.mkMerge [
    {
      contractTypes.number = {
        meta = {
          description = "A number, and a text about it.";
          maintainers = [ lib.maintainers.kiara ];
        };
        interface = {
          options.request = mkOption {
            type = types.submodule {
              options.value = mkOption { type = types.int; };
            };
          };
          options.response = mkOption {
            type = types.submodule {
              options.value = mkOption { type = types.int; };
              options.text = mkOption {
                type = types.str;
                default = "";
              };
            };
          };
        };
      };

      # A contract type with a request option of a submodule type.
      contractTypes.connection = {
        meta = {
          description = "A URL from connection parameters.";
          maintainers = [ lib.maintainers.kiara ];
        };
        interface = {
          options.request = mkOption {
            type = types.submodule {
              options.scheme = mkOption { type = types.str; };
              options.connection = mkOption {
                type = types.submodule {
                  options.host = mkOption { type = types.str; };
                  options.port = mkOption { type = types.int; };
                };
              };
            };
          };
          options.response = mkOption {
            type = types.submodule {
              options.url = mkOption { type = types.str; };
            };
          };
        };
      };

      increment = config.contracts.number.providerRequests.increment;
      locate = config.contracts.number.providerRequests.locate;
      urlbuilder = config.contracts.connection.providerRequests.urlbuilder;
      contracts.number.providers = lib.genAttrs [ "increment" "locate" ] (name: {
        module = options.${name};
        contract = [ ];
      });
      contracts.connection.providers.urlbuilder = {
        module = options.urlbuilder;
        contract = [ ];
      };
      contracts.number.defaultProvider = config.contracts.number.providers.increment;
      # Select the provider by its name.
      contracts.connection.defaultProviderName = "urlbuilder";

      contracts.number.want.app.x.request.value = 10;
      contracts.number.want.app.db.primary.request.value = 20;
    }
    {
      # A definition of a `response` option replaces the value from `fulfill`.
      increment.app.db.primary.response.value = 0;

      contracts.connection.want.app.db.request = {
        scheme = "postgresql";
        connection = {
          host = "db.example.com";
          port = 5432;
        };
      };

      # Entries that do not come from `want`.
      increment.direct = { };
      locate.a.b = {
        request.value = 3;
        providerOptions.factor = 7;
      };
    }
  ];
}

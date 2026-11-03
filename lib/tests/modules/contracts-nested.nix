# Routing of nested `want` entries from consumers to a provider.
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkOption types;
  top = config;
in
{
  imports = [ lib.contract.module ];

  options.provider = mkOption {
    type = types.nestedAttrsOf (
      types.submodule (
        { config, ... }:
        {
          imports = [ top.contractTypes.sum.interface ];
          options.response = mkOption {
            default = { };
            type = types.submodule {
              options.value = mkOption {
                default = config.request.a + config.request.b + config.providerOptions.extra;
              };
            };
          };
          options.providerOptions = mkOption {
            default = { };
            type = types.submodule {
              options.extra = mkOption {
                type = types.int;
                default = 0;
              };
            };
          };
        }
      )
    );
  };

  # A consumer option that holds the request and the result of an entry.
  options.consumer = mkOption {
    default = { };
    type = config.contractTypes.sum.mkContract { };
  };

  options.wantedEntries = mkOption {
    type = types.str;
    default = lib.concatStringsSep "," (
      lib.mapAttrsToList (
        consumer: entries: "${consumer}:${lib.concatStringsSep "+" (lib.attrNames entries)}"
      ) config.contracts.sum.providerRequests.provider
    );
  };

  config = lib.mkMerge [
    {
      contractTypes.sum = {
        meta = {
          description = "Sum of two numbers.";
          maintainers = [ lib.maintainers.kiara ];
        };
        interface = {
          options.request = mkOption {
            default = { };
            type = types.submodule {
              options.a = mkOption {
                type = types.int;
                default = 1;
              };
              options.b = mkOption {
                type = types.int;
                default = 2;
              };
            };
          };
          options.response = mkOption {
            type = types.submodule {
              options.value = mkOption { type = types.int; };
            };
          };
        };
      };

      provider = config.contracts.sum.providerRequests.provider;
      contracts.sum.providers.provider = {
        module = options.provider;
        contract = [ ];
      };
      contracts.sum.defaultProvider = config.contracts.sum.providers.provider;

      # Two consumers with an entry of the same name.
      contracts.sum.want.c1.x.request.a = 10;
      contracts.sum.want.c2.x = { };
      # An entry at depth 3.
      contracts.sum.want.c3.db.primary.request.b = 5;
      # A consumer sends its whole option, and reads the request and the response from `results`.
      consumer.request.a = 20;
      consumer.response = config.contracts.sum.results.c5.x;
      contracts.sum.want.c5.x = config.consumer;
      # An entry that is not sent.
      contracts.sum.want.c4 = lib.mkIf false { x = { }; };
    }
    {
      # A provider option on an entry must not remove the request from the consumer.
      provider.c1.x.providerOptions.extra = 100;
    }
  ];
}

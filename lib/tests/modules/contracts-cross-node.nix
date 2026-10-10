# Contracts across two module evaluations, for example two NixOS nodes.
#
# The two nodes have no shared `config.contracts`:
# - The provider node gets the `requests` of the consumer node in `want`.
# - The consumer node has the default provider of the provider node
#   as its default provider.
# The consumer module and the provider module do not change.
{ lib, ... }:
let
  inherit (lib) mkOption types;

  numberContract = {
    imports = [ lib.contract.module ];
    contractTypes.number = {
      meta = {
        description = "A number that the provider changes.";
        maintainers = [ lib.maintainers.kiara ];
      };
      interface = {
        options.request = mkOption {
          type = types.submodule { options.value = mkOption { type = types.int; }; };
        };
        options.response = mkOption {
          type = types.submodule { options.value = mkOption { type = types.int; }; };
        };
      };
    };
  };

  consumerModule =
    { config, ... }:
    {
      options.consumer.value = mkOption {
        type = types.int;
        default = config.contracts.number.results.consumer-value.value;
      };
      config.contracts.number.want.consumer-value.request.value = 5;
    };

  providerModule =
    { config, options, ... }:
    {
      options.increment = mkOption {
        type = types.raw;
        default = lib.mapAttrs (_: entry: {
          response.value = entry.request.value + 1;
        }) config.contracts.number.providerRequests.increment;
      };
      config.contracts.number = {
        providers.increment = {
          module = options.increment;
          contract = [ ];
        };
        defaultProvider = config.contracts.number.providers.increment;
      };
    };

  evalNode = modules: (lib.evalModules { modules = [ numberContract ] ++ modules; }).config;

  providerNode = evalNode [
    providerModule
    { contracts.number.want = consumerNode.contracts.number.requests; }
  ];

  consumerNode = evalNode [
    consumerModule
    { contracts.number.defaultProvider = providerNode.contracts.number.defaultProvider; }
  ];

  consumerOnlyNode = evalNode [ consumerModule ];
in
{
  options = {
    consumerValue = mkOption { default = consumerNode.consumer.value; };
    providerEntries = mkOption {
      default = lib.concatStringsSep "," (lib.attrNames providerNode.increment);
    };
    consumerOnlyValue = mkOption { default = consumerOnlyNode.consumer.value; };
  };
}

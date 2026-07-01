# Tests the basic want -> instances -> results round-trip.
# The contract type is defined inline; instances are wired manually rather than
# through a provider reference, so no defaultProvider is needed.
{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  imports = [ lib.contract.module ];

  options.meta = mkOption {
    type = types.attrs;
    default = { };
  };

  options.result = mkOption {
    type = types.int;
  };

  config = {
    contractDefinitions.basic = {
      meta = {
        description = "Arithmetic contract for basic round-trip tests.";
        maintainers = [ ];
      };
      interface = {
        request.value = mkOption {
          description = "Input value.";
          type = types.int;
        };
        result.value = mkOption {
          description = "Output value.";
          type = types.int;
        };
      };
    };

    # Consumer: one instance with a request.
    contracts.basic.want.consumer.x.request.value = 5;

    # Provider: wire instances directly
    contracts.basic.instances.consumer.x = {
      result.value = 6;
    };

    result = config.contracts.basic.results.consumer.x.value;
  };
}

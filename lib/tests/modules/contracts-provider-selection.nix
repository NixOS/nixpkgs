# Tests provider selection mechanisms:
# - no provider: accessing results errors with a clear message
# - byRef: `defaultProvider` reference for the default + a per-instance
#   override at one `instances` leaf (the other falls through to the default)
# - byName: `defaultProviderName` enum
{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;

  # Inline definition needed because this test creates two contract types
  # sharing the same interface, and referencing config.contractTypes.arithmetic
  # inside contractTypes would cause infinite recursion.
  arithmeticInterface = {
    meta = {
      description = "Arithmetic contract for provider selection tests.";
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

  evaluated = lib.evalOption (mkOption { type = lib.contract.templateType; }) arithmeticInterface;
  inherit (evaluated) mkProviderType;

  mkProvider =
    f:
    mkOption {
      type = mkProviderType {
        fulfill =
          { value }:
          {
            value = f value;
          };
      };
    };
in
{
  imports = [ ./contracts-arithmetic-contract.nix ];

  options.services.increment.arithmetic = mkProvider (v: v + 1);
  options.services.double.arithmetic = mkProvider (v: v * 2);

  options.result = mkOption {
    type = types.attrsOf types.int;
  };

  config = {
    # Additional contract types sharing the arithmetic interface.
    contractTypes = lib.genAttrs [
      "noProvider"
      "byRef"
      "byName"
    ] (_: arithmeticInterface);

    # -- Providers: feed requests, compute results --

    services.increment.arithmetic = lib.mkMerge (
      map (ct: config.contracts.${ct}.requests) [
        "byRef"
        "byName"
      ]
    );
    services.double.arithmetic = config.contracts.byRef.requests;

    # Register providers.
    contracts.byRef.providers.increment = config.services.increment.arithmetic;
    contracts.byRef.providers.double = config.services.double.arithmetic;
    contracts.byName.providers.increment = config.services.increment.arithmetic;

    # -- Consumers --

    contracts.noProvider.want.consumer.instance.request.value = 5;
    # Two instances under one consumer so the override only touches one of them.
    contracts.byRef.want.consumer.fast.request.value = 5;
    contracts.byRef.want.consumer.slow.request.value = 5;
    contracts.byName.want.consumer.instance.request.value = 5;

    # -- Provider selection --

    # byRef: defaultProvider reference picks "increment" for everything
    # (so `slow` -> 6), and a per-instance override at `consumer.fast`
    # picks "double" (5 * 2 = 10) by reading the provider's instance at
    # the matching path. Per-leaf priority handling in `nestedAttrsOf`
    # lets the override compose against the `defaultProvider`-derived
    # tree without `recursiveUpdate`.
    contracts.byRef.defaultProvider = config.contracts.byRef.providers.increment;
    contracts.byRef.instances.consumer.fast = config.contracts.byRef.providers.double.consumer.fast;

    # byName: set defaultProviderName to "increment" (5 + 1 = 6)
    contracts.byName.defaultProviderName = "increment";

    # -- Collect results --
    result = {
      default = config.contracts.byRef.results.consumer.slow.value;
      override = config.contracts.byRef.results.consumer.fast.value;
      byName = config.contracts.byName.results.consumer.instance.value;
    };
  };
}

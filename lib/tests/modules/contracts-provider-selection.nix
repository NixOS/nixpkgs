# Tests provider selection mechanisms:
# - instances-only routing: a `want` leaf routed via a per-instance `instances`
#   override resolves even with no `defaultProvider` set; a sibling leaf routed
#   by neither a default nor an override stays unrouted (per-leaf routing)
# - byRef: `defaultProvider` reference for the default + a per-instance
#   override at one `instances` leaf (the other falls through to the default)
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkOption types;

  # Inline definition needed because this test creates two contract types
  # sharing the same interface, and referencing config.contractDefinitions.arithmetic
  # inside contractDefinitions would cause infinite recursion.
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

  evaluated = lib.evalOption (mkOption { type = lib.contract.definitionType; }) arithmeticInterface;
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
    contractDefinitions = lib.genAttrs [
      "noProvider"
      "byRef"
    ] (_: arithmeticInterface);

    # -- Providers: feed requests, compute results --

    services.increment.arithmetic = lib.mkMerge [
      config.contracts.byRef.requests
      config.contracts.noProvider.requests
    ];
    services.double.arithmetic = config.contracts.byRef.requests;

    # Register providers.
    contracts.byRef.providers.increment.module = options.services.increment.arithmetic;
    contracts.byRef.providers.double.module = options.services.double.arithmetic;
    # `noProvider` gets a registered provider but no `defaultProvider`, so its
    # leaves are only routed by explicit `instances` overrides.
    contracts.noProvider.providers.increment.module = options.services.increment.arithmetic;

    # -- Consumers --

    # `routed` is routed via a per-instance `instances` override (no default);
    # `unrouted` is routed by neither, so demanding its result errors.
    contracts.noProvider.want.consumer.routed.request.value = 5;
    contracts.noProvider.want.consumer.unrouted.request.value = 5;
    contracts.noProvider.instances.consumer.routed = config.contracts.noProvider.providers.increment;
    # Two instances under one consumer so the override only touches one of them.
    contracts.byRef.want.consumer.fast.request.value = 5;
    contracts.byRef.want.consumer.slow.request.value = 5;

    # -- Provider selection --

    # byRef: defaultProvider reference picks "increment" for everything
    # (so `slow` -> 6), and a per-instance override at `consumer.fast`
    # picks "double" (5 * 2 = 10) by reading the provider's instance at
    # the matching path. Per-leaf priority handling in `nestedAttrsOf`
    # lets the override compose against the `defaultProvider`-derived
    # tree without `recursiveUpdate`.
    contracts.byRef.defaultProvider = config.contracts.byRef.providers.increment;
    contracts.byRef.instances.consumer.fast = config.contracts.byRef.providers.double;

    # -- Collect results --
    result = {
      default = config.contracts.byRef.results.consumer.slow.value;
      override = config.contracts.byRef.results.consumer.fast.value;
      # instances-only routing: resolves via the `instances` override despite
      # `noProvider` having no `defaultProvider` (5 + 1 = 6).
      instancesOnly = config.contracts.noProvider.results.consumer.routed.value;
    };
  };
}

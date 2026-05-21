# Tests provider selection mechanisms:
# - instances-only routing: a `want` leaf routed via a per-instance `instances`
#   override resolves even with no `defaultProvider` set; a sibling leaf routed
#   by neither a default nor an override stays unrouted (per-leaf routing)
# - by reference: `defaultProvider` reference for the default + a per-instance
#   override at one `instances` leaf (the other falls through to the default)
# - by name: `defaultProviderName` enum
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

  # evaluated = lib.evalOption (mkOption { type = lib.contract.definitionType; }) arithmeticInterface;
  # Uses the raw `_mkProviderType` rather than the `forModule` wrapper because
  # the single `services.increment.arithmetic` option absorbs requests from
  # three sibling contract types (`noProvider`, `by`) via
  # `lib.mkMerge` below; the wrapped form would pre-bind one contract's
  # `_requests`, which would be wrong for the other two.
  inherit (lib.contract.forModule config) arithmetic;

  mkProvider =
    f:
    mkOption {
      type = arithmetic.mkProviderType {
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

  # Routing view: which consumer instances each provider's `providerRequests`
  # slice gathers (sorted, dot-joined), and a request value carried through it.
  options.routed = mkOption {
    type = types.attrsOf types.str;
  };

  config = {
    # Additional contract types sharing the arithmetic interface.
    contractDefinitions.noProvider = arithmeticInterface;
    contractDefinitions.by = arithmeticInterface;

    # -- Providers: feed requests, compute results --

    services.increment.arithmetic = lib.mkMerge [
      config.contracts.by.requests
      config.contracts.noProvider.requests
    ];
    services.double.arithmetic = config.contracts.by.requests;

    # Register providers.
    contracts.by.providers.increment.module = options.services.increment.arithmetic;
    contracts.by.providers.double.module = options.services.double.arithmetic;
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
    contracts.by.want.consumer.fast.request.value = 5;
    contracts.by.want.consumer.slow.request.value = 5;
    contracts.by.want.consumer.instance.request.value = 5;

    # -- Provider selection --

    # by: defaultProvider reference picks "increment" for everything
    # (so `slow` -> 6), and a per-instance override at `consumer.fast`
    # picks "double" (5 * 2 = 10) by reading the provider's instance at
    # the matching path. Per-leaf priority handling in `nestedAttrsOf`
    # lets the override compose against the `defaultProvider`-derived
    # tree without `recursiveUpdate`.
    contracts.by.defaultProvider = config.contracts.by.providers.increment;
    contracts.by.instances.consumer.fast = config.contracts.by.providers.double;

    # by: set defaultProviderName to "increment" (5 + 1 = 6)
    contracts.by.defaultProviderName = "increment";

    # -- Collect results --
    result = {
      default = config.contracts.by.results.consumer.slow.value;
      override = config.contracts.by.results.consumer.fast.value;
      by = config.contracts.by.results.consumer.instance.value;
      # instances-only routing: resolves via the `instances` override despite
      # `noProvider` having no `defaultProvider` (5 + 1 = 6).
      instancesOnly = config.contracts.noProvider.results.consumer.routed.value;
    };

    # -- providerRequests routing --
    # `increment` is the default, so it gathers every instance except the
    # `consumer.fast` override; `double` gathers only that override. Each
    # provider's slice mirrors `requests`, so the request values survive.
    routed = {
      increment = lib.concatStringsSep "," (
        lib.sort (a: b: a < b) (lib.attrNames config.contracts.by.providerRequests.increment.consumer)
      );
      double = lib.concatStringsSep "," (
        lib.sort (a: b: a < b) (lib.attrNames config.contracts.by.providerRequests.double.consumer)
      );
      incrementValue = toString config.contracts.by.providerRequests.increment.consumer.slow.request.value;
    };
  };
}

# Tests that a provider's contract option may live at any *submodule nesting
# depth* inside the provider's root option:
#
#   depth 0: the provider's root option IS the contract option
#            (`options.depth0 = mkOption { type = mkProviderType ...; }`).
#   depth 1: the contract option lives one submodule deep, inside the
#            provider's root submodule.
#   depth 2: the contract option lives two submodules deep.
#
# This is distinct from namespace-style attribute paths
# (`options.foo.bar.contract`), which are just chained attr access and don't
# introduce any wrapping option.
#
# Three contract types (each sharing the arithmetic interface) with their
# default providers' contract options placed at depths 0, 1, and 2. Each
# provider returns `request.value + N` (with a different N per depth) so we
# can tell which one fulfilled which contract.
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.contractTypes.arithmetic) mkProviderType;

  arithmeticInterface = (config.contractTypes.arithmetic).interface;

  mkProviderOpt =
    add:
    mkOption {
      type = mkProviderType {
        fulfill =
          { value }:
          {
            value = value + add;
          };
      };
    };
in
{
  imports = [ ./contracts-arithmetic-contract.nix ];

  # depth 0: the provider's root option *is* the contract option.
  options.depth0 = mkProviderOpt 1;

  # depth 1: the contract option lives one submodule level inside the root.
  options.depth1 = mkOption {
    type = types.submodule {
      options.arithmetic = mkProviderOpt 10;
    };
  };

  # depth 2: the contract option lives two submodule levels inside the root.
  options.depth2 = mkOption {
    type = types.submodule {
      options.inner = mkOption {
        type = types.submodule {
          options.arithmetic = mkProviderOpt 100;
        };
      };
    };
  };

  config = {
    # Three distinct contract types sharing the arithmetic interface, so
    # each can have its own default provider.
    contractTypes = lib.genAttrs [ "depth0" "depth1" "depth2" ] (_: {
      meta = {
        description = "Arithmetic contract for provider-nesting tests.";
        maintainers = [ ];
      };
      interface = arithmeticInterface;
    });

    # -- Consumers: same request (value = 5) across all three contract types --
    contracts.depth0.want.consumer.instance.request.value = 5;
    contracts.depth1.want.consumer.instance.request.value = 5;
    contracts.depth2.want.consumer.instance.request.value = 5;

    # -- Providers: feed requests, register at each depth --
    depth0 = config.contracts.depth0.requests;
    depth1.arithmetic = config.contracts.depth1.requests;
    depth2.inner.arithmetic = config.contracts.depth2.requests;

    # depth 0: option *is* the contract option; inferred `contract = [ ]`.
    contracts.depth0.providers.p.module = options.depth0;
    contracts.depth0.defaultProviderName = "p";

    # depth 1: contract option lives inside a wrapping submodule named
    # `arithmetic`, not matching the contract type name (`depth1`), so
    # `contract` must be set explicitly.
    contracts.depth1.providers.p = {
      module = options.depth1;
      contract = [ "arithmetic" ];
    };
    contracts.depth1.defaultProviderName = "p";

    # depth 2: contract option lives two submodules deep.
    contracts.depth2.providers.p = {
      module = options.depth2;
      contract = [
        "inner"
        "arithmetic"
      ];
    };
    contracts.depth2.defaultProviderName = "p";
  };
}

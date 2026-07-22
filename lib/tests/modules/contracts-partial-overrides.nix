# Regression test for the want-forwarding leakage in `mkProviderType`.
#
# When a provider type declares `providerOptions` and the deployer writes
# one such option at a contract instance, `nestedAttrsOf`'s leaf-level
# priority handling drops the `mkOptionDefault`-priority value carrying the
# consumer's `want` request data. `contracts.<name>.mkProviderType` re-applies
# those wants at `mkDefault` priority via `_requests` to keep them visible
# alongside the deployer-written provider option. This test exercises that
# path eval-only: a provider with `providerOptions.extra`, a consumer want
# overriding one request field while leaving another at its default, and a
# deployer write at the provider's `extra` leaf -- the result must reflect
# both the overridden and defaulted request fields.
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkOption types;

  wantForwardingInterface = {
    meta = {
      description = "Contract for want-forwarding regression tests.";
      maintainers = [ ];
    };
    interface = {
      request.a = mkOption {
        description = "First addend; consumer overrides this.";
        type = types.int;
        default = 1;
      };
      request.b = mkOption {
        description = "Second addend; consumer leaves at default.";
        type = types.int;
        default = 2;
      };
      result.value = mkOption {
        description = "Sum of request fields.";
        type = types.int;
      };
    };
  };

in
{
  imports = [ lib.contract.module ];

  options.meta = mkOption {
    type = types.attrs;
    default = { };
  };

  # Use `config.contracts.<name>.mkProviderType` (not the raw
  # `contractDefinitions` one) so `_requests` is pre-bound -- that pre-binding
  # is exactly the want-forwarding mechanism under test.
  # Mirror real providers (e.g. `testing.hardcoded-secret`) by setting the
  # provider's routed-requests tree as the option's `default`. That places the
  # want-derived values at `mkOptionDefault` priority -- exactly what
  # `nestedAttrsOf` leaf filtering drops when a deployer-written provider leaf
  # appears at the same instance, unless `_requests` re-applies them at `mkDefault`.
  options.services.myProvider.wantForwarding = mkOption {
    default = config.contracts.wantForwarding.providerRequests.myProvider;
    type = config.contracts.wantForwarding.mkProviderType {
      providerOptions.extra = mkOption {
        description = "Provider-specific leaf whose deployer write triggers the leakage path.";
        type = types.int;
      };
      fulfill = request: {
        value = request.a + request.b;
      };
    };
  };

  config = {
    contractDefinitions.wantForwarding = wantForwardingInterface;

    # Consumer overrides `a`, leaves `b` at its default of 2.
    contracts.wantForwarding.want.consumer.instance.request.a = 10;

    # Deployer write at the provider-specific leaf, normal priority. This is
    # the write that, pre-fix, causes the `want`s under the option's default to
    # be dropped from the same instance.
    services.myProvider.wantForwarding.consumer.instance.extra = 999;

    # Register the provider and select it as the default.
    contracts.wantForwarding.providers.myProvider.module = options.services.myProvider.wantForwarding;
    contracts.wantForwarding.defaultProvider = config.contracts.wantForwarding.providers.myProvider;
  };
}

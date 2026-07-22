# Tests that contract requests are type-checked: setting a request option to
# the wrong type (e.g. a string where an int is expected) must produce an
# evaluation error.
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkOption;
  inherit (config.contracts) arithmetic;
in
{
  imports = [ ./contracts-arithmetic-contract.nix ];

  options.services.increment.arithmetic = mkOption {
    default = arithmetic.providerRequests.increment;
    type = arithmetic.mkProviderType {
      fulfill =
        { value }:
        {
          value = value + 1;
        };
    };
  };

  config = {
    # Wrong type: "abc" is a string, but request.value expects an int.
    contracts.arithmetic.want.consumer.instance.request.value = "abc";

    # Provider
    contracts.arithmetic.providers.increment.module = options.services.increment.arithmetic;
    contracts.arithmetic.defaultProvider = arithmetic.providers.increment;
  };
}

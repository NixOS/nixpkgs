# Tests that contract requests are type-checked: setting a request option to
# the wrong type (e.g. a string where an int is expected) must produce an
# evaluation error.
{ lib, config, ... }:
let
  inherit (lib) mkOption;
  inherit (config.contractTypes.arithmetic) mkProviderType;
in
{
  imports = [ ./contracts-arithmetic-contract.nix ];

  options.services.increment.arithmetic = mkOption {
    default = config.contracts.arithmetic.requests;
    type = mkProviderType {
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
    contracts.arithmetic.providers.increment = config.services.increment.arithmetic;
    contracts.arithmetic.defaultProviderName = "increment";
  };
}

# Modular service provider for the arithmetic contract: returns request.value + 1.
# Shared across contract tests that need an increment provider as a modular service.
{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption;
  inherit (config.contractTypes.arithmetic) mkProviderType;
in
{
  _class = "service";
  options.arithmetic = mkOption {
    description = "Arithmetic contract instances fulfilled by this increment provider.";
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
    contracts.arithmetic.providers.increment = config.arithmetic;
    process.argv = [ "/run/current-system/sw/bin/true" ];
  };
}

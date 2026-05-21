# Modular service provider for the arithmetic contract: returns request.value + 1.
# Pure provider with no default-selection opinion -- consumers select the default themselves.
# Shared across contract tests that need an increment provider as a modular service.
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
  _class = "service";
  imports = [ ./arithmetic-contract.nix ];
  options.arithmetic = mkOption {
    description = "Arithmetic contract instances fulfilled by this increment provider.";
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
    contracts.arithmetic.providers.increment.module = options.arithmetic;
    process.argv = [ "/run/current-system/sw/bin/true" ];
  };
}

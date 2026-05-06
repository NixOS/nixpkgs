# Tests contracts where both the consumer and provider are modular services.
#
# - A consumer modular service declares a request via `contracts.arithmetic.want`
#   and reads results from `config.contracts.arithmetic.results`.
# - `nixos-contracts-bridge` automatically wires `contracts.<type>.want` → NixOS
#   `contracts.<type>.want`.
# - A provider modular service reads `config.contracts.arithmetic.requests` and
#   sets `contracts.arithmetic.providers.increment`.
# - `nixos-contracts-bridge` automatically collects providers into NixOS
#   `contracts.arithmetic.providers`.
{ lib, pkgs, ... }:
{
  name = "contracts-modular-services";

  containers.machine =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) mkOption;
      inherit (config.contractTypes.arithmetic) mkContract;

      # Consumer service module.
      # Uses `contracts.arithmetic.want` to register contract requests;
      # reads results from `config.contracts.arithmetic.results`.
      consumerModule =
        {
          lib,
          config,
          name,
          ...
        }:
        {
          _class = "service";
          options.consumer.operation = mkOption {
            default = { };
            type = mkContract { };
          };
          config = {
            consumer.operation.request.value = 5;
            contracts.arithmetic.want = {
              inherit (config.consumer) operation;
            };
            consumer.operation.result = config.contracts.arithmetic.results.operation;
            process.argv = [ "${pkgs.coreutils}/bin/true" ];
          };
        };

    in
    {
      imports = [
        # The arithmetic contract type: defined inline (not in `lib/contracts/`) to demonstrate
        # the downstream user pattern of declaring contracts in `config.contractTypes`.
        ./arithmetic-contract.nix
      ];

      # Consumer service: requests an arithmetic operation with `value = 5`.
      # `nixos-contracts-bridge` wires its `contracts.arithmetic.want` into NixOS
      # `contracts.arithmetic.want`.
      system.services.instance = {
        imports = [ consumerModule ];
      };

      # Provider service: fulfills arithmetic requests by incrementing the value.
      system.services.increment = {
        imports = [ ./arithmetic-increment-provider.nix ];
      };

      contracts.arithmetic.defaultProviderName = "increment";

      assertions = [
        {
          assertion = config.contracts.arithmetic.results.instance.operation.value == 6;
          # "instance" comes from the bridge auto-nesting under service name
          message = "arithmetic contract: result.value should equal request.value (5) + 1 = 6";
        }
      ];
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
  '';

  meta.maintainers = with lib.maintainers; [ kiara ];
}

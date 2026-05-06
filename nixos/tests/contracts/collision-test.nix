# Tests that the bridge's auto-namespacing prevents collisions in `contracts.*.want`.
#
# The bridge nests each service's want under its service tree path, so two
# instances of the same service module get separate namespaces automatically.
# Services just set `contracts.<type>.want.<option>` without any manual prefix.
{ lib, pkgs, ... }:
{
  name = "contracts-collision";

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

      # Two instances of this service get different namespaces automatically.
      # No manual prefix needed - the bridge nests under the service tree name.
      safeService =
        { config, ... }:
        {
          _class = "service";
          options.safe.op = mkOption {
            default = { };
            type = mkContract { };
          };
          config = {
            safe.op.request.value = 5;
            # Just set want.<option> - bridge adds the service name prefix
            contracts.arithmetic.want.op = config.safe.op;
            safe.op.result = config.contracts.arithmetic.results.op;
            process.argv = [ "/run/current-system/sw/bin/true" ];
          };
        };
    in
    {
      imports = [ ./arithmetic-contract.nix ];

      # Two instances of the same service - no collision due to auto-namespacing.
      system.services.alpha = {
        imports = [ safeService ];
      };
      system.services.beta = {
        imports = [ safeService ];
        safe.op.request.value = lib.mkForce 10;
      };

      system.services.increment = {
        imports = [ ./arithmetic-increment-provider.nix ];
      };

      contracts.arithmetic.defaultProviderName = "increment";

      assertions = [
        {
          # Bridge nests alpha's want under "alpha": results.alpha.op
          assertion = config.contracts.arithmetic.results.alpha.op.value == 6;
          message = "alpha (5 + 1): expected 6";
        }
        {
          # Bridge nests beta's want under "beta": results.beta.op
          assertion = config.contracts.arithmetic.results.beta.op.value == 11;
          message = "beta (10 + 1): expected 11";
        }
      ];
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
  '';

  meta.maintainers = with lib.maintainers; [ kiara ];
}

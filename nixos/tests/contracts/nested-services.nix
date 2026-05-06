# Tests contracts with nested modular services (sub-services).
#
# A top-level service ("outer") owns a sub-service ("inner"). Both register
# contract requests and read results from `config.contracts.*` at their own
# level. The bridge auto-nests `want` entries under the service tree path, and
# scoped `_upstreamContracts` lets each service read results via just its option name.
#
# Bridge-level want paths:
# - outer service "app":            want.app.operation
# - inner sub-service "app/deep":   want.app.deep.operation
{ lib, pkgs, ... }:
{
  name = "contracts-nested-services";

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

      # Inner sub-service: lives inside outer, requests value = 10.
      # Reads results via scoped `_upstreamContracts` - just `results.operation`.
      innerModule =
        { lib, config, ... }:
        {
          _class = "service";
          options.inner.operation = mkOption {
            default = { };
            type = mkContract { };
          };
          config = {
            inner.operation.request.value = 10;
            contracts.arithmetic.want = {
              inherit (config.inner) operation;
            };
            inner.operation.result = config.contracts.arithmetic.results.operation;
            process.argv = [ "${pkgs.coreutils}/bin/true" ];
          };
        };

      # Outer service: owns inner sub-services, also requests its own contract.
      outerModule =
        { lib, config, ... }:
        {
          _class = "service";
          options.outer.operation = mkOption {
            default = { };
            type = mkContract { };
          };
          config = {
            outer.operation.request.value = 5;
            contracts.arithmetic.want = {
              inherit (config.outer) operation;
            };
            outer.operation.result = config.contracts.arithmetic.results.operation;

            # Sub-service that also participates in contracts.
            services.deep = {
              imports = [ innerModule ];
            };

            process.argv = [ "${pkgs.coreutils}/bin/true" ];
          };
        };
    in
    {
      imports = [ ./arithmetic-contract.nix ];

      system.services.app = {
        imports = [ outerModule ];
      };

      system.services.increment = {
        imports = [ ./arithmetic-increment-provider.nix ];
      };

      contracts.arithmetic.defaultProviderName = "increment";

      assertions = [
        {
          # Bridge nests under "app": results.app.operation
          assertion = config.contracts.arithmetic.results.app.operation.value == 6;
          message = "outer service: result.value should be 5 + 1 = 6";
        }
        {
          # Bridge nests under "app.deep": results.app.deep.operation
          assertion = config.contracts.arithmetic.results.app.deep.operation.value == 11;
          message = "inner sub-service: result.value should be 10 + 1 = 11";
        }
      ];
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
  '';

  meta.maintainers = with lib.maintainers; [ kiara ];
}

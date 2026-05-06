# Tests contracts spanning separate NixOS nodes.
#
# Since contracts are a Nix evaluation-time mechanism, cross-node wiring is done
# by evaluating contracts once in a shared `let` block, then injecting the results
# into each node's configuration:
#
# - `consumerModule` and `incrementProviderModule` define each side's contract role.
# - Each node imports its respective module plus `./arithmetic-contract.nix` (the contract type).
# - `sharedContracts` composes both modules in a single `lib.evalModules` call.
# - The consumer node is configured with the result injected from the shared evaluation.
# - The test verifies the consumer's value matches what the provider serves at runtime.
{ pkgs, lib, ... }:
let
  # Consumer: declares a request for an arithmetic operation with value = 5.
  consumerModule =
    { ... }:
    {
      contracts.arithmetic.want.consumer.operation.request.value = 5;
    };

  # Provider: fulfills arithmetic requests by incrementing the value by 1.
  incrementProviderModule =
    {
      lib,
      config,
      options,
      ...
    }:
    let
      inherit (lib) mkOption;
      inherit (config.contractTypes.arithmetic) mkProviderType;
    in
    {
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
        contracts.arithmetic.providers.increment.module = options.services.increment.arithmetic;
        contracts.arithmetic.defaultProviderName = "increment";
      };
    };

  # Shared contracts evaluation: composes consumer and provider, producing results
  # that both node configs are derived from.
  # Both `consumerModule` and `incrementProviderModule` are reused from the node definitions
  # above, so the shared evaluation stays in sync with what each node imports.
  sharedContracts =
    (lib.evalModules {
      modules = [
        # Bundles the contracts module + arithmetic type for bare `lib.evalModules` contexts.
        ../../../lib/tests/modules/contracts-arithmetic-contract.nix
        # meta stub: `nixos/modules/contracts/default.nix` sets `meta.buildDocsInSandbox = false`
        # because `contracts` options are dynamically typed from `config.contractTypes`, making
        # the docs sandbox unable to evaluate them. `meta` itself is a NixOS-level option not
        # present in a bare `lib.evalModules` context, so we stub it out here.
        {
          options.meta = lib.mkOption {
            type = lib.types.attrs;
            default = { };
          };
        }
        consumerModule
        incrementProviderModule
      ];
    }).config;

  resultValue = sharedContracts.contracts.arithmetic.results.consumer.operation.value;
in
{
  name = "contracts-cross-node";

  containers = {
    # Provider node: imports its role module; `./arithmetic-contract.nix` makes
    # `contracts.arithmetic.*` options available without re-importing the contracts module
    # (already in the NixOS module list). The node has no consumer `want` entries, so
    # `contracts.arithmetic.requests` is empty — the bridge assertion stays dormant.
    provider =
      { pkgs, ... }:
      {
        imports = [
          ./arithmetic-contract.nix
          incrementProviderModule
        ];
        # Expose the computed result over HTTP so the consumer can verify it at runtime.
        # In a real use case this would be a proper service (e.g. a secrets manager).
        systemd.services.arithmetic-server = {
          wantedBy = [ "multi-user.target" ];
          script = ''
            mkdir -p /run/arithmetic
            echo -n ${lib.escapeShellArg (toString resultValue)} > /run/arithmetic/result
            exec ${pkgs.python3}/bin/python3 -m http.server 8080 --directory /run/arithmetic
          '';
        };
        networking.firewall.allowedTCPPorts = [ 8080 ];
      };

    # Consumer node: imports its role module; uses `resultValue` from the shared evaluation
    # since its own NixOS evaluation has no provider to fulfill its `want` entries.
    consumer =
      { ... }:
      {
        imports = [
          ./arithmetic-contract.nix
          consumerModule
        ];
        # In a real use case this would configure a service (e.g. a database URL or file path).
        environment.etc."arithmetic-expected".text = toString resultValue;
      };
  };

  testScript = ''
    provider.wait_for_unit("arithmetic-server.service")
    consumer.wait_for_unit("multi-user.target")

    # Contract result is baked into the consumer's config at evaluation time.
    expected = consumer.succeed("cat /etc/arithmetic-expected").strip()
    assert expected == "${toString resultValue}", f"contract result mismatch: got {expected!r}"

    # At runtime, the consumer retrieves the value served by the provider node.
    served = consumer.succeed("curl -sf http://provider:8080/result").strip()
    assert served == expected, f"provider served {served!r}, consumer expected {expected!r}"
  '';

  meta.maintainers = with lib.maintainers; [ kiara ];
}

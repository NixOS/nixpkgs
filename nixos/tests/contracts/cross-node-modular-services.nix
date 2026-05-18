# Tests contracts spanning separate NixOS nodes, with both consumer and provider
# implemented as modular services.
#
# Mirrors `cross-node.nix` but demonstrates that the cross-node pattern works
# equally well when each side is a modular service rather than a plain NixOS module.
#
# The shared eval uses `lib.services.evalServices` to resolve contracts across
# the two peer services without a parent system. Each node then bakes the
# eval-time `resultValue` into static config.
#
# Exercises the `defaultProviderName` code path in `lib/services/lib.nix::evalServices`.
# See `cross-node-modular-services-direct.nix` for the `defaultProvider` path.
{ lib, ... }:
let
  portable-lib = import ../../../lib/services/lib.nix { inherit lib; };

  arithmeticContract = ./arithmetic-contract.nix;

  consumerServiceModule =
    { lib, config, ... }:
    {
      _class = "service";
      imports = [ arithmeticContract ];
      options.consumer.operation = lib.mkOption {
        default.result = config.contracts.arithmetic.results.operation;
        type = config.contractDefinitions.arithmetic.mkContract { };
      };
      config = {
        consumer.operation.request.value = 5;
        contracts.arithmetic.want = { inherit (config.consumer) operation; };
        process.argv = [ "/run/current-system/sw/bin/true" ];
      };
    };

  providerNode = {
    imports = [ arithmeticContract ];
    system.services.increment.imports = [
      ./arithmetic-increment-provider.nix
      { contracts.arithmetic.defaultProviderName = "increment"; }
    ];
  };

  evaluated = portable-lib.evalServices {
    services = {
      consumer = consumerServiceModule;
      increment = providerNode.system.services.increment;
    };
  };

  resultValue = evaluated.contracts.arithmetic.results.consumer.operation.value;
in
{
  name = "contracts-cross-node-modular-services";

  nodes = {
    provider =
      { pkgs, ... }:
      {
        imports = [
          providerNode
          {
            systemd.services.arithmetic-server = {
              wantedBy = [ "multi-user.target" ];
              script = ''
                mkdir -p /run/arithmetic
                echo -n ${lib.escapeShellArg (toString resultValue)} > /run/arithmetic/result
                exec ${pkgs.python3}/bin/python3 -m http.server 8080 --directory /run/arithmetic
              '';
            };
            networking.firewall.allowedTCPPorts = [ 8080 ];
          }
        ];
      };

    consumer =
      { ... }:
      {
        imports = [ arithmeticContract ];
        system.services.instance.imports = [ consumerServiceModule ];
        environment.etc."arithmetic-expected".text = toString resultValue;
      };
  };

  testScript = ''
    provider.wait_for_unit("arithmetic-server.service")
    consumer.wait_for_unit("multi-user.target")

    expected = consumer.succeed("cat /etc/arithmetic-expected").strip()
    assert expected == "${toString resultValue}", f"contract result mismatch: got {expected!r}"

    served = consumer.succeed("curl -sf http://provider:8080/result").strip()
    assert served == expected, f"provider served {served!r}, consumer expected {expected!r}"
  '';

  meta.maintainers = with lib.maintainers; [ kiara ];
}

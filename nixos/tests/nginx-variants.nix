{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

builtins.listToAttrs (
  builtins.map
    (nginxName:
      {
        name = nginxName;
        value = makeTest {
          name = "nginx-variant-${nginxName}";

          nodes.machine = { pkgs, ... }: {
            services.nginx = {
              enable = true;
              virtualHosts.localhost.locations."/".return = "200 'foo'";
              package = pkgs."${nginxName}";
            };
          };

          testScript = ''
            machine.wait_for_unit("nginx")
            machine.wait_for_open_port(80)
            machine.succeed('test "$(curl -fvvv http://localhost/)" = foo')
          '';
        };
      }
    )
    [ "nginxStable" "nginxMainline" "nginxQuic" "nginxShibboleth" "openresty" "tengine" ]
)

{ pkgs, runTest, ... }:
builtins.listToAttrs (
  builtins.map
    (packageName: {
      name = packageName;
      value = runTest {
        name = "nginx-variant-${packageName}";

        nodes.machine =
          { pkgs, ... }:
          {
            services.nginx = {
              enable = true;
              virtualHosts.localhost.locations."/".return = "200 'foo'";
              package = pkgs.${packageName};
            };
          };

        testScript = ''
          machine.wait_for_unit("nginx")
          machine.wait_for_open_port(80)
          machine.succeed('test "$(curl -fvvv http://localhost/)" = foo')
        '';
      };
    })
    [
      "angie"
      "nginxStable"
      "nginxMainline"
      "nginxShibboleth"
      "openresty"
      "tengine"
    ]
)

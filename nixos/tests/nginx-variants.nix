{ pkgs, runTest, ... }:
builtins.listToAttrs (
  builtins.map
    (nginxPackage: {
      name = pkgs.lib.getName nginxPackage;
      value = runTest {
        name = "nginx-variant-${pkgs.lib.getName nginxPackage}";

        nodes.machine =
          { pkgs, ... }:
          {
            services.nginx = {
              enable = true;
              virtualHosts.localhost.locations."/".return = "200 'foo'";
              package = nginxPackage;
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
      pkgs.angie
      pkgs.angieQuic
      pkgs.nginxStable
      pkgs.nginxMainline
      pkgs.nginxQuic
      pkgs.nginxShibboleth
      pkgs.openresty
      pkgs.tengine
    ]
)

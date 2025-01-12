import ./make-test-python.nix {
  name = "nginx-more-headers";

  nodes = {
    webserver =
      { pkgs, ... }:
      {
        services.nginx = {
          enable = true;

          virtualHosts.test = {
            locations = {
              "/".return = "200 blub";
              "/some" = {
                return = "200 blub";
                extraConfig = ''
                  more_set_headers "Referrer-Policy: no-referrer";
                '';
              };
            };
            extraConfig = ''
              more_set_headers "X-Powered-By: nixos";
            '';
          };
        };
      };
  };

  testScript = ''
    webserver.wait_for_unit("nginx")
    webserver.wait_for_open_port(80)

    webserver.succeed("curl --fail --resolve test:80:127.0.0.1 --head --verbose http://test | grep -q \"X-Powered-By: nixos\"")
    webserver.fail("curl --fail --resolve test:80:127.0.0.1 --head --verbose http://test | grep -q \"Referrer-Policy: no-referrer\"")

    webserver.succeed("curl --fail --resolve test:80:127.0.0.1 --head --verbose http://test/some | grep -q \"X-Powered-By: nixos\"")
    webserver.succeed("curl --fail --resolve test:80:127.0.0.1 --head --verbose http://test/some | grep -q \"Referrer-Policy: no-referrer\"")
  '';
}

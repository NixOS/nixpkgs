import ./make-test-python.nix ({ pkgs, ... }: {
  name = "nginx-globalredirect";

  nodes = {
    webserver = { pkgs, lib, ... }: {
      services.nginx = {
        enable = true;
        virtualHosts.localhost = {
          globalRedirect = "other.example.com";
          # Add an exception
          locations."/noredirect".return = "200 'foo'";
        };
      };
    };
  };

  testScript = ''
    webserver.wait_for_unit("nginx")
    webserver.wait_for_open_port(80)

    webserver.succeed("curl --fail -si http://localhost/alf | grep '^Location:.*/alf'")
    webserver.fail("curl --fail -si http://localhost/noredirect | grep '^Location:'")
  '';
})

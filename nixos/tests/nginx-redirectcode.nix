import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "nginx-redirectcode";
    meta.maintainers = with lib.maintainers; [ misterio77 ];

    nodes = {
      webserver =
        { pkgs, lib, ... }:
        {
          services.nginx = {
            enable = true;
            virtualHosts.localhost = {
              globalRedirect = "example.com/foo";
              # With 308 (and 307), the method and body are to be kept when following it
              redirectCode = 308;
            };
          };
        };
    };

    testScript = ''
      webserver.wait_for_unit("nginx")
      webserver.wait_for_open_port(80)

      # Check the status code
      webserver.succeed("curl -si http://localhost | grep '^HTTP/[0-9.]\+ 308 Permanent Redirect'")
    '';
  }
)

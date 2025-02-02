import ./make-test-python.nix (
  { pkgs, ... }:
  let
    nginxSocketPath = "/var/run/nginx/test.sock";
  in
  {
    name = "nginx-unix-socket";

    nodes = {
      webserver =
        { pkgs, lib, ... }:
        {
          services.nginx = {
            enable = true;
            virtualHosts.localhost = {
              serverName = "localhost";
              listen = [ { addr = "unix:${nginxSocketPath}"; } ];
              locations."/test".return = "200 'foo'";
            };
          };
        };
    };

    testScript = ''
      webserver.wait_for_unit("nginx")
      webserver.wait_for_open_unix_socket("${nginxSocketPath}")

      webserver.succeed("curl --fail --silent --unix-socket '${nginxSocketPath}' http://localhost/test | grep '^foo$'")
    '';
  }
)

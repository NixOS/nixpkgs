{ ... }:
let
  defaultNginxSocketPath = "/var/run/nginx/default-test.sock";
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

          defaultListen = [ { addr = "unix:${defaultNginxSocketPath}"; } ];
          virtualHosts.defaultLocalhost = {
            serverName = "defaultLocalhost";
            locations."/default".return = "200 'bar'";
          };

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
    webserver.wait_for_open_unix_socket("${defaultNginxSocketPath}", timeout=1)
    webserver.wait_for_open_unix_socket("${nginxSocketPath}", timeout=1)

    webserver.succeed("curl --fail --silent --unix-socket '${defaultNginxSocketPath}' http://defaultLocalhost/default | grep '^bar$'")
    webserver.succeed("curl --fail --silent --unix-socket '${nginxSocketPath}' http://localhost/test | grep '^foo$'")
  '';
}

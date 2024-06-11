import ./make-test-python.nix (
  { pkgs, lib, ... }:

    let
      port = 3142;
      defaultPort = 8083;
    in
      {
        name = "calibre-web";
        meta.maintainers = with lib.maintainers; [ pborzenkov ];

        nodes = {
          customized = { pkgs, ... }: {
            services.calibre-web = {
              enable = true;
              listen.port = port;
              options = {
                calibreLibrary = "/tmp/books";
                reverseProxyAuth = {
                  enable = true;
                  header = "X-User";
                };
              };
            };
            environment.systemPackages = [ pkgs.calibre ];
          };
        };
        testScript = ''
          start_all()

          customized.succeed(
              "mkdir /tmp/books && calibredb --library-path /tmp/books add -e --title test-book"
          )
          customized.succeed("systemctl restart calibre-web")
          customized.wait_for_unit("calibre-web.service")
          customized.wait_for_open_port(${toString port})
          customized.succeed(
              "curl --fail -H X-User:admin 'http://localhost:${toString port}' | grep test-book"
          )
        '';
      }
)

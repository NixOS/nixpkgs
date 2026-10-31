{ lib, ... }:

let
  port = 3142;
  defaultPort = 8083;
  libraryPath = "/var/lib/test-books";
  koboToken = "nixostestkobotoken";
in
{
  name = "calibre-web";
  meta.maintainers = with lib.maintainers; [ pborzenkov ];

  nodes = {
    customized =
      { pkgs, ... }:
      {
        services.calibre-web = {
          enable = true;
          listen.port = port;
          options = {
            calibreLibrary = libraryPath;
            reverseProxyAuth = {
              enable = true;
              header = "X-User";
            };
          };
        };
        environment.systemPackages = [ pkgs.calibre ];
      };

    kobo =
      { pkgs, ... }:
      {
        services.calibre-web = {
          enable = true;
          options = {
            calibreLibrary = libraryPath;
            enableKoboSync = true;
          };
        };
        environment.systemPackages = [
          pkgs.calibre
          pkgs.sqlite
        ];
      };
  };
  testScript = ''
    start_all()

    for machine in (customized, kobo):
      machine.succeed(
          "mkdir -p ${libraryPath} && calibredb --library-path ${libraryPath} add -e --title test-book"
      )
      # The service fails until its library exists, and may hit its start
      # limit before then.
      machine.succeed("systemctl reset-failed calibre-web")
      machine.succeed("systemctl restart calibre-web")
      machine.wait_for_unit("calibre-web.service")

    customized.wait_for_open_port(${toString port})
    customized.succeed(
        "curl --fail -H X-User:admin 'http://localhost:${toString port}' | grep test-book"
    )

    with subtest("Kobo sync is off by default"):
      status = customized.succeed(
          "curl -s -o /dev/null -w '%{http_code}' 'http://localhost:${toString port}/kobo/${koboToken}/v1/library/sync'"
      )
      assert status == "404", f"expected 404, got {status}"

    with subtest("enableKoboSync serves the library to a Kobo"):
      kobo.wait_for_open_port(${toString defaultPort})
      kobo.succeed(
          "sqlite3 /var/lib/calibre-web/app.db "
          "\"insert into remote_auth_token (auth_token, user_id, verified, expiration, token_type) "
          "values ('${koboToken}', 1, 1, '2099-01-01 00:00:00', 1)\""
      )
      # A Kobo only gets books in a format it reads, such as EPUB.
      kobo.succeed(
          "echo hello > /tmp/kobo-book.txt"
          " && QT_QPA_PLATFORM=offscreen ebook-convert /tmp/kobo-book.txt /tmp/kobo-book.epub --title kobo-book"
          " && calibredb --library-path ${libraryPath} add /tmp/kobo-book.epub"
      )
      kobo.succeed(
          "curl --fail 'http://localhost:${toString defaultPort}/kobo/${koboToken}/v1/library/sync' | grep kobo-book"
      )
  '';
}

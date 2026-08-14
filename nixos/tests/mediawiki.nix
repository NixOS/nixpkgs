{ lib, runTest }:

let
  shared =
    { pkgs, ... }:
    {
      services.mediawiki.enable = true;
      services.mediawiki.httpd.virtualHost.hostName = "localhost";
      services.mediawiki.httpd.virtualHost.adminAddr = "root@example.com";
      services.mediawiki.passwordFile = pkgs.writeText "password" "correcthorsebatterystaple";
      services.mediawiki.extensions = {
        Matomo = pkgs.fetchzip {
          url = "https://github.com/DaSchTour/matomo-mediawiki-extension/archive/v4.0.1.tar.gz";
          sha256 = "0g5rd3zp0avwlmqagc59cg9bbkn3r7wx7p6yr80s644mj6dlvs1b";
        };
        ParserFunctions = null;
      };
    };

  makeTest =
    t:
    runTest {
      imports = [
        { containers.machine.imports = [ shared ]; }
        t
      ];
    };
in
{
  mysql = makeTest {
    name = "mediawiki-mysql";
    containers.machine = {
      services.mediawiki.database.type = "mysql";
    };
    testScript = ''
      start_all()

      machine.wait_for_unit("phpfpm-mediawiki.service")

      page = machine.succeed("curl -fL http://localhost/")
      assert "MediaWiki has been installed" in page
    '';
  };

  postgresql = makeTest {
    name = "mediawiki-postgres";
    containers.machine = {
      services.mediawiki.database.type = "postgres";
    };
    testScript = ''
      start_all()

      machine.wait_for_unit("phpfpm-mediawiki.service")

      page = machine.succeed("curl -fL http://localhost/")
      assert "MediaWiki has been installed" in page
    '';
  };

  sqlite = makeTest {
    name = "mediawiki-sqlite";
    containers.machine = {
      services.mediawiki.database.type = "sqlite";
    };
    testScript = ''
      start_all()

      machine.wait_for_unit("phpfpm-mediawiki.service")

      page = machine.succeed("curl -fL http://localhost/")
      assert "MediaWiki has been installed" in page
    '';
  };

  nohttpd = makeTest {
    name = "mediawiki-nohttpd";
    containers.machine = {
      services.mediawiki.webserver = "none";
    };
    testScript =
      { containers, ... }:
      ''
        start_all()
        machine.wait_for_unit("phpfpm-mediawiki.service")
        env = (
          "SCRIPT_NAME=/index.php",
          "SCRIPT_FILENAME=${containers.machine.services.mediawiki.finalPackage}/share/mediawiki/index.php",
          "REMOTE_ADDR=127.0.0.1",
          'QUERY_STRING=title=Main_Page',
          "REQUEST_METHOD=GET",
        );
        page = machine.succeed(f"{' '.join(env)} ${lib.getExe containers.machine.nixpkgs.pkgs.fcgi} -bind -connect ${containers.machine.services.phpfpm.pools.mediawiki.socket}")
        assert "MediaWiki has been installed" in page, f"no 'MediaWiki has been installed' in:\n{page}"
      '';
  };

  nginx = makeTest {
    name = "mediawiki-nginx";
    containers.machine = {
      services.mediawiki.webserver = "nginx";
    };
    testScript = ''
      start_all()

      machine.wait_for_unit("phpfpm-mediawiki.service")
      machine.wait_for_unit("nginx.service")

      page = machine.succeed("curl -fL http://localhost/")
      assert "MediaWiki has been installed" in page
    '';
  };
}

{ lib, ... }:
{
  name = "dependency-track";
  meta.maintainers = with lib.maintainers; [
    e1mo
    xanderio
  ];

  nodes.server =
    { pkgs, ... }:
    {
      virtualisation = {
        cores = 2;
        memorySize = 1536;
      };

      environment.systemPackages = [ pkgs.curl ];

      services.dependency-track = {
        enable = true;

        extraArgs = [ "-Xmx768m" ];

        port = 8081;
        nginx.domain = "localhost";
      };
    };

  testScript =
    { nodes, ... }:
    # python
    ''
      import json

      server.wait_for_unit("dependency-track.service")
      server.wait_for_open_port(${toString nodes.server.services.dependency-track.port})

      with subtest("version api returns correct version"):
        version = json.loads(server.succeed("curl -sf http://localhost/api/version"))
        assert version["version"] == "${nodes.server.services.dependency-track.package.version}"

      with subtest("nginx serves frontend"):
        server.succeed("curl -sf http://localhost/ | grep '<title>Dependency-Track</title>'")
        config = json.loads(server.succeed("curl -sf http://localhost/static/config.json"))
        assert config["FEATURE_FLAGS"]["GLOBAL_VULNERABILITY_AUDIT"]
        assert config["OIDC_SCOPE"] == "openid email profile"

      with subtest("v4 migrator reaches the local database"):
        server.succeed("sudo -u postgres createdb -O dependency-track migration-target")
        server.succeed(
          "systemd-run --wait --pipe -p DynamicUser=yes -p User=dependency-track"
          " ${lib.getExe' nodes.server.services.dependency-track.package "dependency-track-v4-migrator"} bootstrap --target-url"
          " 'jdbc:postgresql:migration-target?socketFactory=org.newsclub.net.unix.AFUNIXSocketFactory$FactoryArg&socketFactoryArg=/run/postgresql/.s.PGSQL.5432'"
        )

      with subtest("refuses to start on a v4 database"):
        server.systemctl("stop dependency-track.service")
        server.succeed("sudo -u postgres psql -d dependency-track -c 'CREATE TABLE \"SCHEMAVERSION\" ()'")
        server.fail("systemctl restart dependency-track.service")
        server.wait_until_succeeds("journalctl -u dependency-track.service | grep 'holds Dependency-Track v4 data'")
    '';
}

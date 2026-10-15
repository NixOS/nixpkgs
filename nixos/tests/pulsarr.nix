{ lib, ... }:
{
  name = "pulsarr";
  meta.maintainers = [ lib.maintainers.jblik ];

  nodes = {
    defaults = { pkgs, ... }: {
      services.pulsarr.enable = true;
      environment.systemPackages = [ pkgs.sqlite ];
    };

    configured = {
      services.pulsarr = {
        enable = true;
        dataDir = "/var/lib/pulsarr-custom";
        user = "media";
        group = "media";
        openFirewall = true;
        settings = {
          listenPort = 4004;
          port = 443;
          basePath = "/unused";
          cookieSecured = true;
        };
        environmentFiles = [ "/etc/pulsarr-environment" ];
      };
      users.users.media = {
        isSystemUser = true;
        group = "media";
      };
      users.groups.media = { };
      environment.etc."pulsarr-environment".text = "basePath=/watchlist\n";
    };
  };

  testScript = ''
    import json
    import shlex

    start_all()

    with subtest("default installation migrates the database and serves the UI"):
      defaults.wait_for_unit("pulsarr.service")
      defaults.wait_for_open_port(3003)
      health = json.loads(defaults.succeed("curl --fail http://localhost:3003/health"))
      assert health["status"] == "healthy"
      assert health["checks"]["database"] == "ok"
      defaults.succeed("curl --fail --location -H 'Accept: text/html' http://localhost:3003/ | grep '<html'")
      defaults.succeed("test -s /var/lib/pulsarr/db/pulsarr.db")

    with subtest("restarting preserves application data and reruns migrations safely"):
      defaults.succeed("systemctl stop pulsarr.service")
      defaults.succeed("echo 'basePath=/restarted' >> /var/lib/pulsarr/.env")
      defaults.succeed("sqlite3 /var/lib/pulsarr/db/pulsarr.db " + shlex.quote("CREATE TABLE nixos_test (value TEXT); INSERT INTO nixos_test VALUES ('persistent');"))
      defaults.succeed("systemctl start pulsarr.service")
      defaults.wait_for_open_port(3003)
      defaults.succeed("curl --fail http://localhost:3003/restarted/health")
      defaults.succeed("grep -q '^basePath=/restarted$' /var/lib/pulsarr/.env")
      assert defaults.succeed("sqlite3 /var/lib/pulsarr/db/pulsarr.db 'SELECT value FROM nixos_test'").strip() == "persistent"

    with subtest("upstream settings, runtime environment files, and custom ownership work"):
      configured.wait_for_unit("pulsarr.service")
      configured.wait_for_open_port(4004)
      configured.succeed("curl --fail --location -H 'Accept: text/html' http://localhost:4004/watchlist/ | grep '<html'")
      assert configured.succeed("stat -c '%U:%G' /var/lib/pulsarr-custom/db/pulsarr.db").strip() == "media:media"
      defaults.succeed("curl --fail http://configured:4004/watchlist/health")
  '';
}

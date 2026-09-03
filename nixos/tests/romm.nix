{ lib, ... }:

{
  name = "romm";
  meta.maintainers = with lib.maintainers; [ denzonl ];

  nodes.machine = {
    services.romm = {
      enable = true;
      nginx.virtualHost = "localhost";
    };

    virtualisation.memorySize = 2048;
    virtualisation.cores = 2;
  };

  interactive.nodes.machine = {
    virtualisation.forwardPorts = [
      {
        from = "host";
        host.port = 8080;
        guest.port = 80;
      }
    ];
    networking.firewall.allowedTCPPorts = [ 80 ];
  };

  testScript = ''
    machine.start()

    with subtest("services come up"):
        machine.wait_for_unit("postgresql.target")
        machine.wait_for_unit("redis-romm.service")
        machine.wait_for_unit("romm.service")
        machine.wait_for_open_port(8080)
        machine.wait_for_unit("romm-worker.service")
        machine.wait_for_unit("romm-scheduler.service")
        machine.wait_for_unit("romm-watcher.service")
        machine.wait_for_unit("nginx.service")

    with subtest("backend API answers"):
        machine.succeed("curl -sf http://127.0.0.1:8080/api/heartbeat")

    with subtest("nginx serves the frontend and proxies the API"):
        machine.succeed("curl -sf http://localhost/ | grep -iq romm")
        machine.succeed("curl -sf http://localhost/api/heartbeat")

    with subtest("platform icons are served"):
        machine.succeed(
            "curl -sf -o /dev/null -w '%{content_type}' http://localhost/assets/platforms/default.ico | grep -qv text/html"
        )

    with subtest("uploads larger than nginx's 10M default are not rejected"):
        machine.succeed("dd if=/dev/zero of=/tmp/upload bs=1M count=15")
        code = machine.succeed(
            "curl -s -o /dev/null -w '%{http_code}' -X POST --data-binary @/tmp/upload http://localhost/api/roms"
        ).strip()
        assert code != "413", code

    with subtest("the internal /decode endpoint exists"):
        # internal: 404 externally; the SPA fallback would give 200
        code = machine.succeed(
            "curl -s -o /dev/null -w '%{http_code}' 'http://localhost/decode?value=aGk='"
        ).strip()
        assert code == "404", code

    with subtest("the watcher reacts to library changes"):
        machine.succeed("install -d -o romm -g romm /var/lib/romm/library/roms/gba")
        machine.succeed("touch '/var/lib/romm/library/roms/gba/test.gba'")
        machine.wait_until_succeeds(
            "journalctl -u romm-watcher | grep -iq rescan", timeout=60
        )

    with subtest("auth secret is generated and persisted"):
        machine.succeed("test -s /var/lib/romm/.auth-secret.env")
  '';
}

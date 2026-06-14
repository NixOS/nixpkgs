{ lib, ... }:

{
  name = "securo";

  meta = with lib.maintainers; {
    maintainers = [ pjrm ];
  };

  nodes.machine = { ... }: {
    imports = [ ../../modules/services/web-apps/securo.nix ];

    services.securo.enable = true;
  };

  testScript = ''
    import json

    machine.start()

    machine.wait_for_unit("postgresql.service")
    machine.succeed("sudo -u postgres psql -c 'SELECT 1'")

    machine.wait_for_unit("redis-securo.service")
    machine.succeed("redis-cli ping")

    machine.wait_for_unit("securo-migrate.service")

    machine.wait_for_unit("securo-server.service")
    machine.wait_for_unit("securo-celery-worker.service")
    machine.wait_for_unit("securo-celery-beat.service")

    machine.wait_for_open_port(8000)

    health = machine.succeed("curl -s http://127.0.0.1:8000/api/health")
    info = json.loads(health)
    assert info["status"] == "healthy", f"Unexpected health response: {info}"

    tables = machine.succeed(
        "sudo -u postgres psql -d securo -t -c "
        '"SELECT table_name FROM information_schema.tables '
        'WHERE table_schema = current_schema"'
    )
    assert "alembic_version" in tables, (
        "No alembic_version table found. Tables: " + tables
    )

    machine.succeed("pgrep -f 'celery' > /dev/null")
  '';
}

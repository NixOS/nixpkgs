{ lib, ... }:

{
  name = "securo";

  containers.securo = {
    services.securo = {
      enable = true;
      frontend = {
        url = "http://localhost";
        nginx.enable = true;
      };
    };
  };

  testScript = ''
    import json

    securo.wait_for_unit("postgresql.target")
    securo.wait_for_unit("redis-securo.service")
    securo.wait_for_unit("securo-migrate.service")
    securo.wait_for_unit("securo-server.service")
    securo.wait_for_unit("securo-celery-worker.service")
    securo.wait_for_unit("securo-celery-beat.service")
    securo.wait_for_open_port(8000)

    with subtest("secret key is generated once and kept private"):
        securo.succeed("test -s /var/lib/securo/secret_key")
        perms = securo.succeed("stat -c %a /var/lib/securo/secret_key").strip()
        assert perms == "600", f"Expected mode 600 on secret_key, got {perms}"

    with subtest("alembic migrations applied"):
        tables = securo.succeed(
            "runuser -u postgres -- psql -d securo -tAc "
            "\"SELECT table_name FROM information_schema.tables "
            "WHERE table_schema = current_schema\""
        )
        assert "alembic_version" in tables, f"No alembic_version table. Tables: {tables}"

    with subtest("pgvector extension is available"):
        securo.succeed(
            "runuser -u postgres -- psql -d securo -tAc "
            "\"SELECT 1 FROM pg_extension WHERE extname = 'vector'\" | grep -q 1"
        )

    with subtest("backend reports healthy"):
        health = securo.succeed("curl -sf http://127.0.0.1:8000/api/health")
        assert json.loads(health)["status"] == "healthy", f"Unexpected health response: {health}"

    with subtest("nginx serves the frontend and proxies the api"):
        securo.wait_for_unit("nginx.service")
        securo.wait_for_open_port(80)
        securo.succeed("curl -sf http://localhost/ | grep -q '<div id=\"root\">'")
        proxied = securo.succeed("curl -sf http://localhost/api/health")
        assert json.loads(proxied)["status"] == "healthy", f"Unexpected proxied response: {proxied}"
  '';

  meta.maintainers = with lib.maintainers; [ pjrm ];
}

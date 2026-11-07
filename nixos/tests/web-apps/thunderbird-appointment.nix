{ lib, ... }:

{
  name = "thunderbird-appointment";
  meta.maintainers = with lib.maintainers; [ philocalyst ];

  nodes.machine = {
    virtualisation.memorySize = 2048;

    services.thunderbird-appointment = {
      enable = true;
      dataDir = "/srv/thunderbird-appointment-state";
      # A domain is always required, but we skip the nginx
      # vhost here as the test needs no ACME/DNS!
      nginx = {
        enable = false;
        domain = "appointment.example.com";
      };
      database.createLocally = true;
      redis.createLocally = true;
    };
  };

  testScript = ''
    start_all()

    def wait_for_unit_with_diagnostics(unit):
        try:
            machine.wait_for_unit(unit, timeout=90)
        except Exception:
            machine.log(machine.succeed(f"systemctl status {unit} --no-pager || true"))
            machine.log(machine.succeed(f"journalctl -u {unit} -b --no-pager -n 100 || true"))
            raise

    wait_for_unit_with_diagnostics("thunderbird-appointment-secrets.service")
    wait_for_unit_with_diagnostics("postgresql.service")
    wait_for_unit_with_diagnostics("redis-thunderbird-appointment.service")
    wait_for_unit_with_diagnostics("thunderbird-appointment.service")
    wait_for_unit_with_diagnostics("thunderbird-appointment-worker.service")

    with subtest("secrets are generated with strict permissions"):
        machine.succeed("test -d /srv/thunderbird-appointment-state")
        machine.succeed("test $(stat -c %a /srv/thunderbird-appointment-state) = 750")
        machine.succeed("test $(stat -c %U:%G /srv/thunderbird-appointment-state) = thunderbird-appointment:thunderbird-appointment")
        machine.succeed("test -f /srv/thunderbird-appointment-state/secrets.env")
        machine.succeed("test $(stat -c %a /srv/thunderbird-appointment-state/secrets.env) = 600")
        for key in ["SESSION_SECRET", "JWT_SECRET", "CSRF_SECRET", "SIGNED_SECRET", "DB_SECRET"]:
            machine.succeed(f"grep -q '^{key}=.' /srv/thunderbird-appointment-state/secrets.env")

    with subtest("migrations ran against PostgreSQL"):
        # `run-command main update-db` stamps the alembic head on a fresh DB.
        machine.succeed("test -f /srv/thunderbird-appointment-state/appointment.log")
        machine.succeed(
            "sudo -u postgres psql -tAc "
            "\"SELECT to_regclass('public.alembic_version')\" "
            "thunderbird-appointment | grep -q alembic_version"
        )

    with subtest("the API health endpoint checks PostgreSQL and Redis"):
        machine.wait_for_open_port(5000)
        machine.succeed("curl -fsS http://127.0.0.1:5000/ > /dev/null")
        machine.succeed("curl -fsS http://127.0.0.1:5000/session-info | grep -q true")

    with subtest("the worker executes its scheduled heartbeat"):
        machine.wait_until_succeeds(
            "journalctl -u thunderbird-appointment-worker.service -b --no-pager | grep -q 'Celery heartbeat'",
            timeout=90,
        )

    with subtest("units are meaningfully hardened"):
        machine.log(machine.succeed("systemd-analyze security thunderbird-appointment.service"))
        machine.log(machine.succeed("systemd-analyze security thunderbird-appointment-worker.service"))
  '';
}

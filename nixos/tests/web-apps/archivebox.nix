{ lib, ... }:

{
  name = "archivebox";

  nodes.machine = {
    imports = [ ../../modules/services/web-apps/archivebox.nix ];

    services.archivebox = {
      enable = true;
      settings = {
        # Keep this test self-contained: it exercises the real local service,
        # but does not attempt to fetch or archive anything from the network.
        CHECK_SSL_VALIDITY = false;
        SERVER_SECURITY_MODE = "safe-onedomain-nojsreplay";
      };
    };
  };

  testScript = ''
    from datetime import timedelta

    start_all()

    def wait_for_archivebox():
        try:
            machine.wait_for_unit("archivebox.service", timeout=timedelta(seconds=90))
            machine.wait_for_open_port(8000, timeout=timedelta(seconds=90))
        except Exception:
            machine.succeed("systemctl status archivebox.service --no-pager || true")
            machine.succeed("journalctl -u archivebox.service -n 200 --no-pager || true")
            machine.succeed("journalctl -k -n 100 --no-pager || true")
            raise

    wait_for_archivebox()

    # ExecStartPre runs ArchiveBox's real `init --quick`, which must create
    # the SQLite index and persistent collection directories as the service
    # account before the HTTP server can start.
    machine.succeed("test -s /var/lib/archivebox/index.sqlite3")
    machine.succeed("test -d /var/lib/archivebox/archive")
    machine.succeed("test \"$(stat -c %U:%G /var/lib/archivebox)\" = archivebox:archivebox")
    machine.succeed("test \"$(stat -c %U:%G /var/lib/archivebox/index.sqlite3)\" = archivebox:archivebox")
    machine.succeed("curl --fail --silent --show-error http://127.0.0.1:8000/health/ >/dev/null")

    # A restart re-runs initialization against the existing collection and
    # serves the same persistent database without prompting or losing state.
    machine.succeed("systemctl restart archivebox.service")
    wait_for_archivebox()
    machine.succeed("test -s /var/lib/archivebox/index.sqlite3")
    machine.succeed("curl --fail --silent --show-error http://127.0.0.1:8000/health/ >/dev/null")
  '';

  meta.maintainers = with lib.maintainers; [ philocalyst ];
}

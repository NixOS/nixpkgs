# Regression test for an nspawn-only systemd re-exec failure that broke D-Bus.
#
# Demonstrates `systemctl show` keeps working on `daemon-reexec`.
#
# Trigger: `systemctl daemon-reexec` issues a D-Bus `Manager.Reexecute`, like
# `switch-to-configuration-ng` on a systemd package change.
#
# Root cause: inside nspawn test containers PID 1 re-send `READY=1` on the
# `NOTIFY_SOCKET` on re-exec. The test driver stopped draining that socket
# after boot, so until drained its receive buffer filled and `systemctl` hung /
# errored `Failed to connect to bus: Transport endpoint is not connected`.
{ ... }:
{
  name = "nspawn-daemon-reexec-dbus";

  # `containers.<name>` => systemd-nspawn machine (vs `nodes.<name>` => QEMU).
  # An empty container boots full systemd + D-Bus, which is all we need.
  containers.machine = { };

  testScript = # python
    ''
      import re

      BUS_BROKEN = re.compile(
          r"Transport endpoint is not connected|Failed to connect to bus"
      )

      # Without the fix the notify socket's receive buffer fills after 10
      # undrained `READY=1` resends, so PID 1 blocks then.
      REEXECS = 10


      def bus_broken():
          """Whether the in-container D-Bus is unusable. A broken bus prints a
          transport error or hangs until `timeout` kills it (status 124); both
          count as broken."""
          status, out = machine.execute(
              "timeout 10 systemctl show -p ActiveState --value "
              "multi-user.target 2>&1",
              check_return=False,
              timeout=20,
          )
          return status != 0 or bool(BUS_BROKEN.search(out)), status, out


      machine.start()
      machine.wait_for_unit("multi-user.target", timeout=120)

      # Pre-reexec sanity: the bus works and shows no break.
      broken, status, out = bus_broken()
      assert not broken, (
          f"bus already broken before any reexec: status={status} out={out!r}"
      )
      machine.log(f"pre-reexec sanity OK: {out.strip()!r}")

      broke_at = None
      for i in range(1, REEXECS + 1):
          # The same D-Bus Manager.Reexecute that switch-to-configuration issues
          # on a systemd change.
          machine.execute(
              "timeout 30 systemctl daemon-reexec",
              check_return=False,
              timeout=45,
          )
          broken, status, out = bus_broken()
          machine.log(f"[reexec {i}] status={status} out={out.strip()!r}")
          if broken:
              broke_at = i
              break

      assert broke_at is None, (
          f"nspawn D-Bus broke after daemon-reexec #{broke_at} of {REEXECS} "
          "(systemctl hung or returned a bus transport error). The re-exec'd "
          "PID 1 never finished re-initialising -- the test driver stopped "
          "draining the notify socket, so PID 1's READY=1 resend blocked. "
          "Never observed on QEMU."
      )
    '';
}

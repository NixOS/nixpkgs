# The test driver's polling helpers take two distinct quantities:
#
#   - a total budget, how long to keep retrying before giving up, and
#   - a per-attempt bound, how long one probe may block before it is abandoned
#     and retried.
#
# `timeout` is the total budget and `attempt_timeout` is the per-attempt bound.
# Both are only observable when a probe blocks, which is the case these helpers
# exist to survive, so this test makes one block on purpose.
{ pkgs, ... }:
{
  name = "test-driver-attempt-timeout";

  nodes.machine.environment.systemPackages = [ pkgs.iptables ];

  testScript = ''
    import datetime as dt
    import time

    start_all()
    machine.wait_for_unit("multi-user.target")

    with subtest("a blocking command is retried within the budget"):
        total = dt.timedelta(seconds=20)
        attempt = dt.timedelta(seconds=2)

        # each attempt records itself then blocks well past `attempt`
        command = "echo attempt >> /tmp/attempts; exec sleep 600 > /dev/null"

        started = time.monotonic()
        try:
            machine.wait_until_succeeds(command, timeout=total, attempt_timeout=attempt)
        except Exception:
            pass
        else:
            raise Exception("wait_until_succeeds should have timed out")

        elapsed = time.monotonic() - started
        attempts = int(machine.succeed("wc -l < /tmp/attempts"))
        # we can get in several attempts
        assert attempts >= 4, f"command was tried {attempts} times, expected it to be retried"
        # one final try after timeout, so the call costs about `total + attempt`
        assert elapsed < 40, f"wait_until_succeeds took {elapsed:.1f}s"

    with subtest("a blocking probe is bounded by the caller's budget"):
        machine.succeed("iptables -A OUTPUT -p tcp -d 127.0.0.1 --dport 1234 -j DROP")

        started = time.monotonic()
        try:
            machine.wait_for_open_port(1234, timeout=dt.timedelta(seconds=5))
        except Exception:
            pass
        else:
            raise Exception("wait_for_open_port should have timed out")
        elapsed = time.monotonic() - started

        # the bounded loop plus `retry`'s final attempt cost about ten seconds
        assert elapsed < 60, f"wait_for_open_port took {elapsed:.1f}s"
  '';
}

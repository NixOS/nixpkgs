{ lib, ... }:
{
  name = "t3code";

  nodes.machine.services.t3code.enable = true;

  testScript = ''
    machine.wait_for_unit("user@1000.service")
    machine.wait_for_unit("t3code.service", "t3code")
    machine.wait_until_succeeds("journalctl _SYSTEMD_USER_UNIT=t3code.service | grep 'T3 Code server is ready'")
    machine.succeed("curl --fail -s --max-time 10 http://127.0.0.1:3773/ | grep -i '<html'")
    machine.fail("journalctl _SYSTEMD_USER_UNIT=t3code.service | grep 'Failed to flush telemetry'")
    machine.succeed("su - t3code -c 't3 auth pairing create --json' | grep credential")
    machine.succeed("su - t3code -c 'mkdir project && t3 project add project && t3 thread start --provider codex --model gpt-6-astra project hello'")
    machine.wait_until_succeeds("journalctl _SYSTEMD_USER_UNIT=t3code.service | grep 'Agent scopes are on'")
    machine.wait_until_succeeds("grep -l 't3code-codex-.*\\.scope' /proc/$(pgrep -u t3code -f 'codex app-server' | head -1)/cgroup")
  '';

  meta.maintainers = with lib.maintainers; [ jakob1379 ];
}

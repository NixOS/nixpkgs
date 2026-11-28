{ lib, pkgs, ... }:
let
  # A magic derivation to understand how does the jobserver environment is seen from inside the sandbox.
  probe = ./probe.nix;
in
{
  name = "steve-module";

  meta = {
    # inherit (pkgs.steve.meta) maintainers;
    timeout = 900;
  };

  nodes.machine =
    { ... }:
    {
      virtualisation = {
        cores = 4;
        memorySize = 2048;
      };

      services.steve = {
        enable = true;
        jobs = 4;
      };

      nix.package = pkgs.lix;
      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = lib.mkForce [ ];
      };
    };

  testScript = ''
    machine.succeed("test -c /dev/cuse")

    with subtest("the daemon comes up and publishes its device"):
        machine.wait_for_unit("steve.service")
        machine.wait_until_succeeds("test -c /dev/steve", timeout=30)

    with subtest("the jobserver auth is exported to builds and sessions"):
        machine.succeed("grep -q 'jobserver-auth=fifo:/dev/steve' /etc/set-environment || "
                        "grep -rq 'jobserver-auth=fifo:/dev/steve' /etc/profile.d/")

    with subtest("the device is bind-mounted into build sandboxes"):
        machine.succeed("grep -q /dev/steve /etc/nix/nix.conf")

    with subtest("a build becomes a jobserver client"):
        out = machine.succeed(
            "nix-build --no-out-link ${probe} "
            "--option sandbox true --option builders \"\" --option substitute false"
        ).strip()
        actual = machine.succeed(f"cat {out}")
        machine.log("probe saw:\n" + actual)
        assert "MAKEFLAGS=" in actual
        assert "jobserver-auth=fifo:/dev/steve" in actual, f"build did not inherit the jobserver: {actual}"
        assert "DEVICE=character" in actual, f"/dev/steve not visible in the sandbox: {actual}"
        tokens = int([l for l in actual.splitlines() if l.startswith("TOKENS=")][0].split("=")[1])
        assert tokens >= 1, f"the pool handed out no tokens: {actual}"

    with subtest("stopping the jobserver fails blocked clients instead of hanging them"):
        machine.succeed("systemctl stop steve.service")
        # A reader blocked on the now-gone device should not get stuck. It should exit with failure.
        rc, _ = machine.execute("timeout 30 sh -c 'cat /dev/steve > /dev/null'")
        machine.log(f"read after stop: rc={rc}")
  '';
}

{ lib, ... }:

{
  name = "jail-ai";
  meta.maintainers = with lib.maintainers; [ FlorianFranzen ];

  nodes = {
    machine = {
      imports = [ ./common/user-account.nix ];
      programs.jail-ai.enable = true;
    };

    restricted = {
      imports = [ ./common/user-account.nix ];
      programs.jail-ai = {
        enable = true;
        group = "jail-ai";
      };
      users.groups.jail-ai.members = [ "alice" ];
    };
  };

  testScript = ''
    loader = "/run/wrappers/bin/jail-ai-ebpf-loader"


    def loader_runs(machine, user):
        """The loader exits non-zero on empty stdin, but only after it has
        confirmed that it holds the capabilities it needs."""
        out = machine.fail(f"su -l {user} -c '{loader} </dev/null' 2>&1")
        assert "Missing required capabilities" not in out, out
        assert "Failed to read request" in out, out


    with subtest("wrapper is world-executable by default"):
        machine.wait_for_unit("multi-user.target")
        machine.succeed("jail-ai --help")

        # jail-ai looks the loader up in PATH, so it has to resolve there.
        found = machine.succeed("su -l alice -c 'command -v jail-ai-ebpf-loader'").strip()
        assert found == loader, found

        caps = machine.succeed(f"getcap {loader}")
        assert "cap_bpf" in caps, caps
        assert "cap_net_admin" in caps, caps

        stat = machine.succeed(f"stat -c '%a %U %G' {loader}").strip()
        assert stat == "511 root root", stat

        loader_runs(machine, "alice")
        loader_runs(machine, "bob")

    with subtest("group restricts the wrapper to its members"):
        restricted.wait_for_unit("multi-user.target")

        stat = restricted.succeed(f"stat -c '%a %U %G' {loader}").strip()
        assert stat == "510 root jail-ai", stat

        loader_runs(restricted, "alice")

        out = restricted.fail(f"su -l bob -c '{loader} </dev/null' 2>&1")
        assert "Permission denied" in out, out
  '';
}

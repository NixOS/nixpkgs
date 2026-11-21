{ pkgs, lib, ... }:
{
  name = "containers-unified-hierarchy";
  meta = {
    maintainers = with lib.maintainers; [ farnoy ];
  };

  nodes.machine =
    { ... }:
    {
      containers = {
        test-container = {
          autoStart = true;
          config = {
            nix.enable = false; # disabled by default on the test's host. See all-tests.nix / tag(no-nix-by-default)
          };
        };
        # nspawn forks journal-remote for this one before it sets up the cgroups.
        forward-journal = {
          autoStart = true;
          extraFlags = [ "--forward-journal=/var/log/containers/forward-journal/" ];
          config = {
            nix.enable = false;
          };
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("default.target")

    machine.succeed("echo 'stat -fc %T /sys/fs/cgroup/ | grep cgroup2fs' | nixos-container root-login test-container")

    # Both containers get controllers delegated (e.g. pids, which podman needs),
    # and nothing stays in the unit's top cgroup.
    for name in ["test-container", "forward-journal"]:
        machine.wait_for_unit(f"container@{name}.service")
        cg = f"/sys/fs/cgroup/machine.slice/container@{name}.service"
        machine.succeed(f"grep -qw pids {cg}/payload/cgroup.controllers")
        machine.succeed(f"test -z \"$(cat {cg}/cgroup.procs)\"")
  '';
}

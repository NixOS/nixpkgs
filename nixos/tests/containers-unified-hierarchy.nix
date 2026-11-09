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
      };
    };

  testScript = ''
    machine.wait_for_unit("default.target")

    machine.succeed("echo 'stat -fc %T /sys/fs/cgroup/ | grep cgroup2fs' | nixos-container root-login test-container")
  '';
}

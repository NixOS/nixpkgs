import ./make-test-python.nix (
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
            config = { };
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("default.target")

      machine.succeed("echo 'stat -fc %T /sys/fs/cgroup/ | grep cgroup2fs' | nixos-container root-login test-container")
    '';
  }
)

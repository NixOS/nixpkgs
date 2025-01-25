import ./make-test-python.nix (
  { lib, pkgs, ... }:

  {
    name = "buildkite-agent";
    meta.maintainers = with lib.maintainers; [ flokli ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.buildkite-agents = {
          one = {
            privateSshKeyPath = (import ./ssh-keys.nix pkgs).snakeOilPrivateKey;
            tokenPath = (pkgs.writeText "my-token" "5678");
          };
          two = {
            tokenPath = (pkgs.writeText "my-token" "1234");
          };
        };
      };

    testScript = ''
      start_all()
      # we can't wait on the unit to start up, as we obviously can't connect to buildkite,
      # but we can look whether files are set up correctly

      machine.wait_for_file("/var/lib/buildkite-agent-one/buildkite-agent.cfg")
      machine.wait_for_file("/var/lib/buildkite-agent-one/.ssh/id_rsa")

      machine.wait_for_file("/var/lib/buildkite-agent-two/buildkite-agent.cfg")
    '';
  }
)

import ./make-test-python.nix ({ pkgs, ... }:

let
  envFile = pkgs.writeText "environment" "FOO=bar";
in {
  name = "buildkite-agent";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ flokli ];
  };

  nodes.machine = { pkgs, ... }: {
    services.buildkite-agents = {
      one = {
        privateSshKeyPath = (import ./ssh-keys.nix pkgs).snakeOilPrivateKey;
        tokenPath = (pkgs.writeText "my-token" "5678");
      };
      two = {
        tokenPath = (pkgs.writeText "my-token" "1234");
      };
      concurrent = {
        tokenPath = (pkgs.writeText "my-token" "9123");
        extraServiceConfig.EnvironmentFile = "${envFile}";
        count = 8;
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

    machine.wait_for_file("/var/lib/buildkite-agent-concurrent/buildkite-agent.cfg")

    # Make sure all 8 concurrent agent units exist and have the environment file set
    for n in range(1, 8):
        i = machine.get_unit_info("buildkite-agent-concurrent-{}".format(n))
        assert (
            "${envFile}"
            in i["EnvironmentFiles"]
        )
        assert i["LoadState"] == "loaded"
  '';
})

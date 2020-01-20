import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "buildkite-agent";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ flokli ];
  };

  nodes = {
    node1 = { pkgs, ... }: {
      services.buildkite-agent = {
        enable = true;
        privateSshKeyPath = (import ./ssh-keys.nix pkgs).snakeOilPrivateKey;
        tokenPath = (pkgs.writeText "my-token" "5678");
      };
    };
    # don't configure ssh key, run as a separate user
    node2 = { pkgs, ...}: {
      services.buildkite-agent = {
        enable = true;
        tokenPath = (pkgs.writeText "my-token" "1234");
      };
    };
  };

  testScript = ''
    start_all()
    # we can't wait on the unit to start up, as we obviously can't connect to buildkite,
    # but we can look whether files are set up correctly

    node1.wait_for_file("/var/lib/buildkite-agent/buildkite-agent.cfg")
    node1.wait_for_file("/var/lib/buildkite-agent/.ssh/id_rsa")

    node2.wait_for_file("/var/lib/buildkite-agent/buildkite-agent.cfg")
  '';
})

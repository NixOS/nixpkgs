<<<<<<< HEAD
import ./make-test-python.nix ({ lib, pkgs, ... }:

{
  name = "buildkite-agent";
  meta.maintainers = with lib.maintainers; [ flokli ];
=======
import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "buildkite-agent";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ flokli ];
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nodes.machine = { pkgs, ... }: {
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
})

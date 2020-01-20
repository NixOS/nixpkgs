import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "buildkite-agent";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ flokli ];
  };

  machine = { pkgs, ... }: {
    services.buildkite-agent = {
      enable = true;
      privateSshKeyPath = (import ./ssh-keys.nix pkgs).snakeOilPrivateKey;
      tokenPath = (pkgs.writeText "my-token" "5678");
    };
  };

  testScript = ''
    # we can't wait on the unit to start up, as we obviously can't connect to buildkite,
    # but we can look whether files are set up correctly
    machine.wait_for_file("/var/lib/buildkite-agent/buildkite-agent.cfg")
    machine.wait_for_file("/var/lib/buildkite-agent/.ssh/id_rsa")
  '';
})

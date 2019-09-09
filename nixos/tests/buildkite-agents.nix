import ./make-test.nix ({ lib, ... } : {
  name = "buildkite-agents";
  meta = with lib.maintainers; {
    maintainers = [ earvstedt ];
  };

  machine = { pkgs, ... }: {
    services.buildkite-agents = {
      foo = {
        extraConfig = "debug=true";
        hooks.environment = "export SECRET_VAR=`head -1 /run/keys/secret`";
        tokenPath = (pkgs.writeText "my-token" "1234");
      };
      bar = {
        sshKeyPath = (import ./ssh-keys.nix pkgs).snakeOilPrivateKey;
        tokenPath = (pkgs.writeText "my-token" "5678");
      };
    };
  };

  testScript = ''
    # we can't wait on the unit to start up, as we obviously can't connect to buildkite,
    # but we can look whether files are set up correctly
    $machine->waitForFile("/var/lib/buildkite-foo/buildkite-agent.cfg");
    $machine->waitForFile("/var/lib/buildkite-bar/buildkite-agent.cfg");
    $machine->waitForFile("/var/lib/buildkite-bar/.ssh/id_rsa");
  '';
})

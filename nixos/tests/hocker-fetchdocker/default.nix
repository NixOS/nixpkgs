import ../make-test.nix ({ pkgs, ...} : {
  name = "test-hocker-fetchdocker";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ixmatus ];
  };

  machine = import ./machine.nix;

  testScript = ''
    startAll;

    $machine->waitForUnit("sockets.target");
    $machine->waitUntilSucceeds("docker run registry-1.docker.io/v2/library/hello-world:latest");
  '';
})

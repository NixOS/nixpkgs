import ../make-test-python.nix ({ pkgs, ...} : {
  name = "test-hocker-fetchdocker";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ixmatus ];
  };

  machine = import ./machine.nix;

  testScript = ''
    start_all()

    machine.wait_for_unit("sockets.target")
    machine.wait_until_succeeds("docker run registry-1.docker.io/v2/library/hello-world:latest")
  '';
})

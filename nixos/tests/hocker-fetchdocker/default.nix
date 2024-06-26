import ../make-test-python.nix (
  { pkgs, ... }:
  {
    name = "test-hocker-fetchdocker";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ ixmatus ];
      broken = true; # tries to download from registry-1.docker.io - how did this ever work?
    };

    nodes.machine = import ./machine.nix;

    testScript = ''
      start_all()

      machine.wait_for_unit("sockets.target")
      machine.wait_until_succeeds("docker run registry-1.docker.io/v2/library/hello-world:latest")
    '';
  }
)

import ./make-test-python.nix ({ pkgs, ... }: {
  name = "trac";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mmahut ];
  };

  nodes = {
    machine = { ... }: {
      services.trac.enable = true;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("trac.service")
    machine.wait_for_open_port(8000)
    machine.wait_until_succeeds("curl -L http://localhost:8000/ | grep 'Trac Powered'")
  '';
})

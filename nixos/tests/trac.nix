import ./make-test-python.nix ({ pkgs, ... }: {
  name = "trac";
  meta = with pkgs.lib.maintainers; {
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
    machine.wait_until_succeeds("curl -fL http://localhost:8000/ | grep 'Trac Powered'")
  '';
})

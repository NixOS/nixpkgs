import ./make-test-python.nix ({ pkgs, ... }: {
  name = "metabase";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mmahut ];
  };

  nodes = {
    machine = { ... }: {
      services.metabase.enable = true;
      virtualisation.memorySize = 1024;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("metabase.service")
    machine.wait_for_open_port(3000)
    machine.wait_until_succeeds("curl -L http://localhost:3000/setup | grep Metabase")
  '';
})

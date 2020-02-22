import ./make-test-python.nix ({ pkgs, ... }: {
  name = "trezord";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mmahut "1000101" ];
  };

  nodes = {
    machine = { ... }: {
      services.trezord.enable = true;
      services.trezord.emulator.enable = true;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("trezord.service")
    machine.wait_for_open_port(21325)
    machine.wait_until_succeeds("curl -L http://localhost:21325/status/ | grep Version")
  '';
})

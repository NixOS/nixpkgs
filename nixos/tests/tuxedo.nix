import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "tuxedo";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ blitz ];
  };

  machine =
    { ... }:

    {
      hardware.tuxedo-control-center.enable = true;
    };

  testScript = ''
    start_all();

    machine.wait_for_unit("tccd.service")
  '';
})

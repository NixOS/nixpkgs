{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
}:
import ./make-test-python.nix ({lib, pkgs, ...}: {
  name = "fanout";
  meta.maintainers = [ lib.maintainers.therishidesai ];

  nodes = let
    cfg = { ... }: {
      services.fanout = {
        enable = true;
        fanoutDevices = 2;
        bufferSize = 8192;
      };
    };
  in {
    machine = cfg;
  };

  testScript = ''
    start_all()

    # mDNS.
    machine.wait_for_unit("multi-user.target")

    machine.succeed("test -c /dev/fanout0")
    machine.succeed("test -c /dev/fanout1")
  '';
})

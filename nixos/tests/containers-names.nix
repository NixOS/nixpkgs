import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "containers-names";
    meta = {
      maintainers = with lib.maintainers; [ patryk27 ];
    };

    nodes.machine =
      { ... }:
      {
        # We're using the newest kernel, so that we can test containers with long names.
        # Please see https://github.com/NixOS/nixpkgs/issues/38509 for details.
        boot.kernelPackages = pkgs.linuxPackages_latest;

        containers =
          let
            container = subnet: {
              autoStart = true;
              privateNetwork = true;
              hostAddress = "192.168.${subnet}.1";
              localAddress = "192.168.${subnet}.2";
              config = { };
            };

          in
          {
            first = container "1";
            second = container "2";
            really-long-name = container "3";
            really-long-long-name-2 = container "4";
          };
      };

    testScript = ''
      machine.wait_for_unit("default.target")

      machine.succeed("ip link show | grep ve-first")
      machine.succeed("ip link show | grep ve-second")
      machine.succeed("ip link show | grep ve-really-lFYWO")
      machine.succeed("ip link show | grep ve-really-l3QgY")
    '';
  }
)

{ lib, ... }:

{
  name = "freenet-core";

  meta.maintainers = [ lib.maintainers.LisaScheers ];

  nodes.machine.services.freenet-core = {
    enable = true;
    extraArgs = [
      "--skip-load-from-network"
      "--is-gateway"
      "--public-network-address=127.0.0.1"
      "--public-network-port=31337"
    ];
  };

  testScript = ''
    machine.wait_for_unit("freenet-core.service")
    machine.wait_for_open_port(7509)
    machine.succeed("curl --fail http://127.0.0.1:7509/")
  '';
}

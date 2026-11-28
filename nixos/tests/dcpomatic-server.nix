{ lib, ... }:
{
  name = "dcpomatic-server";
  meta.maintainers = with lib.maintainers; [ logn ];

  nodes.machine = { ... }: {
    services.dcpomatic-server = {
      enable = true;
      threads = 1;
    };
  };

  testScript = ''
    machine.wait_for_unit("dcpomatic-server.service")
    machine.wait_for_open_port(6192)
  '';
}

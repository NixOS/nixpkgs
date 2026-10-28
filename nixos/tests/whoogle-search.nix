{ pkgs, lib, ... }:
{
  name = "whoogle-search";
  meta.maintainers = with lib.maintainers; [ malte-v ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.whoogle-search = {
        enable = true;
        port = 5000;
        listenAddress = "127.0.0.1";
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("whoogle-search.service")
    machine.wait_for_open_port(5000)
    machine.wait_until_succeeds("curl --fail --show-error --silent --location localhost:5000/")
  '';
}

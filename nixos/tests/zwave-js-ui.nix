{ lib, ... }:
{
  name = "zwave-js-ui";
  meta.maintainers = with lib.maintainers; [ cdombroski ];

  nodes = {
    machine =
      { ... }:
      {
        services.zwave-js-ui = {
          enable = true;
          serialPort = "/dev/null";
          settings = {
            HOST = "::";
            PORT = "9999";
          };
        };
      };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("zwave-js-ui.service")
    machine.wait_for_open_port(9999)
    machine.wait_until_succeeds("journalctl --since -1m --unit zwave-js-ui --grep 'Listening on port 9999host :: protocol HTTP'")
    machine.wait_for_file("/var/lib/zwave-js-ui/users.json")
  '';
}

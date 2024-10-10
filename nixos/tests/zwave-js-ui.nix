import ./make-test-python.nix (
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
          };
        };
    };

    testScript = ''
      start_all()

      machine.wait_for_unit("zwave-js-ui.service")
      machine.wait_for_open_port(8091)
      machine.wait_until_succeeds("journalctl --since -1m --unit zwave-js-ui --grep 'Listening on port 8091 protocol HTTP'")
      machine.wait_for_file("/var/lib/zwave-js-ui/nodes.json")
    '';
  }
)

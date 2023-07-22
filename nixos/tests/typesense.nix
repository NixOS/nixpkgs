import ./make-test-python.nix ({ pkgs, ... }: let
  testPort = 8108;
in {
  name = "typesense";
  meta.maintainers = with pkgs.lib.maintainers; [ oddlama ];

  nodes.machine = { ... }: {
    services.typesense = {
      enable = true;
      apiKeyFile = pkgs.writeText "typesense-api-key" "dummy";
      settings.server = {
        api-port = testPort;
        api-address = "0.0.0.0";
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("typesense.service")
    machine.wait_for_open_port(${toString testPort})
    assert machine.succeed("curl --fail http://localhost:${toString testPort}/health") == '{"ok":true}'
  '';
})

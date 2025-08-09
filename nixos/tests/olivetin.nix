{ lib, ... }:

{
  name = "olivetin";
  meta.maintainers = with lib.maintainers; [ defelo ];

  nodes.machine = {
    services.olivetin = {
      enable = true;
      settings = {
        actions = [
          {
            id = "hello_world";
            title = "Say Hello";
            shell = "echo -n 'Hello World!' | tee /tmp/result";
          }
        ];
      };
      extraConfigFiles = [
        (builtins.toFile "secrets.yaml" ''
          actions:
            - id: secret
              title: Secret Action
              shell: echo -n secret > /tmp/result2
        '')
      ];
    };
  };

  interactive.nodes.machine = {
    services.olivetin.settings.ListenAddressSingleHTTPFrontend = "0.0.0.0:8000";
    networking.firewall.allowedTCPPorts = [ 8000 ];
    virtualisation.forwardPorts = [
      {
        from = "host";
        host.port = 8000;
        guest.port = 8000;
      }
    ];
  };

  testScript = ''
    import json

    machine.wait_for_unit("olivetin.service")
    machine.wait_for_open_port(8000)

    response = json.loads(machine.succeed("curl http://localhost:8000/api/StartActionByGetAndWait/hello_world"))
    assert response["logEntry"]["exitCode"] == 0
    assert response["logEntry"]["output"] == "Hello World!"
    assert machine.succeed("cat /tmp/result") == "Hello World!"

    response = json.loads(machine.succeed("curl http://localhost:8000/api/StartActionByGetAndWait/secret"))
    assert response["logEntry"]["exitCode"] == 0
    assert machine.succeed("cat /tmp/result2") == "secret"
  '';
}

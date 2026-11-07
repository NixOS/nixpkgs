{ config, lib, ... }:

{
  name = "olivetin";
  meta.maintainers = with lib.maintainers; [ defelo ];

  nodes.machine = {
    services.olivetin = {
      enable = true;
      settings = {
        # Keep the old spelling working.
        ListenAddressSingleHTTPFrontend = "127.0.0.1:8001";
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
    services.olivetin.settings.listenAddressSingleHTTPFrontend = lib.mkForce "0.0.0.0:8001";
    networking.firewall.allowedTCPPorts = [ 8001 ];
    virtualisation.forwardPorts = [
      {
        from = "host";
        host.port = 8001;
        guest.port = 8001;
      }
    ];
  };

  testScript = ''
    import json
    import shlex

    machine.wait_for_unit("olivetin.service")
    machine.wait_for_open_port(8001)

    def start_action(action):
      if "${config.nodes.machine.services.olivetin.package.releaseSeries}" == "2k":
        cmd = f"curl http://localhost:8001/api/StartActionByGetAndWait/{action}"
      else:
        req = {"actionId": action}
        cmd = f"curl -H 'Content-Type: application/json' http://localhost:8001/api/olivetin.api.v1.OliveTinApiService/StartActionAndWait -d {shlex.quote(json.dumps(req))}"

      return json.loads(machine.succeed(cmd))

    response = start_action("hello_world")
    assert response["logEntry"]["exitCode"] == 0
    assert response["logEntry"]["output"] == "Hello World!"
    assert machine.succeed("cat /tmp/result") == "Hello World!"

    response = start_action("secret")
    assert response["logEntry"]["exitCode"] == 0
    assert machine.succeed("cat /tmp/result2") == "secret"
  '';
}

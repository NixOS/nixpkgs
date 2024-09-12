{ pkgs, ... }:
let
  forwardedPort = 19000;
  internalPort = 9000;
in
{
  name = "webhook";

  nodes = {
    webhookMachine = { pkgs, ... }: {
      virtualisation.forwardPorts = [{
        host.port = forwardedPort;
        guest.port = internalPort;
      }];
      services.webhook = {
        enable = true;
        port = internalPort;
        openFirewall = true;
        hooks = {
          echo = {
            execute-command = "echo";
            response-message = "Webhook is reachable!";
          };
        };
        hooksTemplated = {
          echoTemplate = ''
            {
              "id": "echo-template",
              "execute-command": "echo",
              "response-message": "{{ getenv "WEBHOOK_MESSAGE" }}"
            }
          '';
        };
        environment.WEBHOOK_MESSAGE = "Templates are working!";
      };
    };
  };

  extraPythonPackages = p: [
    p.requests
    p.types-requests
  ];

  testScript = { nodes, ... }: ''
    import requests
    webhookMachine.wait_for_unit("webhook")
    webhookMachine.wait_for_open_port(${toString internalPort})

    with subtest("Check that webhooks can be called externally"):
      response = requests.get("http://localhost:${toString forwardedPort}/hooks/echo")
      print(f"Response code: {response.status_code}")
      print("Response: %r" % response.content)

      assert response.status_code == 200
      assert response.content == b"Webhook is reachable!"

    with subtest("Check that templated webhooks can be called externally"):
      response = requests.get("http://localhost:${toString forwardedPort}/hooks/echo-template")
      print(f"Response code: {response.status_code}")
      print("Response: %r" % response.content)

      assert response.status_code == 200
      assert response.content == b"Templates are working!"
  '';
}

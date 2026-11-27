{ ... }:
let
  forwardedPort = 19000;
  internalPort = 9000;
  forwardedPort2 = 19001;
  internalPort2 = 9001;
in
{
  name = "webhook";

  nodes = {
    webhookMachine1 =
      { ... }:
      {
        virtualisation.forwardPorts = [
          {
            host.port = forwardedPort;
            guest.port = internalPort;
          }
        ];

        services.webhook = {
          enable = true;
          hardening.enable = true;
          listenStream = toString internalPort;
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

        networking.firewall.allowedTCPPorts = [ internalPort ];
      };

    # test unix sockets behind nginx
    webhookMachine2 =
      { ... }:
      {
        virtualisation.forwardPorts = [
          {
            host.port = forwardedPort2;
            guest.port = internalPort2;
          }
        ];

        services.webhook = {
          enable = true;
          hardening.enable = true;
          listenStream = "/run/webhook/socket";
          hooks.echo = {
            execute-command = "echo";
            response-message = "Webhook is reachable!";
          };
        };

        services.caddy = {
          enable = true;
          virtualHosts.":${toString internalPort2}".extraConfig = ''
            reverse_proxy unix/run/webhook/socket
          '';
        };

        networking.firewall.allowedTCPPorts = [ internalPort2 ];
      };
  };

  extraPythonPackages = p: [
    p.requests
    p.types-requests
  ];

  testScript =
    { ... }:
    ''
      import requests
      webhookMachine1.start()
      webhookMachine2.start()

      webhookMachine1.wait_for_open_port(${toString internalPort})

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

      webhookMachine2.wait_for_open_port(${toString internalPort2})

      with subtest("Check that webhooks can be called externally through a reverse proxy via unix sockets"):
        response = requests.get("http://localhost:${toString forwardedPort2}/hooks/echo")
        print(f"Response code: {response.status_code}")
        print("Response: %r" % response.content)

        assert response.status_code == 200
        assert response.content == b"Webhook is reachable!"
    '';
}

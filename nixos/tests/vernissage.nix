{ pkgs, ... }:
let
  forwardedPort = 8181;
  internalPort = 8080;
in
{
  name = "vernissage";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      Cameo007
    ];
  };

  nodes.machine = {
    virtualisation.forwardPorts = [
      {
        host.port = forwardedPort;
        guest.port = internalPort;
      }
    ];
    networking.firewall.allowedTCPPorts = [ internalPort ];

    services.vernissage = {
      api = {
        enable = true;
        settings = {
          baseAddress = "http://localhost";
          queueUrl = "redis://127.0.0.1:6379";
        };
      };
      push = {
        enable = true;
        vpushKeyFile = pkgs.writeText "vernissage-push-key" ''
          abc
        '';
      };
    };
    services.redis.servers.vernissage = {
      enable = true;
      port = 6379;
    };
  };

  extraPythonPackages = p: [
    p.requests
  ];

  testScript = ''
    import requests, json

    machine.wait_for_unit("vernissage-server")
    machine.wait_for_unit("vernissage-push")
    machine.wait_for_open_port(${toString internalPort})
    machine.wait_for_open_port(3000)

    access_token = requests.post("http://localhost:${toString forwardedPort}/api/v1/account/login", headers = {"Content-Type": "application/json"}, data = "{\"userNameOrEmail\": \"admin\", \"password\": \"admin\"}").json()["accessToken"]
    settings = requests.get("http://localhost:${toString forwardedPort}/api/v1/settings", headers = {"Authorization": f"Bearer {access_token}"}).json()
    settings["webPushEndpoint"] = "http://localhost:3000"

    updated_settings = requests.put("http://localhost:${toString forwardedPort}/api/v1/settings", headers = {"Content-Type": "application/json", "Authorization": f"Bearer {access_token}"}, data = json.dumps(settings))
    assert updated_settings.status_code == 200, "Could not register push service at server"

    status = json.loads(machine.succeed("curl -f http://localhost:8080/api/v1/health"))
    assert status["isDatabaseHealthy"] and status["isQueueHealthy"] and status["isStorageHealthy"] and status["isWebPushHealthy"], "The unit is not healthy"
  '';
}

{ lib, ... }:
{
  name = "pufferpanel";
  meta.maintainers = [ lib.maintainers.tie ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.pufferpanel ];
      services.pufferpanel = {
        enable = true;
        extraPackages = [ pkgs.netcat ];
        environment = {
          PUFFER_PANEL_REGISTRATIONENABLED = "false";
          PUFFER_PANEL_SETTINGS_COMPANYNAME = "NixOS";
        };
      };
    };

  testScript = ''
    import shlex
    import json

    curl = "curl --fail-with-body --silent"
    baseURL = "http://localhost:8080"
    adminName = "admin"
    adminEmail = "admin@nixos.org"
    adminPass = "admin"
    adminCreds = json.dumps({
      "email": adminEmail,
      "password": adminPass,
    })
    stopCode = 9 # SIGKILL
    serverPort = 1337
    serverDefinition = json.dumps({
      "name": "netcat",
      "node": 0,
      "users": [
        adminName,
      ],
      "type": "netcat",
      "run": {
        "stopCode": stopCode,
        "command": f"nc -l {serverPort}",
      },
      "environment": {
        "type": "standard",
      },
    })

    start_all()

    machine.wait_for_unit("pufferpanel.service")
    machine.wait_for_open_port(5657) # SFTP
    machine.wait_for_open_port(8080) # HTTP

    # Note that PufferPanel does not initialize database unless necessary.
    # /api/config endpoint creates database file and triggers migrations.
    # On success, we run a command to create administrator user that we use to
    # interact with HTTP API.
    resp = json.loads(machine.succeed(f"{curl} {baseURL}/api/config"))
    assert resp["branding"]["name"] == "NixOS", "Invalid company name in configuration"
    assert resp["registrationEnabled"] == False, "Expected registration to be disabled"

    machine.succeed(f"pufferpanel --workDir /var/lib/pufferpanel user add --admin --name {adminName} --email {adminEmail} --password {adminPass}")

    resp = json.loads(machine.succeed(f"{curl} -d '{adminCreds}' {baseURL}/auth/login"))
    assert "servers.admin" in resp["scopes"], "User is not administrator"
    token = resp["session"]
    authHeader = shlex.quote(f"Authorization: Bearer {token}")

    resp = json.loads(machine.succeed(f"{curl} -H {authHeader} -H 'Content-Type: application/json' -d '{serverDefinition}' {baseURL}/api/servers"))
    serverID = resp["id"]
    machine.succeed(f"{curl} -X POST -H {authHeader} {baseURL}/proxy/daemon/server/{serverID}/start")
    machine.wait_for_open_port(serverPort)
  '';
}

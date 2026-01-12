{ lib, ... }:

let
  domain = "http://glitchtip.local:8000";
in

{
  name = "glitchtip";
  meta.maintainers = with lib.maintainers; [
    defelo
    felbinger
  ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.glitchtip = {
        enable = true;
        port = 8000;
        settings.GLITCHTIP_DOMAIN = domain;
        environmentFiles = [
          (builtins.toFile "glitchtip.env" ''
            SECRET_KEY=8Hz7YCGzo7fiicHb8Qr22ZqwoIB7lSRx
          '')
        ];
      };

      environment.systemPackages = [ pkgs.sentry-cli ];

      networking.hosts."127.0.0.1" = [ "glitchtip.local" ];
    };

  interactive.nodes.machine = {
    services.glitchtip.listenAddress = "0.0.0.0";
    networking.firewall.allowedTCPPorts = [ 8000 ];
    virtualisation.forwardPorts = [
      {
        from = "host";
        host.port = 8000;
        guest.port = 8000;
      }
    ];
  };

  testScript =
    { nodes, ... }: # python
    ''
      import json
      import re
      import time

      machine.wait_for_unit("glitchtip.service")
      machine.wait_for_unit("glitchtip-worker.service")
      machine.wait_for_open_port(8000)

      origin_url = "${domain}"
      cookie_jar_path = "/tmp/cookies.txt"
      curl = f"curl -b {cookie_jar_path} -c {cookie_jar_path} -fS -H 'Origin: {origin_url}'"

      # create superuser account
      machine.succeed("DJANGO_SUPERUSER_PASSWORD=password glitchtip-manage createsuperuser --no-input --email=admin@example.com")

      # login
      machine.fail(f"{curl} -s {origin_url}/_allauth/browser/v1/auth/session")  # get the csrf token, returns a 401
      csrf_token = machine.succeed(f"grep csrftoken {cookie_jar_path} | cut -f7").rstrip()
      machine.succeed(f"{curl} {origin_url}/_allauth/browser/v1/auth/login -s -H 'X-Csrftoken: {csrf_token}' -H 'Content-Type: application/json' -d '{{\"email\": \"admin@example.com\", \"password\": \"password\"}}'")

      resp = json.loads(machine.succeed(f"{curl} {origin_url}/api/0/users/me/"))
      assert resp["email"] == "admin@example.com"
      assert resp["isSuperuser"] is True

      # create organization
      csrf_token = machine.succeed(f"grep csrftoken {cookie_jar_path} | cut -f7").rstrip()
      machine.succeed(f"{curl} {origin_url}/api/0/organizations/ -s -H 'X-Csrftoken: {csrf_token}' -H 'Content-Type: application/json' -d '{{\"name\": \"main\"}}'")

      resp = json.loads(machine.succeed(f"{curl} {origin_url}/api/0/organizations/"))
      assert len(resp) == 1
      assert resp[0]["name"] == "main"
      assert resp[0]["slug"] == "main"

      # create team
      csrf_token = machine.succeed(f"grep csrftoken {cookie_jar_path} | cut -f7").rstrip()
      machine.succeed(f"{curl} {origin_url}/api/0/organizations/main/teams/ -s -H 'X-Csrftoken: {csrf_token}' -H 'Content-Type: application/json' -d '{{\"slug\": \"test\"}}'")

      # create project
      csrf_token = machine.succeed(f"grep csrftoken {cookie_jar_path} | cut -f7").rstrip()
      machine.succeed(f"{curl} {origin_url}/api/0/teams/main/test/projects/ -s -H 'X-Csrftoken: {csrf_token}' -H 'Content-Type: application/json' -d '{{\"name\": \"test\"}}'")

      # fetch dsn
      resp = json.loads(machine.succeed(f"{curl} {origin_url}/api/0/projects/main/test/keys/"))
      assert len(resp) == 1
      assert re.match(r"^http://[\da-f]+@glitchtip\.local:8000/\d+$", dsn := resp[0]["dsn"]["public"])

      # send event
      machine.succeed(f"SENTRY_DSN={dsn} sentry-cli send-event -m 'hello world'")

      for _ in range(20):
        resp = json.loads(machine.succeed(f"{curl} {origin_url}/api/0/organizations/main/issues/?query=is:unresolved"))
        if len(resp) != 0: break
        time.sleep(1)
      assert len(resp) == 1
      assert resp[0]["title"] == "hello world"
      assert int(resp[0]["count"]) == 1

      # create api token
      csrf_token = machine.succeed(f"grep csrftoken {cookie_jar_path} | cut -f7").rstrip()
      resp = json.loads(machine.succeed(f"{curl} {origin_url}/api/0/api-tokens/ -s -H 'X-Csrftoken: {csrf_token}' -H 'Content-Type: application/json' -d '{{\"label\":\"token\",\"scopes\":[\"project:write\"]}}'"))
      token = resp["token"]

      # upload sourcemaps
      machine.succeed(f"sentry-cli --url {origin_url} --auth-token {token} sourcemaps upload --org main --project test ${nodes.machine.services.glitchtip.package.frontend}/*.map")
      assert machine.succeed("ls /var/lib/glitchtip/uploads/file_blobs/").strip()
    '';
}

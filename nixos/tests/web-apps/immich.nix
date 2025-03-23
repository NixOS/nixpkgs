import ../make-test-python.nix (
  { ... }:
  {
    name = "immich-nixos";

    nodes.machine =
      { pkgs, ... }:
      {
        # These tests need a little more juice
        virtualisation = {
          cores = 2;
          memorySize = 2048;
          diskSize = 4096;
        };

        environment.systemPackages = with pkgs; [ immich-cli ];

        services.immich = {
          enable = true;
          environment.IMMICH_LOG_LEVEL = "verbose";
        };
      };

    testScript = ''
      import json

      machine.wait_for_unit("immich-server.service")

      machine.wait_for_open_port(2283) # Server
      machine.wait_for_open_port(3003) # Machine learning
      machine.succeed("curl --fail http://localhost:2283/")

      machine.succeed("""
        curl -f --json '{ "email": "test@example.com", "name": "Admin", "password": "admin" }' http://localhost:2283/api/auth/admin-sign-up
      """)
      res = machine.succeed("""
        curl -f --json '{ "email": "test@example.com", "password": "admin" }' http://localhost:2283/api/auth/login
      """)
      token = json.loads(res)['accessToken']

      res = machine.succeed("""
        curl -f -H 'Cookie: immich_access_token=%s' --json '{ "name": "API Key", "permissions": ["all"] }' http://localhost:2283/api/api-keys
      """ % token)
      key = json.loads(res)['secret']

      machine.succeed(f"immich login http://localhost:2283/api {key}")
      res = machine.succeed("immich server-info")
      print(res)

      machine.succeed("""
        curl -f -X PUT -H 'Cookie: immich_access_token=%s' --json '{ "command": "start" }' http://localhost:2283/api/jobs/backupDatabase
      """ % token)
      res = machine.succeed("""
        curl -f -H 'Cookie: immich_access_token=%s' http://localhost:2283/api/jobs
      """ % token)
      assert sum(json.loads(res)["backupDatabase"]["jobCounts"].values()) >= 1
      machine.wait_until_succeeds("ls /var/lib/immich/backups/*.sql.gz")
    '';
  }
)

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

      machine.wait_for_open_port(3001) # Server
      machine.wait_for_open_port(3003) # Machine learning
      machine.succeed("curl --fail http://localhost:3001/")

      machine.succeed("""
        curl -H 'Content-Type: application/json' --data '{ "email": "test@example.com", "name": "Admin", "password": "admin" }' -X POST http://localhost:3001/api/auth/admin-sign-up
      """)
      res = machine.succeed("""
        curl -H 'Content-Type: application/json' --data '{ "email": "test@example.com", "password": "admin" }' -X POST http://localhost:3001/api/auth/login
      """)
      token = json.loads(res)['accessToken']

      res = machine.succeed("""
        curl -H 'Content-Type: application/json' -H 'Cookie: immich_access_token=%s' --data '{ "name": "API Key", "permissions": ["all"] }' -X POST http://localhost:3001/api/api-keys
      """ % token)
      key = json.loads(res)['secret']

      machine.succeed(f"immich login http://localhost:3001/api {key}")
      res = machine.succeed("immich server-info")
      print(res)
    '';
  }
)

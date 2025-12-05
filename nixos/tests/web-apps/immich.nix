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
        settings = {
          backup.database = {
            enabled = true;
            # Test loading secrets from files:
            cronExpression._secret = "${pkgs.writeText "cron" "0 02 * * *"}";
          };
          # thanks to LoadCredential files only readable by root should work
          notifications.smtp.transport.password._secret = "/etc/shadow";
        };
      };

      # licensed under  CC0 1.0: https://github.com/NixOS/nixpkgs/issues/450972#issuecomment-3393545531
      environment.etc.photos.source = pkgs.fetchzip {
        url = "https://github.com/user-attachments/files/22865871/IMGP5923.zip";
        hash = "sha256-ux0IG1qCB1s8GKsZp9R0rvwEZxeXm5FnuS9kYstKVmo=";
      };
    };

  testScript = ''
    import json

    machine.wait_for_unit("immich-server.service")

    machine.succeed("stat -L -c '%a %U %G' /run/immich/config.json | grep '600 immich immich'")

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

    with subtest("Test thumbnail generation from PEF format"):
      res = machine.succeed("immich upload --json-output /etc/photos/IMGP5923.PEF | tail -n +4")
      asset_id = json.loads(res)["newAssets"][0]["id"]
      machine.wait_until_succeeds(f"""
        curl -fI -X GET -H 'Cookie: immich_access_token={token}' http://localhost:2283/api/assets/{asset_id}/thumbnail
      """)

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

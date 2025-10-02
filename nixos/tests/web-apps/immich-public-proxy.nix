{ pkgs, lib, ... }:
{
  name = "immich-public-proxy";

  nodes.machine =
    { pkgs, ... }@args:
    {
      environment.systemPackages = [
        pkgs.imagemagick
        pkgs.immich-cli
      ];
      services.immich = {
        enable = true;
        port = 2283;
        # disable a lot of features that aren't needed for this test
        machine-learning.enable = false;
        settings = {
          backup.database.enabled = false;
          machineLearning.enabled = false;
          map.enabled = false;
          reverseGeocoding.enabled = false;
          metadata.faces.import = false;
          newVersionCheck.enabled = false;
          notifications.smtp.enabled = false;
        };
      };
      services.immich-public-proxy = {
        enable = true;
        immichUrl = "http://localhost:2283";
        port = 8002;
        settings.ipp.responseHeaders."X-NixOS" = "Rules";
      };

      # TODO: Remove when PostgreSQL 17 is supported.
      services.postgresql.package = pkgs.postgresql_16;
    };

  testScript = ''
    import json

    machine.wait_for_unit("immich-server.service")
    machine.wait_for_unit("immich-public-proxy.service")
    machine.wait_for_open_port(2283)
    machine.wait_for_open_port(8002)

    # The proxy should be up
    machine.succeed("curl -sf http://localhost:8002")

    # Verify the static assets are served
    machine.succeed("curl -sf http://localhost:8002/robots.txt")
    machine.succeed("curl -sf http://localhost:8002/share/static/style.css")

    # Check that the response header in the settings is sent
    res = machine.succeed("""
      curl -sD - http://localhost:8002 -o /dev/null
    """)
    assert "x-nixos: rules" in res.lower(), res

    # Log in to Immich and create an access key
    machine.succeed("""
      curl -sf --json '{ "email": "test@example.com", "name": "Admin", "password": "admin" }' http://localhost:2283/api/auth/admin-sign-up
    """)
    res = machine.succeed("""
      curl -sf --json '{ "email": "test@example.com", "password": "admin" }' http://localhost:2283/api/auth/login
    """)
    token = json.loads(res)['accessToken']
    res = machine.succeed("""
      curl -sf -H 'Cookie: immich_access_token=%s' --json '{ "name": "API Key", "permissions": ["all"] }' http://localhost:2283/api/api-keys
    """ % token)
    key = json.loads(res)['secret']
    machine.succeed(f"immich login http://localhost:2283/api {key}")
    res = machine.succeed("immich server-info")
    print(res)

    # Upload some blank images to a new album
    # If there's only one image, the proxy serves the image directly
    machine.succeed("magick -size 800x600 canvas:white /tmp/white.png")
    machine.succeed("immich upload -A '✨ Reproducible Moments ✨' /tmp/white.png")
    machine.succeed("magick -size 800x600 canvas:black /tmp/black.png")
    machine.succeed("immich upload -A '✨ Reproducible Moments ✨' /tmp/black.png")
    res = machine.succeed("immich server-info")
    print(res)

    # Get the new album id
    res = machine.succeed("""
      curl -sf -H 'Cookie: immich_access_token=%s' http://localhost:2283/api/albums
    """ % token)
    album_id = json.loads(res)[0]['id']

    # Create a shared link
    res = machine.succeed("""
      curl -sf -H 'Cookie: immich_access_token=%s' --json '{ "albumId": "%s", "type": "ALBUM" }' http://localhost:2283/api/shared-links
    """ % (token, album_id))
    share_key = json.loads(res)['key']

    # Access the share
    machine.succeed("""
      curl -sf http://localhost:2283/share/%s
    """ % share_key)

    # Access the share through the proxy
    machine.succeed("""
      curl -sf http://localhost:8002/share/%s
    """ % share_key)
  '';
}

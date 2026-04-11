let
  apiKeyFile = "/tmp/immich-api.key";
  customInterval = 5;
in
{
  name = "immichframe";

  enableOCR = true;

  nodes.machine =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ ../common/x11.nix ];

      # When setting this to 2500 I got "Kernel panic - not syncing: Out of
      # memory: compulsory panic_on_oom is enabled".
      virtualisation.memorySize = 3000;

      environment.systemPackages = with pkgs; [
        imagemagick
        immich-cli
        firefox
        xdotool
      ];

      fonts.packages = [ pkgs.liberation_ttf ];

      services.immich = {
        enable = true;
        port = 2283;
        openFirewall = true;
        # Disable a bunch of features that aren't needed for this test.
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

      services.immichframe = {
        enable = true;
        port = 8002;
        settings = {
          General.Interval = customInterval;
          Accounts = [
            {
              ImmichServerUrl = "http://localhost:${toString config.services.immich.port}";
              ApiKeyFile = apiKeyFile;
            }
          ];
        };
      };
    };

  testScript = /* python */ ''
    import json
    import tempfile
    from shlex import quote

    custom_interval = ${toString customInterval}

    machine.wait_for_unit("immich-server.service")
    machine.wait_for_open_port(2283)

    # Log in to Immich and create an access key.
    machine.succeed("""
      curl --no-progress-meter -f --json '{ "email": "test@example.com", "name": "Admin", "password": "admin" }' http://localhost:2283/api/auth/admin-sign-up
    """)
    res = machine.succeed("""
      curl --no-progress-meter -f --json '{ "email": "test@example.com", "password": "admin" }' http://localhost:2283/api/auth/login
    """)
    token = json.loads(res)['accessToken']
    res = machine.succeed("""
      curl --no-progress-meter -f -H 'Cookie: immich_access_token=%s' --json '{ "name": "API Key", "permissions": ["all"] }' http://localhost:2283/api/api-keys
    """ % token)
    key = json.loads(res)['secret']
    machine.succeed(f"immich login http://localhost:2283/api {key}")
    res = machine.succeed("immich server-info")
    print(res)

    # Create the API key so ImmichFrame can start.
    with tempfile.NamedTemporaryFile("w", delete_on_close=False) as f:
      f.write(key)
      f.close()
      machine.copy_from_host(f.name, ${builtins.toJSON apiKeyFile})

    # We finally have an api key! Make sure ImmichFrame starts up.
    machine.wait_for_unit("immichframe.service")
    machine.wait_for_open_port(8002)

    # Check ImmichFrame's configuration.
    res = machine.succeed("curl --no-progress-meter -f http://localhost:8002/api/Config")
    frame_config = json.loads(res)
    assert frame_config['interval'] == custom_interval, frame_config

    # At this point, ImmichFrame should not find any images to serve.
    res = machine.succeed("curl -f http://localhost:8002/api/Asset")
    assets = json.loads(res)
    assert len(assets) == 0, assets

    # Repeat to make it easier for OCR to pick up given overlays
    image_text = '\\n'.join(['reproduce this moment', 'with NixOS tests <3'] * 6)

    # These settings make it display fine given potential cropping.
    common_args = f"-gravity center -font Liberation-Mono -pointsize 50 -annotate 0 {quote(image_text)}"

    # Upload some images to a new album.
    album_title = '✨ Reproducible Moments ✨'
    machine.succeed(f"magick -size 1920x1080 canvas:white -fill black {common_args} /tmp/white.png")
    machine.succeed(f"immich upload -A {quote(album_title)} /tmp/white.png")
    machine.succeed(f"magick -size 1920x1080 canvas:black -fill white {common_args} /tmp/black.png")
    machine.succeed(f"immich upload -A {quote(album_title)} /tmp/black.png")
    res = machine.succeed("immich server-info")
    print(res)

    # ImmichFrame should now find some assets.
    # Note: we restart ImmichFrame because it has some caching that prevents it
    # from immediately seeing the newly uploaded photos.
    machine.succeed("systemctl restart immichframe.service")
    machine.wait_for_open_port(8002)
    res = machine.succeed("curl --no-progress-meter -f http://localhost:8002/api/Asset")
    assets = json.loads(res)
    assert len(assets) == 2, assets

    # Wait for a photo to be displayed.
    machine.wait_for_x()
    machine.execute("xterm -e 'firefox --kiosk http://localhost:8002' >&2 &")
    machine.wait_for_window("immichFrame")
    _, active_window = machine.execute("xdotool getactivewindow")
    machine.succeed(f"xdotool windowsize {quote(active_window.strip())} 100% 100%")
    machine.wait_for_text('reproduce this moment')
    machine.wait_for_text('with NixOS tests')
    machine.screenshot("screen")
  '';
}

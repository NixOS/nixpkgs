{ pkgs, ... }:
let
  port = 5000;
  portStr = toString port;

  testTrack = pkgs.runCommand "test-track.mp3" {
    nativeBuildInputs = [ pkgs.ffmpeg-headless ];
  } ''
    ffmpeg -f lavfi -i 'sine=frequency=1000:duration=75' \
           -f lavfi -i 'testsrc=duration=1:size=500x500:rate=1' \
           -map 0:a -map 1:v \
           -c:a libmp3lame -b:a 320k -c:v mjpeg \
           -metadata title='Test Music' \
           -metadata artist='Nixpkgs' \
           -metadata album='Greatest Hits' \
           -id3v2_version 3 \
           -y "$out"
  '';
in
{
  name = "funkwhale";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.funkwhale = {
          enable = true;
          configureNginx = true;
          settings = {
            FUNKWHALE_HOSTNAME = "localhost:${portStr}";
            DJANGO_ALLOWED_HOSTS = [
              "127.0.0.1:${portStr}"
              "localhost:${portStr}"
            ];
            TYPESENSE_URL = "http://localhost:8108";
            TYPESENSE_API_KEY = "publicly-secret-key";
          };
        };

        services.typesense = {
          enable = true;
          settings.server.api-address = "127.0.0.1";
          apiKeyFile = pkgs.writeText "surely-not-in-store" "publicly-secret-key";
        };

        # Needs this much memory or when running the test, it's killed due to OOM.
        virtualisation.memorySize = 2049;
        environment.systemPackages = with pkgs; [
          jq
          ffmpeg-headless
          file
        ];
      };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("funkwhale.target")

    # Website is served.
    machine.wait_for_console_text("Listening at: http://127.0.0.1:${portStr}")

    # Can create supseruser and login.
    machine.succeed("funkwhale-manage fw users create --superuser "
                    "--username testinahat --email test@example.com --password teast1997")
    machine.succeed("curl -s -f -c /tmp/cookies.txt http://localhost:${portStr}/api/v2/users/login "
                    "  --form 'username=testinahat' --form 'password=teast1997' "
                    "  -H 'X-CSRFToken: 00000000000000000000000000000000' --cookie 'csrftoken=00000000000000000000000000000000'")

    # Typesense integration works.
    machine.succeed("funkwhale-manage generate_typesense_index")
    machine.wait_for_console_text("typesense\\.build_canonical_index.*succeeded")

    # Can import and play a track
    machine.succeed(
        "library_uuid=$(funkwhale-manage create_library testinahat --name test_library --privacy-level everyone | grep -oP 'UUID \\K.*') && "
        "funkwhale-manage import_files $library_uuid ${testTrack} --noinput"
    )

    machine.wait_until_succeeds("funkwhale-manage shell -c 'from funkwhale_api.music.models import Track; assert Track.objects.filter(title=\"Test Music\").exists()'")

    track_uuid = machine.succeed(
        "funkwhale-manage shell -c 'from funkwhale_api.music.models import Track; print(\"UUID_MAGIC_\" + str(Track.objects.get(title=\"Test Music\").uuid))' | grep -oP 'UUID_MAGIC_\\K.*'"
    ).strip()

    # Verify ID3 cover art was extracted and is served by Nginx
    cover_path = machine.succeed(
        "funkwhale-manage shell -c 'import urllib.parse; from funkwhale_api.music.models import Track; print(\"COVER_MAGIC_\" + urllib.parse.urlsplit(Track.objects.get(title=\"Test Music\").album.attachment_cover.file.url).path)' | grep -oP 'COVER_MAGIC_\\K.*'"
    ).strip()
    machine.succeed(f"curl -s -f -I -H 'Host: localhost:${portStr}' http://localhost{cover_path} | grep -i 'image/jpeg'")

    # Create OAuth application and token to test authenticated playback
    token = machine.succeed(
        "funkwhale-manage shell -c '"
        "from datetime import timedelta; "
        "from django.utils import timezone; "
        "from funkwhale_api.users.models import User, AccessToken, Application; "
        "user = User.objects.get(username=\"testinahat\"); "
        "app = Application.objects.create(name=\"test\", client_type=\"confidential\", authorization_grant_type=\"password\", user=user, scope=\"read:libraries\"); "
        "token = AccessToken.objects.create(user=user, application=app, token=\"test_token_12345\", expires=timezone.now() + timedelta(days=1), scope=\"read:libraries\"); "
        "print(\"TOKEN_MAGIC_\" + token.token)"
        "' | grep -oP 'TOKEN_MAGIC_\\K.*'"
    ).strip()

    # Stream track with Bearer token authentication and on-the-fly transcoding
    machine.succeed(
        f"curl -s -f -H 'Authorization: Bearer {token}' -H 'Host: localhost:${portStr}' http://localhost/api/v2/listen/{track_uuid}/?to=mp3 --output /tmp/downloaded.mp3"
    )

    out = machine.succeed("ls -lh /tmp/downloaded.mp3 && file /tmp/downloaded.mp3")
    machine.log(f"DOWNLOADED FILE INFO: {out}")

    machine.succeed("file /tmp/downloaded.mp3 | grep -i 'Audio file with ID3'")
  '';

  # Debug interactively with:
  # - nix build -f . nixosTests.funkwhale.driverInteractive
  # - ./result/bin/nixos-test-driver
  # - run_tests()
  # - dump_machine_ssh()
  interactive.sshBackdoor.enable = true;

  interactive.nodes.machine =
    { ... }:
    {
      virtualisation.forwardPorts = [
        {
          from = "host";
          host.port = port;
          guest.port = 80;
        }
      ];

      # Give some disk size for uploads.
      virtualisation.diskSize = 4096;

      # forwarded ports need to be accessible
      networking.firewall.allowedTCPPorts = [ 80 ];
    };
}

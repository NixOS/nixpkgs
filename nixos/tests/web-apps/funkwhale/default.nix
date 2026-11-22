{ ... }:
let
  port = 5000;
  portStr = toString port;
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
    machine.succeed("ffmpeg -f lavfi -i sine=frequency=1000:duration=1 -metadata title=\"test\" -metadata artist=\"test\" -metadata album=\"test\" -c:a libvorbis /tmp/test.ogg")
    machine.succeed("chown funkwhale:funkwhale /tmp/test.ogg")

    machine.succeed(
        "library_uuid=$(funkwhale-manage create_library testinahat --name test_library --privacy-level everyone | grep -oP 'UUID \\K.*') && "
        "funkwhale-manage import_files $library_uuid /tmp/test.ogg --noinput"
    )

    machine.wait_until_succeeds("funkwhale-manage shell -c 'from funkwhale_api.music.models import Track; assert Track.objects.exists()'")

    track_uuid = machine.succeed(
        "funkwhale-manage shell -c 'from funkwhale_api.music.models import Track; print(\"UUID_MAGIC_\" + str(Track.objects.last().uuid))' | grep -oP 'UUID_MAGIC_\\K.*'"
    ).strip()

    machine.succeed(
        f"curl -s -f -L -b /tmp/cookies.txt -H 'Host: localhost:${portStr}' http://localhost/api/v2/listen/{track_uuid}/ --output /tmp/downloaded.ogg"
    )

    out = machine.succeed("ls -l /tmp/downloaded.ogg && file /tmp/downloaded.ogg && head -c 20 /tmp/downloaded.ogg")
    machine.log(f"DOWNLOADED FILE INFO: {out}")

    machine.succeed("file /tmp/downloaded.ogg | grep -i 'Ogg data'")
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

      # forwarded ports need to be accessible
      networking.firewall.allowedTCPPorts = [ 80 ];
    };
}

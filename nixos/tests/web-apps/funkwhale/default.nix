{
  sources,
  ...
}:
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
            FUNKWHALE_HOSTNAME = "localhost:5000";
            DJANGO_ALLOWED_HOSTS = [
              "127.0.0.1:5000"
              "localhost:5000"
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

        # Protection from the ruthless OOM Killer.
        virtualisation.memorySize = 2049;
        environment.systemPackages = [
          pkgs.jq
          pkgs.ffmpeg-headless
          pkgs.file
        ];
      };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("funkwhale.target")

    # Website is served.
    machine.wait_for_console_text("Listening at: http://127.0.0.1:5000")

    # Can create supseruser and login.
    machine.succeed("cd /var/lib/funkwhale && sudo -u funkwhale funkwhale-manage fw users create --superuser "
                    "--username testinahat --email test@example.com --password teast1997")
    machine.succeed('curl --fail http://localhost:5000/api/v2/users/login '
                    '--form "username=testinahat" --form "password=teast1997" '
                    '-H "X-CSRFToken: 00000000000000000000000000000000" '
                    '--cookie "csrftoken=00000000000000000000000000000000"')

    # Typesense integration works.
    machine.succeed("sudo -u funkwhale funkwhale-manage generate_typesense_index")
    machine.wait_for_console_text("typesense\\.build_canonical_index.*succeeded")

    # Can import and play a track
    machine.succeed("ffmpeg -f lavfi -i sine=frequency=1000:duration=1 -metadata title=\"test\" -metadata artist=\"test\" -metadata album=\"test\" -c:a libvorbis /tmp/test.ogg")
    machine.succeed("chown funkwhale:funkwhale /tmp/test.ogg")

    machine.succeed(
        "library_uuid=$(sudo -u funkwhale funkwhale-manage create_library testinahat --name test_library --privacy-level everyone | grep -oP 'UUID \\K.*') && "
        "sudo -u funkwhale funkwhale-manage import_files $library_uuid /tmp/test.ogg --noinput"
    )

    machine.sleep(10)

    machine.succeed(
        "curl -s -f -c /tmp/cookies.txt http://localhost:5000/api/v2/users/login "
        "  --form 'username=testinahat' --form 'password=teast1997' "
        "  -H 'X-CSRFToken: 00000000000000000000000000000000' --cookie 'csrftoken=00000000000000000000000000000000'"
    )

    track_uuid = machine.succeed(
        "sudo -u funkwhale funkwhale-manage shell -c 'from funkwhale_api.music.models import Track; print(\"UUID_MAGIC_\" + str(Track.objects.last().uuid))' | grep -oP 'UUID_MAGIC_\\K.*'"
    ).strip()

    machine.succeed(
        f"curl -s -f -L -b /tmp/cookies.txt -H 'Host: localhost:5000' http://localhost/api/v2/listen/{track_uuid}/ --output /tmp/downloaded.ogg"
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
    { config, ... }:
    {
      virtualisation.forwardPorts = [
        {
          from = "host";
          host.port = 5000;
          guest.port = 80;
        }
      ];

      # forwarded ports need to be accessible
      networking.firewall.allowedTCPPorts = [ 80 ];
    };
}

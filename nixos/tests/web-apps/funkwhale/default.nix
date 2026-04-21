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
          settings.server.api-address = "localhost";
          apiKeyFile = pkgs.writeText "surely-not-in-store" "publicly-secret-key";
        };

        # Protection from the ruthless OOM Killer.
        virtualisation.memorySize = 2049;
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

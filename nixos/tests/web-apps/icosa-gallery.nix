{ lib, ... }:
{
  name = "icosa-gallery";
  meta.teams = [ lib.teams.ngi ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.icosa-gallery = {
        enable = true;
        enableLocalDB = true;
        openFirewall = true;
        host = "0.0.0.0";
        port = 8080;
        settings = {
          # Do *NOT* do this in production, use https://wiki.nixos.org/wiki/Comparison_of_secret_managing_schemes, eg. sops-nix
          POSTGRES_PASSWORD = "icosa-gallery";
          DJANGO_SECRET_KEY = "SnakeOilKEY";
          JWT_SECRET_KEY = "SnakeOilKEY2";

          DJANGO_DISABLE_CACHE = "1";
          DEPLOYMENT_NO_SSL = "1";
          DEPLOYMENT_ENV = "local";
          DEPLOYMENT_HOST_WEB = "localhost:8080";
        };
      };

      # Do *NOT* do this in production!
      services.postgresql.initialScript = pkgs.writeText "init-sql-script" ''
        CREATE ROLE "icosa-gallery" LOGIN PASSWORD 'icosa-gallery';
      '';
    };

  testScript =
    { nodes, ... }:
    let
      port = toString nodes.machine.services.icosa-gallery.port;
    in
    ''
      machine.start()
      machine.wait_for_unit("icosa-gallery.service")
      machine.wait_for_open_port(${port})
      machine.succeed("curl -v http://localhost:${port} >&2")
    '';

  # Debug interactively with:
  # - nix-build -A nixosTests.icosa-gallery.driverInteractive
  # - ./result/bin/nixos-test-driver
  # - run_tests()
  interactive.sshBackdoor.enable = true;
  interactive.nodes.machine =
    { config, ... }:
    let
      port = config.services.icosa-gallery.port;
    in
    {
      virtualisation.forwardPorts = [
        {
          from = "host";
          host.port = port;
          guest.port = port;
        }
      ];

      # forwarded ports need to be accessible
      networking.firewall.enable = false;
    };
}

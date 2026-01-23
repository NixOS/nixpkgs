{ lib, ... }:
{
  name = "komodo-periphery";
  meta = {
    maintainers = with lib.maintainers; [ channinghe ];
  };

  nodes = {
    periphery =
      { config, pkgs, ... }:
      {
        virtualisation.docker.enable = true;
        services.komodo-periphery = {
          enable = true;
          inbound.bindIp = "127.0.0.1";
          inbound.port = 8120;
          inbound.ssl.enable = false;
          inbound.serverEnabled = true;
          disableTerminals = true;
          disableContainerTerminals = true;
          statsPollingRate = "10-sec";
          containerStatsPollingRate = "1-min";
          logging.level = "debug";
          extraSettings = {
            secrets.TEST_SECRET = "test-value";
          };
          auth.privateKey = "file:/var/lib/komodo-periphery/keys/test.key";
          auth.corePublicKeys = [ "MCowBQYDK2VuAyEATZgrjGHeF0KJUe0+n77+qAWOg3YzEzXOmQWaRgO3OGQ=" ];
          outbound.coreAddress = "core.example.com";
          outbound.connectAs = "test-server";
        };
      };
  };

  testScript = ''
    start_all()

    with subtest("Periphery starts with inbound and outbound configured"):
        periphery.wait_for_unit("komodo-periphery.service")
        periphery.wait_for_open_port(8120)

    with subtest("Periphery creates managed directories"):
        periphery.succeed("test -d /var/lib/komodo-periphery")
        periphery.succeed("test -d /var/lib/komodo-periphery/repos")
        periphery.succeed("test -d /var/lib/komodo-periphery/stacks")
        periphery.succeed("test -d /var/lib/komodo-periphery/builds")
        periphery.succeed("test -d /var/lib/komodo-periphery/keys")
        periphery.succeed("test -d /var/lib/komodo-periphery/ssl")
  '';
}

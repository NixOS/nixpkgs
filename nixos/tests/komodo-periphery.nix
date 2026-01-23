{ lib, ... }:
{
  name = "komodo-periphery";
  meta = {
    maintainers = with lib.maintainers; [ channinghe ];
  };

  nodes = {
    # Test 1: Basic inbound mode with legacy passkeys (v1 compatibility)
    legacy =
      { config, pkgs, ... }:
      {
        virtualisation.docker.enable = true;
        services.komodo-periphery = {
          enable = true;
          inbound.bindIp = "127.0.0.1";
          inbound.port = 8120;
          inbound.ssl.enable = false;
          passkeys = [ "test-passkey" ];
        };
      };

    # Test 2: v2 authentication mode
    v2auth =
      { config, pkgs, ... }:
      {
        virtualisation.docker.enable = true;
        services.komodo-periphery = {
          enable = true;
          inbound.bindIp = "127.0.0.1";
          inbound.port = 8121;
          inbound.ssl.enable = false;
          auth.privateKey = "file:/var/lib/komodo-periphery/keys/test.key";
          auth.corePublicKeys = [ "MCowBQYDK2VuAyEATZgrjGHeF0KJUe0+n77+qAWOg3YzEzXOmQWaRgO3OGQ=" ];
        };
      };

    # Test 3: Outbound mode configuration
    outbound =
      { config, pkgs, ... }:
      {
        virtualisation.docker.enable = true;
        services.komodo-periphery = {
          enable = true;
          # Outbound mode - server disabled by default when coreAddress is set
          outbound.coreAddress = "core.example.com";
          outbound.connectAs = "test-server";
          # Keep inbound enabled for testing
          inbound.serverEnabled = true;
          inbound.bindIp = "127.0.0.1";
          inbound.port = 8122;
          inbound.ssl.enable = false;
        };
      };

    # Test 4: Custom configuration with extraSettings
    custom =
      { config, pkgs, ... }:
      {
        virtualisation.docker.enable = true;
        services.komodo-periphery = {
          enable = true;
          inbound.bindIp = "127.0.0.1";
          inbound.port = 8123;
          inbound.ssl.enable = false;
          disableTerminals = true;
          disableContainerTerminals = true;
          statsPollingRate = "10-sec";
          containerStatsPollingRate = "1-min";
          logging.level = "debug";
          extraSettings = {
            secrets.TEST_SECRET = "test-value";
          };
        };
      };
  };

  testScript = ''
    start_all()

    # === Test 1: Legacy mode (v1 passkeys) ===
    with subtest("Legacy mode - basic startup"):
        legacy.wait_for_unit("komodo-periphery.service")
        legacy.wait_for_open_port(8120)
        legacy.succeed("systemctl status komodo-periphery.service")

    with subtest("Legacy mode - directory structure"):
        legacy.succeed("test -d /var/lib/komodo-periphery")
        legacy.succeed("test -d /var/lib/komodo-periphery/repos")
        legacy.succeed("test -d /var/lib/komodo-periphery/stacks")
        legacy.succeed("test -d /var/lib/komodo-periphery/builds")
        legacy.succeed("test -d /var/lib/komodo-periphery/keys")
        legacy.succeed("test -d /var/lib/komodo-periphery/ssl")

    with subtest("Legacy mode - user and permissions"):
        legacy.succeed("id komodo-periphery")
        legacy.succeed("stat -c '%U' /var/lib/komodo-periphery | grep -q komodo-periphery")

    with subtest("Legacy mode - environment file with passkeys"):
        legacy.succeed("test -f /run/komodo-periphery/env")
        legacy.succeed("grep -q 'PERIPHERY_PASSKEYS' /run/komodo-periphery/env")

    # === Test 2: v2 authentication mode ===
    with subtest("v2 auth mode - startup"):
        v2auth.wait_for_unit("komodo-periphery.service")
        v2auth.wait_for_open_port(8121)

    with subtest("v2 auth mode - environment variables"):
        v2auth.succeed("test -f /run/komodo-periphery/env")
        v2auth.succeed("grep -q 'PERIPHERY_PRIVATE_KEY' /run/komodo-periphery/env")
        v2auth.succeed("grep -q 'PERIPHERY_CORE_PUBLIC_KEYS' /run/komodo-periphery/env")

    # === Test 3: Outbound mode ===
    with subtest("Outbound mode - startup with inbound enabled"):
        outbound.wait_for_unit("komodo-periphery.service")
        outbound.wait_for_open_port(8122)

    # === Test 4: Custom configuration ===
    with subtest("Custom config - startup"):
        custom.wait_for_unit("komodo-periphery.service")
        custom.wait_for_open_port(8123)

    with subtest("Custom config - verify generated config"):
        # Check that the config file contains expected values
        custom.succeed("cat /run/current-system/etc/systemd/system/komodo-periphery.service | grep -q '8123'")
  '';
}

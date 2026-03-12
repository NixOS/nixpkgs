{
  lib,
  ...
}:
{
  name = "netbird-server-management";

  meta.maintainers = with lib.maintainers; [
    shuuri-labs
  ];

  nodes = {
    management = {
      services.netbird.server.management = {
        enable = true;
        domain = "mgmt.test";
        turnDomain = "turn.test";
        port = 8011;
        metricsPort = 9090;
        logLevel = "DEBUG";
        oidcConfigEndpoint = "https://idp.test/.well-known/openid-configuration";

        settings = {
          # Use a test encryption key
          DataStoreEncryptionKey = "test-encryption-key-for-testing";
        };
      };
    };

    managementWithRelay = {
      services.netbird.server.management = {
        enable = true;
        domain = "mgmt-relay.test";
        turnDomain = "turn.test";
        port = 8011;
        metricsPort = 9090;
        oidcConfigEndpoint = "https://idp.test/.well-known/openid-configuration";

        # Configure relay
        relayAddresses = [ "rels://relay.test:443" ];
        relaySecretFile = "/run/secrets/relay-secret";

        settings = {
          DataStoreEncryptionKey = "test-encryption-key-for-testing";
        };
      };

      # Create a test secret file
      systemd.services.netbird-management.preStart = lib.mkBefore ''
        mkdir -p /run/secrets
        echo "test-relay-secret" > /run/secrets/relay-secret
      '';
    };

    managementWithPostgres = {
      services.netbird.server.management = {
        enable = true;
        domain = "mgmt-pg.test";
        turnDomain = "turn.test";
        port = 8011;
        metricsPort = 9090;
        oidcConfigEndpoint = "https://idp.test/.well-known/openid-configuration";

        store = {
          engine = "postgres";
          postgres.dsnFile = "/run/secrets/postgres-dsn";
        };

        settings = {
          DataStoreEncryptionKey = "test-encryption-key-for-testing";
        };
      };

      services.postgresql = {
        enable = true;
        ensureDatabases = [ "netbird" ];
        ensureUsers = [
          {
            name = "netbird";
            ensureDBOwnership = true;
          }
        ];
      };

      systemd.services.netbird-management = {
        after = [ "postgresql.service" ];
        requires = [ "postgresql.service" ];
        preStart = lib.mkBefore ''
          mkdir -p /run/secrets
          echo "postgres://netbird@localhost/netbird?sslmode=disable" > /run/secrets/postgres-dsn
        '';
      };
    };
  };

  testScript = ''
    start_all()

    # Test basic management server
    management.wait_for_unit("netbird-management.service")
    management.wait_for_open_port(8011)
    management.wait_for_open_port(9090)

    # Verify state directory exists
    management.succeed("test -d /var/lib/netbird-mgmt")
    management.succeed("test -d /var/lib/netbird-mgmt/data")

    # Verify config file was generated
    management.succeed("test -f /var/lib/netbird-mgmt/management.json")

    # Test management with relay configuration
    managementWithRelay.wait_for_unit("netbird-management.service")
    managementWithRelay.wait_for_open_port(8011)

    # Verify relay config is in the generated config
    managementWithRelay.succeed("grep -q 'Relay' /var/lib/netbird-mgmt/management.json")
    managementWithRelay.succeed("grep -q 'rels://relay.test:443' /var/lib/netbird-mgmt/management.json")

    # Test management with PostgreSQL
    managementWithPostgres.wait_for_unit("postgresql.service")
    managementWithPostgres.wait_for_unit("netbird-management.service")
    managementWithPostgres.wait_for_open_port(8011)

    # Verify postgres engine is in config
    managementWithPostgres.succeed("grep -q 'postgres' /var/lib/netbird-mgmt/management.json")
  '';
}

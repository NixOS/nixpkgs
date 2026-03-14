{ pkgs, lib, ... }:

let
  adminPasswordFile = pkgs.writeText "admin-password" "test-admin-password";
in
{
  name = "terminusdb";
  meta.maintainers = with lib.maintainers; [ daniel-fahey ];

  nodes = {
    # Default configuration node
    machine =
      { config, pkgs, ... }:
      {
        services.terminusdb = {
          enable = true;
        };
      };

    # Custom configuration node
    custom =
      { config, pkgs, ... }:
      {
        services.terminusdb = {
          enable = true;
          host = "0.0.0.0";
          port = 7373;
          workers = 4;
          logLevel = "debug";
          logFormat = "json";
        };
      };

    # JWT configuration node
    jwt =
      { config, pkgs, ... }:
      {
        services.terminusdb = {
          enable = true;
          jwtEnabled = true;
        };
      };

    # Admin password node
    admin =
      { config, pkgs, ... }:
      {
        services.terminusdb = {
          enable = true;
          adminPasswordFile = adminPasswordFile;
        };
      };
  };

  testScript = ''
    import json


    def assert_contains(haystack, needle):
        if needle not in haystack:
            print("The haystack that will cause the following exception is:")
            print("---")
            print(haystack)
            print("---")
            raise Exception(f"Expected string '{needle}' was not found")


    def assert_lacks(haystack, needle):
        if needle in haystack:
            print("The haystack that will cause the following exception is:")
            print("---")
            print(haystack, end="")
            print("---")
            raise Exception(f"Unexpected string '{needle}' was found")


    start_all()

    # Test 1: Basic service startup on default machine
    with subtest("service starts on default machine"):
        machine.wait_for_unit("terminusdb.service")
        machine.wait_for_open_port(6363)
        machine.succeed("systemctl is-active terminusdb.service")


    # Test 2: API connectivity
    with subtest("api info endpoint works"):
        # Check that endpoint returns valid JSON
        resp = json.loads(machine.succeed("curl --fail --silent http://localhost:6363/api/info"))
        # API should return a JSON object with TerminusDB metadata
        assert isinstance(resp, dict), "API response should be a JSON object"


    # Test 3: Data directory ownership and structure
    with subtest("data directory is correctly set up"):
        machine.succeed("test -d /var/lib/terminusdb")
        # Verify ownership is correct
        stat = machine.succeed("stat -c '%U %G' /var/lib/terminusdb")
        assert_contains(stat, "terminusdb terminusdb")


    # Test 4: Custom configuration
    with subtest("custom configuration is applied"):
        custom.wait_for_unit("terminusdb.service")
        custom.wait_for_open_port(7373)
        # Verify custom port works and API returns valid JSON
        resp = json.loads(custom.succeed("curl --fail --silent http://localhost:7373/api/info"))
        assert isinstance(resp, dict), "API response should be a JSON object"
        # Verify custom configuration is reflected
        env = custom.succeed("systemctl show terminusdb.service")
        assert_contains(env, "TERMINUSDB_SERVER_PORT=7373")
        assert_contains(env, "TERMINUSDB_LOG_LEVEL=debug")
        assert_contains(env, "TERMINUSDB_LOG_FORMAT=json")


    # Test 5: JWT configuration
    with subtest("jwt configuration is applied"):
        jwt.wait_for_unit("terminusdb.service")
        # Check that JWT env vars are set in the service
        jwt_env = jwt.succeed("systemctl show terminusdb.service")
        assert_contains(jwt_env, "TERMINUSDB_JWT_ENABLED=true")


    # Test 6: Admin password file
    with subtest("admin password file is used"):
        admin.wait_for_unit("terminusdb.service")
        # Service should start successfully with the admin password file
        # Verify API still works with password configured
        resp = json.loads(admin.succeed("curl --fail --silent http://localhost:6363/api/info"))
        assert isinstance(resp, dict), "API response should be a JSON object with admin password configured"


    # Test 7: Environment variables are set correctly
    with subtest("environment variables are set"):
        # Check that critical env vars are set
        env = machine.succeed("systemctl show terminusdb.service")
        assert_contains(env, "TERMINUSDB_SERVER_PORT=6363")
        assert_contains(env, "TERMINUSDB_LOG_LEVEL=info")
        assert_contains(env, "TERMINUSDB_LOG_FORMAT=text")
        # Ensure default env var for file storage is NOT set
        assert_lacks(env, "TERMINUSDB_FILE_STORAGE_PATH=")


    # Test 8: systemd hardening options
    with subtest("systemd hardening is applied"):
        # Get full service configuration
        systemd_config = machine.succeed("systemctl show terminusdb.service")
        # Check key security options that should be visible
        assert_contains(systemd_config, "ProtectSystem=strict")
        assert_contains(systemd_config, "NoNewPrivileges=yes")


    # Test 9: Service restart recovery
    with subtest("service restarts successfully"):
        machine.wait_for_unit("terminusdb.service")
        machine.succeed("systemctl restart terminusdb.service")
        machine.wait_for_unit("terminusdb.service")
        machine.wait_for_open_port(6363)
        # Verify API still returns valid JSON after restart
        resp = json.loads(machine.succeed("curl --fail --silent http://localhost:6363/api/info"))
        assert isinstance(resp, dict), "API response should be a JSON object after restart"


    # Test 10: User and group setup
    with subtest("user and group are correctly configured"):
        # Verify user and group exist with correct names
        passwd = machine.succeed("getent passwd terminusdb")
        assert_contains(passwd, "terminusdb:x:")
        group = machine.succeed("getent group terminusdb")
        assert_contains(group, "terminusdb:x:")
        # Verify user can be queried
        machine.succeed("id terminusdb")


    # Test 11: Invalid API endpoint handling
    with subtest("invalid endpoints are rejected"):
        # Test that invalid endpoints return errors (404, 400, etc)
        machine.fail("curl --fail --silent http://localhost:6363/api/invalid-endpoint")


    # Test 12: Password security - not logged
    with subtest("admin password is not logged"):
        # Verify that password is not visible in logs
        admin.fail("journalctl --since -5m --unit terminusdb.service --grep 'test-admin-password'")


    print("=== All TerminusDB tests passed ===")
  '';
}

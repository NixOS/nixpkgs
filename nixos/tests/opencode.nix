{ lib, ... }:
let
  # Both of these are written to /etc like an agenix or sops secret would be.
  # What the test cares about is that a path, and not a literal, is what reaches
  # the unit.
  filePassword = "sekrit";
  literalPassword = "hunter2";
in
{
  name = "opencode";
  meta.maintainers = with lib.maintainers; [ gerrydoro ];

  nodes = {
    server =
      { ... }:
      {
        services.opencode.servers = {
          default = {
            enable = true;
            port = 4096;
            logLevel = "debug";
            settings.model = "anthropic/claude-sonnet-4-20250514";
            authentication.passwordFile = "/etc/opencode-default-password";
          };

          # A second instance, to show the module is per-instance rather than
          # global: same package, different port, unit, user and password. This
          # one takes the password literally, which is the mode that bakes the
          # secret into a store path.
          plain = {
            enable = true;
            port = 4097;
            authentication.password = literalPassword;
          };

          disabled.enable = false;
        };

        environment.etc = {
          "opencode-default-password".text = filePassword;
          "opencode-plain-password".text = literalPassword;
        };
      };

    # The identity rule: naming a user hands both the user and the group back
    # to the caller, so the module creates neither.
    customUser =
      { ... }:
      {
        services.opencode.servers.custom = {
          enable = true;
          port = 4098;
          user = "opencode-user";
          group = "opencode-group";
          authentication.passwordFile = "/etc/opencode-custom-password";
        };

        users.users.opencode-user = {
          isSystemUser = true;
          group = "opencode-group";
        };
        users.groups.opencode-group = { };

        environment.etc."opencode-custom-password".text = "sekrit";
      };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("opencode-default.service")
    server.wait_for_unit("opencode-plain.service")
    server.wait_for_open_port(4096)
    server.wait_for_open_port(4097)

    with subtest("only enabled instances produce a unit"):
        server.fail("systemctl status opencode-disabled.service")

    with subtest("the secret does not reach the unit file"):
        for service, password in [
            ("opencode-default", "${filePassword}"),
            ("opencode-plain", "${literalPassword}"),
        ]:
            unit = server.succeed(f"systemctl cat {service}")
            assert password not in unit, f"the password is written into {service}"

        server.succeed(
            "grep -q 'LoadCredential=opencode-password:/etc/opencode-default-password'"
            " /etc/systemd/system/opencode-default.service"
        )
        # A literal password needs no credential: the wrapper reads it from the
        # store path it is baked into.
        server.succeed("grep -qv LoadCredential /etc/systemd/system/opencode-plain.service")

    with subtest("the server is protected by basic auth"):
        code = server.succeed(
            "curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:4096/api/session"
        )
        assert code == "401", f"unauthenticated request got {code}, expected 401"

        code = server.succeed(
            "curl -s -o /dev/null -w '%{http_code}' -u opencode:${filePassword}"
            " http://127.0.0.1:4096/api/session"
        )
        assert code == "200", f"authenticated request got {code}, expected 200"

        # The username is not configurable: opencode 2.x fixed it to "opencode".
        code = server.succeed(
            "curl -s -o /dev/null -w '%{http_code}' -u alice:${filePassword}"
            " http://127.0.0.1:4096/api/session"
        )
        assert code == "401", f"wrong username got {code}, expected 401"

        code = server.succeed(
            "curl -s -o /dev/null -w '%{http_code}' -u opencode:wrong"
            " http://127.0.0.1:4096/api/session"
        )
        assert code == "401", f"wrong password got {code}, expected 401"

    with subtest("both password modes work"):
        body = server.succeed(
            "curl -s -u opencode:${literalPassword} http://127.0.0.1:4097/api/session"
        )
        assert '"data"' in body, body

    with subtest("settings are written where opencode looks for them"):
        config = server.succeed("cat /etc/opencode-default/opencode/opencode.jsonc")
        assert "claude-sonnet-4-20250514" in config, config

        # With no settings there is nothing to place, so no file and no
        # XDG_CONFIG_HOME override appear for that instance.
        server.fail("test -f /etc/opencode-plain/opencode/opencode.jsonc")
        server.succeed("grep -qv XDG_CONFIG_HOME /etc/systemd/system/opencode-plain.service")

    with subtest("the argument list reaches the unit verbatim"):
        # ExecStart points at the credential wrapper; the command line it runs
        # is inside that script, so read it there. 2.x vocabulary, lower case.
        unit = server.succeed("cat /etc/systemd/system/opencode-default.service")
        wrapper = [
            line
            for line in unit.splitlines()
            if line.startswith("ExecStart=")
        ][0][len("ExecStart=") :].strip()
        command = server.succeed(f"cat {wrapper}")
        assert "serve --port 4096 --hostname 127.0.0.1 --log-level debug" in command, command

    with subtest("the database lives in the state directory"):
        server.succeed("test -f /var/lib/opencode-default/opencode/opencode.db")
        server.succeed("test -f /var/lib/opencode-plain/opencode/opencode.db")

    customUser.wait_for_unit("opencode-custom.service")
    customUser.wait_for_open_port(4098)

    with subtest("a named user disables the module's identity management"):
        customUser.succeed("id opencode-user")
        # The module must not have created a user or a group of its own.
        customUser.fail("getent passwd opencode-custom")
        customUser.fail("getent group opencode-custom")
        assert (
            customUser.succeed("systemctl show -p User --value opencode-custom.service").strip()
            == "opencode-user"
        )
        assert (
            customUser.succeed("systemctl show -p Group --value opencode-custom.service").strip()
            == "opencode-group"
        )
        customUser.succeed(
            "curl -s -o /dev/null -w '%{http_code}' -u opencode:sekrit"
            " http://127.0.0.1:4098/api/session | grep 200"
        )
  '';
}

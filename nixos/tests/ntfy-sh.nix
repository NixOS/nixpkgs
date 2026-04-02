import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "ntfy-sh";

    nodes.machine =
      { ... }:
      {
        services.ntfy-sh.enable = true;
        services.ntfy-sh.settings.base-url = "http://localhost:2586";

        # Create a user with user:123
        services.ntfy-sh.environmentFile = pkgs.writeText "ntfy.env" ''
          NTFY_AUTH_DEFAULT_ACCESS='deny-all'
          NTFY_AUTH_USERS='user:$2a$12$W2v7IQhkayvJOYRpg6YEruxj.jUO3R2xQOU7s1vC3HzLLB9gSKJ9.:user'
          NTFY_AUTH_ACCESS='user:test:rw'
        '';
      };

    testScript = ''
      import json

      msg = "Test notification"

      machine.wait_for_unit("multi-user.target")

      machine.wait_for_open_port(2586)

      machine.succeed(f"curl -u user:1234 -d '{msg}' localhost:2586/test")

      # If we have a user, receive a message
      notif = json.loads(machine.succeed("curl -u user:1234 -s localhost:2586/test/json?poll=1"))
      assert msg == notif["message"], "Wrong message"

      # If we have no user, we should get forbidden, making sure the default access config works
      notif = json.loads(machine.succeed("curl -s localhost:2586/test/json?poll=1"))
      assert 403 == notif["http"], f"Should return 403, got {notif["http"]}"

      machine.succeed("ntfy user list")
    '';
  }
)

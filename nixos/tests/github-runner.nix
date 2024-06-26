import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "github-runner";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ veehaitch ];
    };
    nodes.machine =
      { pkgs, ... }:
      {
        services.github-runners.test = {
          enable = true;
          url = "https://github.com/yaxitech";
          tokenFile = builtins.toFile "github-runner.token" "not-so-secret";
        };

        systemd.services.dummy-github-com = {
          wantedBy = [ "multi-user.target" ];
          before = [ "github-runner-test.service" ];
          script = "${pkgs.netcat}/bin/nc -Fl 443 | true && touch /tmp/registration-connect";
        };
        networking.hosts."127.0.0.1" = [ "api.github.com" ];
      };

    testScript = ''
      start_all()

      machine.wait_for_unit("dummy-github-com")

      try:
        machine.wait_for_unit("github-runner-test")
      except Exception:
        pass

      out = machine.succeed("journalctl -u github-runner-test")
      assert "Self-hosted runner registration" in out, "did not read runner registration header"

      machine.wait_until_succeeds("test -f /tmp/registration-connect")
    '';
  }
)

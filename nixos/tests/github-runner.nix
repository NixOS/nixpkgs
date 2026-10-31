{ pkgs, ... }:
{
  name = "github-runner";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ veehaitch ];
  };
  nodes.machine =
    { pkgs, ... }:
    let
      appPrivateKey = pkgs.runCommand "github-app.pem" {
        nativeBuildInputs = [ pkgs.openssl ];
      } "openssl genrsa -out $out 2048";
    in
    {
      services.github-runners.test = {
        enable = true;
        url = "https://github.com/yaxitech";
        tokenFile = builtins.toFile "github-runner.token" "not-so-secret";
      };

      services.github-runners.test-disabled = {
        enable = false;
        url = "https://github.com/yaxitech";
        tokenFile = builtins.toFile "github-runner.token" "not-so-secret";
      };

      # Runner authenticated via a GitHub App installation. This exercises the
      # module evaluation and the App authentication code path up to the point it
      # contacts the (stubbed) GitHub API; a successful registration would
      # require talking to the real API.
      services.github-runners.test-app = {
        enable = true;
        url = "https://github.com/yaxitech";
        githubApp = {
          id = 123456;
          login = "yaxitech";
          privateKeyFile = appPrivateKey;
        };
      };

      # A GitHub App runner that keeps its registration across restarts. Not
      # started at boot: the test seeds its state directory first.
      services.github-runners.test-app-reuse = {
        enable = true;
        url = "https://github.com/yaxitech";
        githubApp = {
          id = 123456;
          login = "yaxitech";
          privateKeyFile = appPrivateKey;
          reuseRegistration = true;
        };
      };
      systemd.services.github-runner-test-app-reuse.wantedBy = pkgs.lib.mkForce [ ];

      # A single org/repo entry with `count > 1` fans out into one systemd
      # service per replica, named `github-runner-<name>-<n>`.
      services.github-runners.test-replicas = {
        enable = true;
        url = "https://github.com/yaxitech";
        tokenFile = builtins.toFile "github-runner.token" "not-so-secret";
        count = 2;
      };

      # A single entry with `orgs` fans out into one systemd service per org and
      # per replica, named `github-runner-<name>-<org>-<n>`.
      services.github-runners.test-orgs = {
        enable = true;
        tokenFile = builtins.toFile "github-runner.token" "not-so-secret";
        orgs = {
          yaxitech.count = 2;
          another = { };
        };
      };

      # `orgs` combined with a shared GitHub App: the same App is used for every
      # org and only the per-org `login` changes (derived from the attribute
      # name), so no entry-level `githubApp.login` is needed.
      services.github-runners.test-orgs-app = {
        enable = true;
        githubApp = {
          id = 123456;
          privateKeyFile = appPrivateKey;
        };
        orgs = {
          yaxitech = { };
          "another-org" = { };
        };
      };

      systemd.services.dummy-github-com = {
        wantedBy = [ "multi-user.target" ];
        before = [ "github-runner-test.service" ];
        script = "${pkgs.netcat}/bin/nc -Fl 443 | true && touch /tmp/registration-connect";
      };
      networking.hosts."127.0.0.1" = [ "api.github.com" ];
    };

  testScript = ''
    import re

    start_all()

    machine.wait_for_unit("dummy-github-com")

    try:
      machine.wait_for_unit("github-runner-test")
    except Exception:
      pass

    out = machine.succeed("journalctl -u github-runner-test")
    assert "Self-hosted runner registration" in out, "did not read runner registration header"

    machine.wait_until_succeeds("test -f /tmp/registration-connect")

    # The GitHub App runner unit is generated and wired to the App auth path.
    machine.succeed("systemctl cat github-runner-test-app.service | grep -F unconfigure-github-app")

    # A reused App registration skips the API and the registration, and a failed
    # run drops its credentials so the next start registers again.
    unit = machine.succeed("systemctl cat github-runner-test-app-reuse.service")
    assert "drop-failed-registration" in unit, "reusing runner must not de-register on stop"
    assert "unregister-github-app" not in unit, "reusing runner must not de-register on stop"
    match = re.search(r"/nix/store/\S+-configure(?:\.sh)?", unit)
    assert match is not None, "configure script not found in the unit"
    configure = match.group(0)
    config = machine.succeed(f"grep -o \"ln -s '[^']*'\" {configure} | cut -d\\' -f2").strip()
    state = "/var/lib/github-runner/test-app-reuse"
    machine.succeed(
      f"mkdir -p {state}",
      f"for f in .credentials .credentials_rsaparams .runner; do echo '{{}}' > {state}/$f; done",
      f"ln -sfn {config} {state}/.nixos-current-config.json",
      f"touch {state}/.current-token",
    )
    machine.succeed("systemctl start github-runner-test-app-reuse.service || true")
    machine.wait_until_succeeds(
      "journalctl -u github-runner-test-app-reuse | grep -F 'Reusing the existing runner registration.'"
    )
    machine.wait_until_succeeds(f"! test -e {state}/.runner")

    # A start an ExecCondition= skips (e.g. a deliberate drain) keeps the
    # registration.
    machine.succeed(
      f"for f in .credentials .credentials_rsaparams .runner; do echo '{{}}' > {state}/$f; done",
      "mkdir -p /run/systemd/system/github-runner-test-app-reuse.service.d",
      "printf '[Service]\\nExecCondition=+/run/current-system/sw/bin/false\\n' > /run/systemd/system/github-runner-test-app-reuse.service.d/skip.conf",
      "systemctl daemon-reload",
    )
    machine.succeed("systemctl start github-runner-test-app-reuse.service || true")
    machine.wait_until_succeeds(
      "journalctl -u github-runner-test-app-reuse | grep -F \"Skipped due to 'exec-condition'\""
    )
    machine.succeed(f"test -e {state}/.runner")

    # `count > 1` on a single entry fans out into one unit per replica with a
    # `-<n>` suffix; there is no bare unit.
    machine.succeed("systemctl cat github-runner-test-replicas-1.service")
    machine.succeed("systemctl cat github-runner-test-replicas-2.service")
    machine.fail("systemctl cat github-runner-test-replicas.service")

    # `orgs` fans out into one unit per org and replica; there is no bare unit.
    machine.succeed("systemctl cat github-runner-test-orgs-yaxitech-1.service")
    machine.succeed("systemctl cat github-runner-test-orgs-yaxitech-2.service")
    machine.succeed("systemctl cat github-runner-test-orgs-another-1.service")
    machine.fail("systemctl cat github-runner-test-orgs.service")

    # `orgs` with a shared GitHub App generates one App-authenticated unit per
    # org, each with its per-org login derived from the attribute name.
    machine.succeed("systemctl cat github-runner-test-orgs-app-yaxitech-1.service | grep -F unconfigure-github-app")
    machine.succeed("systemctl cat github-runner-test-orgs-app-another-org-1.service | grep -F unconfigure-github-app")

    machine.fail("systemctl list-unit-files | grep test-disabled")
  '';
}

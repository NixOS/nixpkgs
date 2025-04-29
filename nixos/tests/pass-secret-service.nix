import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "pass-secret-service";
    meta.maintainers = [ lib.maintainers.aidalgol ];

    nodes.machine =
      { nodes, pkgs, ... }:
      {
        imports = [ ./common/user-account.nix ];

        services.passSecretService.enable = true;

        environment.systemPackages = [
          # Create a script that tries to make a request to the D-Bus secrets API.
          (pkgs.writers.writePython3Bin "secrets-dbus-init"
            {
              libraries = [ pkgs.python3Packages.secretstorage ];
            }
            ''
              import secretstorage
              print("Initializing dbus connection...")
              connection = secretstorage.dbus_init()
              print("Requesting default collection...")
              collection = secretstorage.get_default_collection(connection)
              print("Done!  dbus-org.freedesktop.secrets should now be active.")
            ''
          )
          pkgs.pass
        ];

        programs.gnupg = {
          agent.enable = true;
          dirmngr.enable = true;
        };
      };

    # Some of the commands are run via a virtual console because they need to be
    # run under a real login session, with D-Bus running in the environment.
    testScript =
      { nodes, ... }:
      let
        user = nodes.machine.config.users.users.alice;
        gpg-uid = "alice@example.net";
        gpg-pw = "foobar9000";
        ready-file = "/tmp/secrets-dbus-init.done";
      in
      ''
        # Initialise the pass(1) storage.
        machine.succeed("""
          sudo -u alice gpg --pinentry-mode loopback --batch --passphrase ${gpg-pw} \
          --quick-gen-key ${gpg-uid} \
        """)
        machine.succeed("sudo -u alice pass init ${gpg-uid}")

        with subtest("Service is not running on login"):
            machine.wait_until_tty_matches("1", "login: ")
            machine.send_chars("alice\n")
            machine.wait_until_tty_matches("1", "login: alice")
            machine.wait_until_succeeds("pgrep login")
            machine.wait_until_tty_matches("1", "Password: ")
            machine.send_chars("${user.password}\n")
            machine.wait_until_succeeds("pgrep -u alice bash")

            _, output = machine.systemctl("status dbus-org.freedesktop.secrets --no-pager", "alice")
            assert "Active: inactive (dead)" in output

        with subtest("Service starts after a client tries to talk to the D-Bus API"):
            machine.send_chars("secrets-dbus-init; touch ${ready-file}\n")
            machine.wait_for_file("${ready-file}")
            _, output = machine.systemctl("status dbus-org.freedesktop.secrets --no-pager", "alice")
            assert "Active: active (running)" in output
      '';
  }
)

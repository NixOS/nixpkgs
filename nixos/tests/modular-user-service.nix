{
  _class = "nixosTest";
  name = "modular-user-service";

  nodes.machine =
    { pkgs, ... }:
    {
      users.users.alice = {
        isNormalUser = true;
        password = "alice";
        services.hello = {
          process.argv = [
            "${pkgs.coreutils}/bin/sleep"
            "infinity"
          ];
        };
      };

      system.stateVersion = "26.05";
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    # Enable linger so alice's user systemd instance starts without interactive login.
    machine.succeed("loginctl enable-linger alice")

    # Wait for alice's user systemd instance to come up.
    machine.wait_until_succeeds(
      "systemctl --user --machine=alice@ is-active basic.target", timeout=30
    )

    # The per-user profile exposes the local unit name via share/systemd/user/.
    # systemd discovers it through $XDG_DATA_DIRS.
    machine.succeed(
      "test -L /etc/profiles/per-user/alice/share/systemd/user/hello.service"
    )
    machine.succeed(
      "test -L /etc/profiles/per-user/alice/share/systemd/user/default.target.wants/hello.service"
    )

    # The profile symlink targets the global (prefixed) unit file.
    machine.succeed(
      "readlink /etc/profiles/per-user/alice/share/systemd/user/hello.service | grep -q alice--hello"
    )

    # hello.service should have been auto-started via default.target.wants.
    machine.wait_until_succeeds(
      "systemctl --user --machine=alice@ is-active hello.service", timeout=30
    )
  '';
}

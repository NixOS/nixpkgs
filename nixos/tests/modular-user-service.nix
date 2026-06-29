{ hostPkgs, pkgs, lib, ... }:
{
  _class = "nixosTest";
  name = "modular-user-service";

  nodes.machine =
    { pkgs, ... }:
    {
      users.users.alice = {
        isNormalUser = true;
        password = "alice";
        # A modular service that sleeps indefinitely (to test auto-start).
        services.hello = {
          process.argv = [
            "${pkgs.coreutils}/bin/sleep"
            "infinity"
          ];
        };
      };

      # Required for VM tests
      system.stateVersion = "25.05";
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

    # The activation script should have created unit symlinks for alice.
    machine.succeed("test -L /home/alice/.config/systemd/user/hello.service")
    machine.succeed("test -L /home/alice/.config/systemd/user/default.target.wants/hello.service")

    # The symlink should point to the global (prefixed) unit.
    machine.succeed(
      "readlink /home/alice/.config/systemd/user/hello.service | grep -q alice--hello"
    )

    # hello.service should have been auto-started via default.target.wants.
    machine.wait_until_succeeds(
      "systemctl --user --machine=alice@ is-active hello.service", timeout=30
    )
  '';
}

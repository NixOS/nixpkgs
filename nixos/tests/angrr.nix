{ ... }:
{
  name = "angrr";
  nodes = {
    machine = {
      services.angrr = {
        enable = true;
        period = "7d";
      };
      # `angrr.service` integrates to `nix-gc.service` by default
      nix.gc.automatic = true;

      # Create a normal nix user for test
      users.users.normal.isNormalUser = true;
      # For `nix build /run/current-system --out-link`,
      # `nix-build` does not support this use case.
      nix.settings.experimental-features = [ "nix-command" ];
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("default.target")

    machine.systemctl("stop nix-gc.timer")

    # Creates some auto gc roots
    # Use /run/current-system so that we do not need to build anything new
    machine.succeed("nix build /run/current-system --out-link /tmp/root-auto-gc-root-1")
    machine.succeed("nix build /run/current-system --out-link /tmp/root-auto-gc-root-2")
    machine.succeed("su normal --command 'nix build /run/current-system --out-link /tmp/user-auto-gc-root-1'")
    machine.succeed("su normal --command 'nix build /run/current-system --out-link /tmp/user-auto-gc-root-2'")

    machine.systemctl("start nix-gc.service")
    # Not auto gc root will be removed
    machine.succeed("readlink /tmp/root-auto-gc-root-1")
    machine.succeed("readlink /tmp/root-auto-gc-root-2")
    machine.succeed("readlink /tmp/user-auto-gc-root-1")
    machine.succeed("readlink /tmp/user-auto-gc-root-2")

    # Change time to 8 days after (greater than 7d)
    machine.succeed("date -s '8 days'")

    # Touch GC roots `-2`
    machine.succeed("touch /tmp/root-auto-gc-root-2 --no-dereference")
    machine.succeed("touch /tmp/user-auto-gc-root-2 --no-dereference")

    machine.systemctl("start nix-gc.service")
    # Only GC roots `-1` are removed
    machine.succeed("test ! -f /tmp/root-auto-gc-root-1")
    machine.succeed("readlink  /tmp/root-auto-gc-root-2")
    machine.succeed("test ! -f /tmp/user-auto-gc-root-1")
    machine.succeed("readlink  /tmp/user-auto-gc-root-2")

    # Change time again
    machine.succeed("date -s '8 days'")
    machine.systemctl("start nix-gc.service")
    # All auto GC roots are removed
    machine.succeed("test ! -f /tmp/root-auto-gc-root-2")
    machine.succeed("test ! -f /tmp/user-auto-gc-root-2")
  '';
}

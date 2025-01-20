{
  system ? builtins.currentSystem,
  pkgs ? import ../.. {
    inherit system;
    config = { };
    overlays = [ ];
  },
  ...
}@args:

with import ../lib/testing-python.nix { inherit system pkgs; };

{
  systemd-user-linger-setup = makeTest rec {
    name = "systemd-user-linger-setup";

    nodes.machine = {
      users.users = {
        alice = {
          isNormalUser = true;
          linger = true;
          uid = 1000;
        };

        bob = {
          isNormalUser = true;
          linger = false;
          uid = 1001;
        };
      };
    };

    testScript =
      let
        uidStrings = builtins.mapAttrs (k: v: builtins.toString v.uid) nodes.machine.users.users;
      in
      ''
        machine.wait_for_file("/var/lib/systemd/linger/alice")
        machine.succeed("systemctl status user-${uidStrings.alice}.slice")

        machine.fail("test -e /var/lib/systemd/linger/bob")
        machine.fail("systemctl status user-${uidStrings.bob}.slice")
      '';
  };

  systemd-user-linger-cleanup = makeTest {
    name = "systemd-user-linger-cleanup";

    nodes.machine = { };

    testScript = ''
      machine.succeed("touch /var/lib/systemd/linger/missing")
      machine.systemctl("restart linger-users")
      machine.succeed("test ! -e /var/lib/systemd/linger/missing")
    '';
  };
}

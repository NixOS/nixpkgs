# This test checks #418101, where lingering users would not be cleared up if
# the configuration is updated to remove lingering from all users.
rec {
  name = "systemd-user-linger-purge";

  nodes.machine = {
    users.users = {
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
      machine.fail("test -e /var/lib/systemd/linger/bob")
      machine.fail("systemctl status user-${uidStrings.bob}.slice")

      with subtest("missing users have linger purged"):
          machine.succeed("touch /var/lib/systemd/linger/alice")
          machine.systemctl("restart linger-users")
          machine.succeed("test ! -e /var/lib/systemd/linger/alice")

      with subtest("mutable users can linger"):
          machine.succeed("useradd alice")
          machine.succeed("test ! -e /var/lib/systemd/linger/alice")
          machine.succeed("loginctl enable-linger alice")
          machine.succeed("test -e /var/lib/systemd/linger/alice")
          machine.systemctl("restart linger-users")
          machine.succeed("test -e /var/lib/systemd/linger/alice")
    '';
}

rec {
  name = "systemd-user-linger";

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

      with subtest("mutable users can linger"):
          machine.succeed("useradd clare")
          machine.succeed("test ! -e /var/lib/systemd/linger/clare")
          machine.succeed("loginctl enable-linger clare")
          machine.succeed("test -e /var/lib/systemd/linger/clare")
          machine.systemctl("restart linger-users")
          machine.succeed("test -e /var/lib/systemd/linger/clare")
    '';
}

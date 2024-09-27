{
  lib,
  pkgs ? import ../..,
  ...
}:
let
  password = "test";
  password1 = "test1";
  hashedPassword = "$y$j9T$wLgKY231.8j.ciV2MfEXe1$P0k5j3bCwHgnwW0Ive3w4knrgpiA4TzhCYLAnHvDZ51"; # test
  hashedPassword1 = "$y$j9T$s8TyQJtNImvobhGM5Nlez0$3E8/O8EVGuA4sr1OQmrzi8GrRcy/AEhj454JjAn72A2"; # test
  hashed_sha512crypt = "$6$ymzs8WINZ5wGwQcV$VC2S0cQiX8NVukOLymysTPn4v1zJoJp3NGyhnqyv/dAf4NWZsBWYveQcj6gEJr4ZUjRBRjM0Pj1L8TCQ8hUUp0"; # meow

  hashedPasswordFile = pkgs.writeText "hashed-password" hashedPassword1;
in
{
  name = "systemd-sysusers-password-option-override-ordering";

  meta.maintainers = with lib.maintainers; [ fidgetingbits ];

  nodes.machine = {
    systemd.sysusers.enable = true;
    system.etc.overlay.enable = true;
    boot.initrd.systemd.enable = true;

    users.mutableUsers = true;

    # NOTE: Below given A -> B it implies B overrides A . Each entry below builds off the next

    users.users.root = {
      hashedPasswordFile = lib.mkForce null;
      initialHashedPassword = password;
    };

    # initialPassword -> initialHashedPassword
    users.users.alice = {
      isNormalUser = true;
      initialPassword = password;
      initialHashedPassword = hashedPassword;
    };

    # initialPassword -> initialHashedPassword -> hashedPasswordFile
    users.users.bob = {
      isNormalUser = true;
      initialPassword = password;
      initialHashedPassword = hashedPassword;
      hashedPasswordFile = hashedPasswordFile.outPath;
    };

    # Show that initialPassword -> password is not true for systemd-sysusers
    users.users.cat = {
      isNormalUser = true;
      initialPassword = password;
      password = password1; # We expect this not to override
    };
    # Show that initialPassword -> password is not true for systemd-sysusers
    users.users.dan = {
      isNormalUser = true;
      initialHashedPassword = hashedPassword;
      hashedPassword = hashed_sha512crypt; # We expect this not to override
    };
  };

  testScript = ''
    machine.wait_for_unit("systemd-sysusers.service")

    with subtest("systemd-sysusers.service contains the credentials"):
      sysusers_service = machine.succeed("systemctl cat systemd-sysusers.service")
      print(sysusers_service)
      assert "SetCredential=passwd.plaintext-password.alice:${password}" in sysusers_service

    with subtest("Correct mode on the password files"):
      assert machine.succeed("stat -c '%a' /etc/passwd") == "644\n"
      assert machine.succeed("stat -c '%a' /etc/group") == "644\n"
      assert machine.succeed("stat -c '%a' /etc/shadow") == "0\n"
      assert machine.succeed("stat -c '%a' /etc/gshadow") == "0\n"

    with subtest("alice user has correct password"):
      print(machine.succeed("getent passwd alice"))
      assert "${hashedPassword}" in machine.succeed("getent shadow alice"), "alice user password is not correct"

    with subtest("bob user has new password after switching to new generation"):
        print(machine.succeed("getent passwd bob"))
        print(machine.succeed("getent shadow bob"))
        assert "${hashedPassword1}" in machine.succeed("getent shadow bob"), "bob user password is not correct"

    machine.wait_for_unit("multi-user.target")
    machine.wait_until_succeeds("pgrep -f 'agetty.*tty1'")

    with subtest("Test initialPassword override"):
        machine.send_key("alt-f2")
        machine.wait_until_succeeds("[ $(fgconsole) = 2 ]")
        machine.wait_for_unit("getty@tty2.service")
        machine.wait_until_succeeds("pgrep -f 'agetty.*tty2'")
        machine.wait_until_tty_matches("2", "login: ")
        machine.send_chars("cat\n")
        machine.wait_until_tty_matches("2", "login: cat")
        machine.wait_until_succeeds("pgrep login")
        machine.sleep(2)
        machine.send_chars("${password}\n")
        machine.send_chars("whoami > /tmp/1\n")
        machine.wait_for_file("/tmp/1")
        assert "cat" in machine.succeed("cat /tmp/1")

    with subtest("Test initialHashedPassword override"):
          machine.send_key("alt-f3")
          machine.wait_until_succeeds("[ $(fgconsole) = 3 ]")
          machine.wait_for_unit("getty@tty3.service")
          machine.wait_until_succeeds("pgrep -f 'agetty.*tty3'")
          machine.wait_until_tty_matches("3", "login: ")
          machine.send_chars("dan\n")
          machine.wait_until_tty_matches("3", "login: dan")
          machine.wait_until_succeeds("pgrep login")
          machine.sleep(2)
          machine.send_chars("test\n")
          machine.send_chars("whoami > /tmp/3\n")
          machine.wait_for_file("/tmp/3")
          assert "dan" in machine.succeed("cat /tmp/3")

  '';
}

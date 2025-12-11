{
  lib,
  pkgs ? import ../..,
  ...
}:
let
  password = "test";
  hashedPassword = "$y$j9T$wLgKY231.8j.ciV2MfEXe1$P0k5j3bCwHgnwW0Ive3w4knrgpiA4TzhCYLAnHvDZ51"; # test
  hashedPassword1 = "$y$j9T$s8TyQJtNImvobhGM5Nlez0$3E8/O8EVGuA4sr1OQmrzi8GrRcy/AEhj454JjAn72A2"; # test

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

    users.groups.test = { };

    # initialPassword -> initialHashedPassword
    users.users.alice = {
      isSystemUser = true;
      group = "test";
      initialPassword = password;
      initialHashedPassword = hashedPassword;
    };

    # initialPassword -> initialHashedPassword -> hashedPasswordFile
    users.users.bob = {
      isSystemUser = true;
      group = "test";
      initialPassword = password;
      initialHashedPassword = hashedPassword;
      hashedPasswordFile = hashedPasswordFile.outPath;
    };
  };

  testScript = ''
    machine.wait_for_unit("systemd-sysusers.service")

    with subtest("systemd-sysusers.service contains the credentials"):
      sysusers_service = machine.succeed("systemctl cat systemd-sysusers.service")
      print(sysusers_service)
      # Both are in the unit, but the hashed password takes precedence as shown below.
      assert "SetCredential=passwd.plaintext-password.alice:${password}" in sysusers_service
      assert "SetCredential=passwd.hashed-password.alice:${hashedPassword}" in sysusers_service

    with subtest("Correct mode on the password files"):
      assert machine.succeed("stat -c '%a' /etc/passwd") == "644\n"
      assert machine.succeed("stat -c '%a' /etc/group") == "644\n"
      assert machine.succeed("stat -c '%a' /etc/shadow") == "0\n"
      assert machine.succeed("stat -c '%a' /etc/gshadow") == "0\n"

    with subtest("alice user has correct password"):
      print(machine.succeed("getent shadow alice"))
      assert "${hashedPassword}" in machine.succeed("getent shadow alice"), "alice user password is not correct"

    with subtest("bob user has new password after switching to new generation"):
        print(machine.succeed("getent passwd bob"))
        print(machine.succeed("getent shadow bob"))
        assert "${hashedPassword1}" in machine.succeed("getent shadow bob"), "bob user password is not correct"
  '';
}

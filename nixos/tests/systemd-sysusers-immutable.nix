{ lib, ... }:

let
  rootPassword = "$y$j9T$p6OI0WN7.rSfZBOijjRdR.$xUOA2MTcB48ac.9Oc5fz8cxwLv1mMqabnn333iOzSA6";
  normaloPassword = "$y$j9T$3aiOV/8CADAK22OK2QT3/0$67OKd50Z4qTaZ8c/eRWHLIM.o3ujtC1.n9ysmJfv639";
  newNormaloPassword = "mellow";
in

{

  name = "activation-sysusers-immutable";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine = {
    systemd.sysusers.enable = true;
    users.mutableUsers = false;

    # Override the empty root password set by the test instrumentation
    users.users.root.hashedPasswordFile = lib.mkForce null;
    users.users.root.initialHashedPassword = rootPassword;
    users.users.normalo = {
      isNormalUser = true;
      initialHashedPassword = normaloPassword;
    };

    specialisation.new-generation.configuration = {
      users.users.new-normalo = {
        isNormalUser = true;
        initialPassword = newNormaloPassword;
      };
    };
  };

  testScript = ''
    with subtest("Users are not created with systemd-sysusers"):
      machine.fail("systemctl status systemd-sysusers.service")
      machine.fail("ls /etc/sysusers.d")

    with subtest("Correct mode on the password files"):
      assert machine.succeed("stat -c '%a' /etc/passwd") == "644\n"
      assert machine.succeed("stat -c '%a' /etc/group") == "644\n"
      assert machine.succeed("stat -c '%a' /etc/shadow") == "0\n"
      assert machine.succeed("stat -c '%a' /etc/gshadow") == "0\n"

    with subtest("root user has correct password"):
      print(machine.succeed("getent passwd root"))
      assert "${rootPassword}" in machine.succeed("getent shadow root"), "root user password is not correct"

    with subtest("normalo user is created"):
      print(machine.succeed("getent passwd normalo"))
      assert machine.succeed("stat -c '%U' /home/normalo") == "normalo\n"
      assert "${normaloPassword}" in machine.succeed("getent shadow normalo"), "normalo user password is not correct"


    machine.succeed("/run/current-system/specialisation/new-generation/bin/switch-to-configuration switch")


    with subtest("new-normalo user is created after switching to new generation"):
      print(machine.succeed("getent passwd new-normalo"))
      print(machine.succeed("getent shadow new-normalo"))
      assert machine.succeed("stat -c '%U' /home/new-normalo") == "new-normalo\n"
  '';
}

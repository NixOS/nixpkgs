{ lib, ... }:

let
  rootPassword = "$y$j9T$p6OI0WN7.rSfZBOijjRdR.$xUOA2MTcB48ac.9Oc5fz8cxwLv1mMqabnn333iOzSA6";
  sysuserPassword = "$y$j9T$3aiOV/8CADAK22OK2QT3/0$67OKd50Z4qTaZ8c/eRWHLIM.o3ujtC1.n9ysmJfv639";
  newSysuserPassword = "mellow";
in

{

  name = "activation-sysusers-immutable";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine = {
    systemd.sysusers.enable = true;
    users.mutableUsers = false;


    # Read this password file at runtime from outside the Nix store.
    environment.etc."rootpw.secret".text = rootPassword;
    # Override the empty root password set by the test instrumentation.
    users.users.root.hashedPasswordFile = lib.mkForce "/etc/rootpw.secret";

    users.users.sysuser = {
      isSystemUser = true;
      group = "wheel";
      home = "/sysuser";
      initialHashedPassword = sysuserPassword;
    };

    specialisation.new-generation.configuration = {
      users.users.new-sysuser = {
        isSystemUser = true;
        group = "wheel";
        home = "/new-sysuser";
        initialPassword = newSysuserPassword;
      };
    };
  };

  testScript = ''
    with subtest("root user has correct password"):
      print(machine.succeed("getent passwd root"))
      assert "${rootPassword}" in machine.succeed("getent shadow root"), "root user password is not correct"

    with subtest("sysuser user is created"):
      print(machine.succeed("getent passwd sysuser"))
      assert machine.succeed("stat -c '%U' /sysuser") == "sysuser\n"
      assert "${sysuserPassword}" in machine.succeed("getent shadow sysuser"), "sysuser user password is not correct"

    with subtest("Fail to add new user manually"):
      machine.fail("useradd manual-sysuser")


    machine.succeed("/run/current-system/specialisation/new-generation/bin/switch-to-configuration switch")


    with subtest("new-sysuser user is created after switching to new generation"):
      print(machine.succeed("getent passwd new-sysuser"))
      assert machine.succeed("stat -c '%U' /new-sysuser") == "new-sysuser\n"
  '';
}

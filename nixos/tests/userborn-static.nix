{ lib, ... }:

let
  sysuserPassword = "$y$j9T$3aiOV/8CADAK22OK2QT3/0$67OKd50Z4qTaZ8c/eRWHLIM.o3ujtC1.n9ysmJfv639";

  common = {
    services.userborn = {
      enable = true;
      static = true;
    };
    boot.initrd.systemd.enable = true;
    networking.useNetworkd = true;
    system.etc.overlay = {
      enable = true;
      mutable = false;
    };
  };
in

{

  name = "userborn-static";

  meta.maintainers = with lib.maintainers; [
    mic92
    valpackett
  ];

  nodes.machine =
    { ... }:
    {
      imports = [ common ];

      users.users.sysuser = {
        uid = 1337;
        isSystemUser = true;
        group = "wheel";
        home = "/var/empty";
        initialHashedPassword = sysuserPassword;
      };
    };

  testScript = ''
    with subtest("Correct mode on the password files"):
      assert machine.succeed("stat -c '%a' /etc/passwd") == "644\n"
      assert machine.succeed("stat -c '%a' /etc/group") == "644\n"
      assert machine.succeed("stat -c '%a' /etc/shadow") == "0\n"

    with subtest("Check files"):
      print(machine.succeed("grpck -r"))
      print(machine.succeed("pwck -r"))

    with subtest("sysuser user is created"):
      print(machine.succeed("getent passwd sysuser"))
      assert "${sysuserPassword}" in machine.succeed("getent shadow sysuser"), "sysuser user password is not correct"
  '';
}

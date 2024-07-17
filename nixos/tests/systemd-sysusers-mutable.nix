{ lib, ... }:

let
  rootPassword = "$y$j9T$p6OI0WN7.rSfZBOijjRdR.$xUOA2MTcB48ac.9Oc5fz8cxwLv1mMqabnn333iOzSA6";
  normaloPassword = "hello";
  newNormaloPassword = "$y$j9T$p6OI0WN7.rSfZBOijjRdR.$xUOA2MTcB48ac.9Oc5fz8cxwLv1mMqabnn333iOzSA6";
in

{

  name = "activation-sysusers-mutable";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine =
    { pkgs, ... }:
    {
      systemd.sysusers.enable = true;
      users.mutableUsers = true;

      # Prerequisites
      system.etc.overlay.enable = true;
      boot.initrd.systemd.enable = true;
      boot.kernelPackages = pkgs.linuxPackages_latest;

      # Override the empty root password set by the test instrumentation
      users.users.root.hashedPasswordFile = lib.mkForce null;
      users.users.root.initialHashedPassword = rootPassword;
      users.users.normalo = {
        isNormalUser = true;
        initialPassword = normaloPassword;
      };

      specialisation.new-generation.configuration = {
        users.users.new-normalo = {
          isNormalUser = true;
          initialHashedPassword = newNormaloPassword;
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("systemd-sysusers.service")

    with subtest("systemd-sysusers.service contains the credentials"):
      sysusers_service = machine.succeed("systemctl cat systemd-sysusers.service")
      print(sysusers_service)
      assert "SetCredential=passwd.plaintext-password.normalo:${normaloPassword}" in sysusers_service

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


    machine.succeed("/run/current-system/specialisation/new-generation/bin/switch-to-configuration switch")


    with subtest("new-normalo user is created after switching to new generation"):
      print(machine.succeed("getent passwd new-normalo"))
      assert machine.succeed("stat -c '%U' /home/new-normalo") == "new-normalo\n"
      assert "${newNormaloPassword}" in machine.succeed("getent shadow new-normalo"), "new-normalo user password is not correct"
  '';
}

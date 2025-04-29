{ lib, ... }:

let
  # All passwords are "test"
  rootHashedPasswordFile = "$y$j9T$6ueoTO5y7vvFsGvpQJEEa.$vubxgBiMnkTCtRtPD3hNiZHa7Nm1WsJeE9QomYqSRXB";
  updatedRootHashedPassword = "$y$j9T$pBCO9N1FRF1rSl6V15n9n/$1JmRLEYPO7TRCx43cvLO19u59WA/oqTEhmSR4wrhzr.";

  normaloPassword = "test";
  updatedNormaloHashedPassword = "$y$j9T$IEWqhKtWg.r.8fVkSEF56.$iKNxdMC6hOAQRp6eBtYvBk4c7BGpONXeZMqc8I/LM46";

  sysuserInitialHashedPassword = "$y$j9T$Kb6jGrk41hudTZpNjazf11$iw7fZXrewC6JxRaGPz7/gPXDZ.Z1VWsupvy81Hi1XiD";
  updatedSysuserInitialHashedPassword = "$y$j9T$kUBVhgOdSjymSfwfRVja70$eqCwWzVsz0fI0Uc6JsdD2CYMCpfJcErqnIqva2JCi1D";

  newNormaloHashedPassword = "$y$j9T$UFBMWbGjjVola0YE9YCcV/$jRSi5S6lzkcifbuqjMcyXLTwgOGm9BTQk/G/jYaxroC";
in

{

  name = "userborn";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine = {
    services.userborn.enable = true;

    # Read this password file at runtime from outside the Nix store.
    environment.etc."rootpw.secret".text = rootHashedPasswordFile;

    users = {
      users = {
        root = {
          # Override the empty root password set by the test instrumentation.
          hashedPasswordFile = lib.mkForce "/etc/rootpw.secret";
        };
        normalo = {
          isNormalUser = true;
          password = normaloPassword;
        };
        sysuser = {
          isSystemUser = true;
          group = "sysusers";
          initialHashedPassword = sysuserInitialHashedPassword;
        };
      };
      groups = {
        sysusers = { };
      };
    };

    specialisation.new-generation.configuration = {
      users = {
        users = {
          root = {
            # Forcing this to null simulates removing the config value in a new
            # generation.
            hashedPasswordFile = lib.mkOverride 9 null;
            hashedPassword = updatedRootHashedPassword;
          };
          normalo = {
            hashedPassword = updatedNormaloHashedPassword;
          };
          sysuser = {
            initialHashedPassword = lib.mkForce updatedSysuserInitialHashedPassword;
          };
          new-normalo = {
            isNormalUser = true;
            hashedPassword = newNormaloHashedPassword;
          };
          normalo-disabled = {
            enable = false;
            isNormalUser = true;
          };
        };
        groups = {
          new-group = { };
        };
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("userborn.service")

    with subtest("Correct mode on the password files"):
      assert machine.succeed("stat -c '%a' /etc/passwd") == "644\n"
      assert machine.succeed("stat -c '%a' /etc/group") == "644\n"
      assert machine.succeed("stat -c '%a' /etc/shadow") == "0\n"

    with subtest("root user has correct password"):
      print(machine.succeed("getent passwd root"))
      assert "${rootHashedPasswordFile}" in machine.succeed("getent shadow root"), "root user password is not correct"

    with subtest("normalo user is created"):
      print(machine.succeed("getent passwd normalo"))
      assert 1000 <= int(machine.succeed("id --user normalo")), "normalo user doesn't have a normal UID"
      assert machine.succeed("stat -c '%U' /home/normalo") == "normalo\n"

    with subtest("system user is created with correct password"):
      print(machine.succeed("getent passwd sysuser"))
      assert 1000 > int(machine.succeed("id --user sysuser")), "sysuser user doesn't have a system UID"
      assert "${sysuserInitialHashedPassword}" in machine.succeed("getent shadow sysuser"), "system user password is not correct"

    with subtest("normalo-disabled is NOT created"):
      machine.fail("id normalo-disabled")
      # Check if user's home has been created
      machine.fail("[ -d '/home/normalo-disabled' ]")

    with subtest("sysusers group is created"):
      print(machine.succeed("getent group sysusers"))

    with subtest("Check files"):
      print(machine.succeed("grpck -r"))
      print(machine.succeed("pwck -r"))


    machine.succeed("/run/current-system/specialisation/new-generation/bin/switch-to-configuration switch")


    with subtest("root user password is updated"):
      print(machine.succeed("getent passwd root"))
      assert "${updatedRootHashedPassword}" in machine.succeed("getent shadow root"), "root user password is not updated"

    with subtest("normalo user password is updated"):
      print(machine.succeed("getent passwd normalo"))
      assert "${updatedNormaloHashedPassword}" in machine.succeed("getent shadow normalo"), "normalo user password is not updated"

    with subtest("system user password is NOT updated"):
      print(machine.succeed("getent passwd sysuser"))
      assert "${sysuserInitialHashedPassword}" in machine.succeed("getent shadow sysuser"), "sysuser user password is not updated"

    with subtest("new-normalo user is created after switching to new generation"):
      print(machine.succeed("getent passwd new-normalo"))
      assert 1000 <= int(machine.succeed("id --user new-normalo")), "new-normalo user doesn't have a normal UID"
      assert machine.succeed("stat -c '%U' /home/new-normalo") == "new-normalo\n"
      assert "${newNormaloHashedPassword}" in machine.succeed("getent shadow new-normalo"), "new-normalo user password is not correct"

    with subtest("new-group group is created after switching to new generation"):
      print(machine.succeed("getent group new-group"))

    with subtest("Check files"):
      print(machine.succeed("grpck -r"))
      print(machine.succeed("pwck -r"))
  '';
}

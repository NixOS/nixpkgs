{ lib, ... }:

let
  normaloHashedPassword = "$y$j9T$IEWqhKtWg.r.8fVkSEF56.$iKNxdMC6hOAQRp6eBtYvBk4c7BGpONXeZMqc8I/LM46";

  common = {
    services.userborn.enable = true;
    users.mutableUsers = false;
  };
in

{

  name = "userborn-immutable-users";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine =
    { config, ... }:
    {
      imports = [ common ];

      users = {
        users = {
          normalo = {
            isNormalUser = true;
            hashedPassword = normaloHashedPassword;
          };
        };
      };

      specialisation.new-generation = {
        inheritParentConfig = false;
        configuration = {
          nixpkgs = {
            inherit (config.nixpkgs) hostPlatform;
          };
          imports = [ common ];

          users.users = {
            new-normalo = {
              isNormalUser = true;
            };
          };
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("userborn.service")

    with subtest("normalo user is created"):
      assert "${normaloHashedPassword}" in machine.succeed("getent shadow normalo"), "normalo user password is not correct"

    with subtest("Fail to add new user manually"):
      machine.fail("useradd manual-normalo")

    with subtest("Fail to add delete user manually"):
      machine.fail("userdel normalo")


    machine.succeed("/run/current-system/specialisation/new-generation/bin/switch-to-configuration switch")


    with subtest("normalo user is disabled"):
      print(machine.succeed("getent shadow normalo"))
      assert "!*" in machine.succeed("getent shadow normalo"), "normalo user is not disabled"

    with subtest("new-normalo user is created after switching to new generation"):
      print(machine.succeed("getent passwd new-normalo"))

    with subtest("Still fail to add new user manually"):
      machine.fail("useradd again-normalo")
  '';
}

{ lib, ... }:

let
  normaloHashedPassword = "$y$j9T$IEWqhKtWg.r.8fVkSEF56.$iKNxdMC6hOAQRp6eBtYvBk4c7BGpONXeZMqc8I/LM46";

  common = {
    services.userborn.enable = true;
    users.mutableUsers = true;
  };
in

{

  name = "userborn-mutable-users";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine =
    { config, ... }:
    {
      imports = [ common ];

      users = {
        mutableUsers = true;
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
      assert 1000 == int(machine.succeed("id --user normalo")), "normalo user doesn't have UID 1000"
      assert "${normaloHashedPassword}" in machine.succeed("getent shadow normalo"), "normalo user password is not correct"

    with subtest("Add new user manually"):
      machine.succeed("useradd manual-normalo")
      assert 1001 == int(machine.succeed("id --user manual-normalo")), "manual-normalo user doesn't have UID 1001"

    with subtest("Delete manual--normalo user manually"):
      machine.succeed("userdel manual-normalo")


    machine.succeed("/run/current-system/specialisation/new-generation/bin/switch-to-configuration switch")


    with subtest("normalo user is disabled"):
      print(machine.succeed("getent shadow normalo"))
      assert "!*" in machine.succeed("getent shadow normalo"), "normalo user is not disabled"

    with subtest("new-normalo user is created after switching to new generation"):
      print(machine.succeed("getent passwd new-normalo"))
      assert 1001 == int(machine.succeed("id --user new-normalo")), "new-normalo user doesn't have UID 1001"
  '';
}

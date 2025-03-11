import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "dconf";

    meta.maintainers = with lib.maintainers; [
      linsui
    ];

    nodes.machine =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        users.extraUsers.alice = {
          isNormalUser = true;
        };
        programs.dconf = with lib.gvariant; {
          enable = true;
          profiles.user.databases = [
            {
              settings = {
                "test/not".locked = mkInt32 1;
                "test/is".locked = "locked";
              };
              locks = [
                "/test/is/locked"
              ];
            }
          ];
        };
      };

    testScript = ''
      machine.succeed("test $(dconf read -d /test/not/locked) == 1")
      machine.succeed("test $(dconf read -d /test/is/locked) == \"'locked'\"")
      machine.fail("sudo -u alice dbus-run-session -- dconf write /test/is/locked \"@s 'unlocked'\"")
      machine.succeed("sudo -u alice dbus-run-session -- dconf write /test/not/locked \"@i 2\"")
    '';
  }
)

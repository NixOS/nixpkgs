import ./make-test-python.nix ( { pkgs, ... }: let
  testUser = "alice";
in {
  name = "opentabletdriver";
  meta = {
    maintainers = with pkgs.lib.maintainers; [ thiagokokada ];
  };

  nodes.machine = { pkgs, ... }:
    {
      imports = [
        ./common/user-account.nix
        ./common/x11.nix
      ];
      test-support.displayManager.auto.user = testUser;
      hardware.opentabletdriver.enable = true;
    };

  testScript =
    ''
      machine.start()
      machine.wait_for_x()

      machine.wait_for_unit('graphical.target')
      machine.wait_for_unit("opentabletdriver.service", "${testUser}")

      machine.succeed("cat /etc/udev/rules.d/70-opentabletdriver.rules")
      # Will fail if service is not running
      # Needs to run as the same user that started the service
      machine.succeed("su - ${testUser} -c 'otd detect'")
    '';
})

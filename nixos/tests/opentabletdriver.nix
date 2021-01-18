import ./make-test-python.nix ( { pkgs, ... }: {
  name = "opentabletdriver";
  meta = {
    maintainers = with pkgs.lib.maintainers; [ thiagokokada ];
  };

  machine = { pkgs, ... }:
    {
      imports = [
        ./common/user-account.nix
        ./common/x11.nix
      ];
      test-support.displayManager.auto.user = "alice";
      hardware.opentabletdriver.enable = true;
    };

  testScript =
    ''
      machine.start()
      machine.wait_for_x()
      machine.wait_for_unit("opentabletdriver.service", "alice")

      machine.succeed("cat /etc/udev/rules.d/30-opentabletdriver.rules")
      # Will fail if service is not running
      machine.succeed("otd detect")
    '';
})

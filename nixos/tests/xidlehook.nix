import ./make-test-python.nix ({ pkgs, lib, ... }:

with lib;

{
  name = "xidlehook";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ enolan ];

  machine = {
    imports = [ ./common/x11.nix ./common/user-account.nix ];

    test-support.displayManager.auto.user = "bob";
    services.xserver.xidlehook = {
      enable = true;
      timers = [
        { seconds = 10;
          command = "touch ~/timer1";
        }
        { seconds = 15;
          command = "touch ~/timer2";
        }
      ];
    };

  };

  testScript = ''
    machine.start()
    machine.wait_for_x()
    machine.fail("cat ~bob/timer1 && ~bob/timer2")
    machine.sleep(15)
    machine.succeed("cat ~bob/timer1")
    machine.fail("cat ~bob/timer2")
    machine.sleep(15)
    machine.succeed("cat ~bob/timer1 && cat ~bob/timer2")
  '';
})

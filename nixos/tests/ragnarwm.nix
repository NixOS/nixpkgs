{ lib, ... }:
{
  name = "ragnarwm";

  meta = {
    maintainers = with lib.maintainers; [ sigmanificient ];
  };

  nodes.machine =
    { pkgs, lib, ... }:
    {
      imports = [
        ./common/x11.nix
        ./common/user-account.nix
      ];
      test-support.displayManager.auto.user = "alice";
      services.displayManager.defaultSession = lib.mkForce "ragnar";
      services.xserver.windowManager.ragnarwm.enable = true;

      # Setup the default terminal of Ragnar
      environment.systemPackages = [ pkgs.alacritty ];
    };

  testScript = ''
    with subtest("ensure x starts"):
        machine.wait_for_x()
        machine.wait_for_file("/home/alice/.Xauthority")
        machine.succeed("xauth merge ~alice/.Xauthority")

    with subtest("ensure we can open a new terminal"):
        # Sleeping a bit before the test, as it may help for sending keys
        machine.sleep(2)
        machine.send_key("meta_l-ret")
        machine.wait_for_window(r"alice.*?machine")
        machine.sleep(2)
        machine.screenshot("terminal")
  '';
}

{ lib, ... }:
{
  name = "oxwm";

  meta = {
    maintainers = with lib.maintainers; [
      sigmanificient
      tonybanters
    ];
  };

  nodes.machine =
    { pkgs, lib, ... }:
    {
      imports = [
        ./common/x11.nix
        ./common/user-account.nix
      ];
      test-support.displayManager.auto.user = "alice";
      services.displayManager.defaultSession = lib.mkForce "oxwm";
      services.xserver.windowManager.oxwm.enable = true;

      environment.systemPackages = [ pkgs.alacritty ];
    };

  testScript = ''
    with subtest("ensure x starts"):
        machine.wait_for_x()
        machine.wait_for_file("/home/alice/.Xauthority")
        machine.succeed("xauth merge ~alice/.Xauthority")

    with subtest("ensure we can open a new terminal"):
        machine.sleep(2)
        machine.send_key("meta_l-ret")
        machine.wait_for_window(r"alice.*?machine")
        machine.sleep(2)
        machine.screenshot("terminal")
  '';
}

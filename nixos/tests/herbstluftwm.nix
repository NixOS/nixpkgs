import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "herbstluftwm";

    meta = {
      maintainers = with lib.maintainers; [ thibautmarty ];
    };

    nodes.machine =
      { pkgs, lib, ... }:
      {
        imports = [
          ./common/x11.nix
          ./common/user-account.nix
        ];
        test-support.displayManager.auto.user = "alice";
        services.displayManager.defaultSession = lib.mkForce "none+herbstluftwm";
        services.xserver.windowManager.herbstluftwm.enable = true;
        environment.systemPackages = [ pkgs.dzen2 ]; # needed for upstream provided panel
      };

    testScript = ''
      with subtest("ensure x starts"):
          machine.wait_for_x()
          machine.wait_for_file("/home/alice/.Xauthority")
          machine.succeed("xauth merge ~alice/.Xauthority")

      with subtest("ensure client is available"):
          machine.succeed("herbstclient --version")

      with subtest("ensure keybindings are set"):
          machine.wait_until_succeeds("herbstclient list_keybinds | grep xterm")

      with subtest("ensure panel starts"):
          machine.wait_for_window("dzen title")

      with subtest("ensure we can open a new terminal"):
          machine.send_key("alt-ret")
          machine.wait_for_window(r"alice.*?machine")
          machine.sleep(2)
          machine.screenshot("terminal")
    '';
  }
)

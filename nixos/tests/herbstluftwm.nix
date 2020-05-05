import ./make-test-python.nix ({ lib, ...} : {
  name = "herbstluftwm";

  meta = {
    maintainers = with lib.maintainers; [ thibautmarty ];
    timeout = 30;
  };

  machine = { lib, ... }: {
    imports = [ ./common/x11.nix ./common/user-account.nix ];
    test-support.displayManager.auto.user = "alice";
    services.xserver.displayManager.defaultSession = lib.mkForce "none+herbstluftwm";
    services.xserver.windowManager.herbstluftwm.enable = true;
  };

  testScript = { ... }: ''
    with subtest("ensure x starts"):
        machine.wait_for_x()
        machine.wait_for_file("/home/alice/.Xauthority")
        machine.succeed("xauth merge ~alice/.Xauthority")

    with subtest("ensure we can open a new terminal"):
        machine.send_key("alt-ret")
        machine.sleep(2)
        machine.wait_for_window(r"alice.*?machine")
        machine.sleep(2)
        machine.screenshot("terminal")
  '';
})

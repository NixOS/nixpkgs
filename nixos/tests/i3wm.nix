import ./make-test-python.nix ({ pkgs, ...} : {
  name = "i3wm";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ aszlig ];
  };

  nodes.machine = { lib, ... }: {
    imports = [ ./common/x11.nix ./common/user-account.nix ];
    test-support.displayManager.auto.user = "alice";
    services.displayManager.defaultSession = lib.mkForce "none+i3";
    services.xserver.windowManager.i3.enable = true;
  };

  testScript = { ... }: ''
    with subtest("ensure x starts"):
        machine.wait_for_x()
        machine.wait_for_file("/home/alice/.Xauthority")
        machine.succeed("xauth merge ~alice/.Xauthority")

    with subtest("ensure we get first configuration window"):
        machine.wait_for_window(r".*?first configuration.*?")
        machine.sleep(2)
        machine.screenshot("started")

    with subtest("ensure we generate and save a config"):
        # press return to indicate we want to gen a new config
        machine.send_key("\n")
        machine.sleep(2)
        machine.screenshot("preconfig")
        # press alt then return to indicate we want to use alt as our Mod key
        machine.send_key("alt")
        machine.send_key("\n")
        machine.sleep(2)
        # make sure the config file is created before we continue
        machine.wait_for_file("/home/alice/.config/i3/config")
        machine.screenshot("postconfig")
        machine.sleep(2)

    with subtest("ensure we can open a new terminal"):
        machine.send_key("alt-ret")
        machine.sleep(2)
        machine.wait_for_window(r"alice.*?machine")
        machine.sleep(2)
        machine.screenshot("terminal")
  '';
})

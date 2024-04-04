import ./make-test-python.nix ({ pkgs, ...} : {
  name = "nimdow";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ marcusramberg ];
  };

  nodes.machine = { lib, ... }: {
    imports = [ ./common/x11.nix ./common/user-account.nix ];
    test-support.displayManager.auto.user = "alice";
    services.xserver.displayManager.defaultSession = lib.mkForce "none+nimdow";
    services.xserver.windowManager.nimdow.enable = true;
  };

  testScript = { ... }: ''
    with subtest("ensure x starts"):
        machine.wait_for_x()
        machine.wait_for_file("/home/alice/.Xauthority")
        machine.succeed("xauth merge ~alice/.Xauthority")

    with subtest("ensure we can open a new terminal"):
        machine.send_key("meta_l-ret")
        machine.wait_for_window(r"alice.*?machine")
        machine.screenshot("terminal")
  '';
})

import ./make-test-python.nix ({ lib, ...} : {
  name = "qtile";

  meta = {
    maintainers = with lib.maintainers; [ sigmanificient ];
  };

  nodes.machine = { pkgs, lib, ... }: {
    imports = [ ./common/x11.nix ./common/user-account.nix ];
    test-support.displayManager.auto.user = "alice";

    services.xserver.windowManager.qtile.enable = true;
    services.displayManager.defaultSession = lib.mkForce "qtile";

    environment.systemPackages = [ pkgs.kitty ];
  };

  testScript = ''
    with subtest("ensure x starts"):
        machine.wait_for_x()
        machine.wait_for_file("/home/alice/.Xauthority")
        machine.succeed("xauth merge ~alice/.Xauthority")

    with subtest("ensure client is available"):
        machine.succeed("qtile --version")

    with subtest("ensure we can open a new terminal"):
        machine.sleep(2)
        machine.send_key("meta_l-ret")
        machine.wait_for_window(r"alice.*?machine")
        machine.sleep(2)
        machine.screenshot("terminal")
  '';
})

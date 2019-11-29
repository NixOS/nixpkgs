import ./make-test-python.nix ({ pkgs, ...} : {
  name = "lightdm";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ aszlig worldofpeace ];
  };

  machine = { ... }: {
    imports = [ ./common/user-account.nix ];
    services.xserver.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.windowManager.default = "icewm";
    services.xserver.windowManager.icewm.enable = true;
    services.xserver.desktopManager.default = "none";
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
  in ''
    start_all()
    machine.wait_for_text("${user.description}")
    machine.screenshot("lightdm")
    machine.send_chars("${user.password}\n")
    machine.wait_for_file("${user.home}/.Xauthority")
    machine.succeed("xauth merge ${user.home}/.Xauthority")
    machine.wait_for_window("^IceWM ")
  '';
})

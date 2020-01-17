import ./make-test-python.nix ({ pkgs, ...} : {
  name = "xmonad";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  machine = { pkgs, ... }: {
    imports = [ ./common/x11.nix ./common/user-account.nix ];
    services.xserver.displayManager.auto.user = "alice";
    services.xserver.displayManager.defaultSession = "none+xmonad";
    services.xserver.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = with pkgs.haskellPackages; haskellPackages: [ xmobar ];
      config = ''
        import XMonad
        import XMonad.Util.EZConfig
        main = launch $ def `additionalKeysP` myKeys
        myKeys = [ ("M-C-x", spawn "xterm") ]
      '';
    };
  };

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
  in ''
    machine.wait_for_x()
    machine.wait_for_file("${user.home}/.Xauthority")
    machine.succeed("xauth merge ${user.home}/.Xauthority")
    machine.send_key("alt-ctrl-x")
    machine.wait_for_window("${user.name}.*machine")
    machine.sleep(1)
    machine.screenshot("terminal")
    machine.wait_until_succeeds("xmonad --restart")
    machine.sleep(3)
    machine.send_key("alt-shift-ret")
    machine.wait_for_window("${user.name}.*machine")
    machine.sleep(1)
    machine.screenshot("terminal")
  '';
})

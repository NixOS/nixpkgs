import ./make-test-python.nix ({ pkgs, ...} : {
  name = "xmonad";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  machine = { pkgs, ... }: {
    imports = [ ./common/x11.nix ./common/user-account.nix ];
    test-support.displayManager.auto.user = "alice";
    services.xserver.displayManager.defaultSession = "none+xmonad";
    services.xserver.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = with pkgs.haskellPackages; haskellPackages: [ xmobar ];
      config = ''
        import XMonad
        import XMonad.Operations (restart)
        import XMonad.Util.EZConfig
        import XMonad.Util.SessionStart

        main = launch $ def { startupHook = startup } `additionalKeysP` myKeys

        startup = isSessionStart >>= \sessInit ->
          if sessInit then setSessionStarted else spawn "xterm"

        myKeys = [ ("M-C-x", spawn "xterm"), ("M-q", restart "xmonad" True) ]
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
    machine.screenshot("terminal1")
    machine.send_key("alt-q")
    machine.sleep(3)
    machine.wait_for_window("${user.name}.*machine")
    machine.sleep(1)
    machine.screenshot("terminal2")
  '';
})

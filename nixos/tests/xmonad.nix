import ./make-test-python.nix (
  { pkgs, ... }:

  let
    mkConfig = name: keys: ''
      import XMonad
      import XMonad.Operations (restart)
      import XMonad.Util.EZConfig
      import XMonad.Util.SessionStart
      import Control.Monad (when)
      import Text.Printf (printf)
      import System.Posix.Process (executeFile)
      import System.Info (arch,os)
      import System.Environment (getArgs)
      import System.FilePath ((</>))

      main = do
        dirs <- getDirectories
        launch (def { startupHook = startup } `additionalKeysP` myKeys) dirs

      startup = isSessionStart >>= \sessInit ->
        spawn "touch /tmp/${name}"
          >> if sessInit then setSessionStarted else spawn "xterm"

      myKeys = [${builtins.concatStringsSep ", " keys}]

      compiledConfig = printf "xmonad-%s-%s" arch os

      compileRestart resume = do
        dirs <- asks directories

        whenX (recompile dirs True) $
          when resume writeStateToFile
            *> catchIO
              ( do
                  args <- getArgs
                  executeFile (cacheDir dirs </> compiledConfig) False args Nothing
              )
    '';

    oldKeys = [
      ''("M-C-x", spawn "xterm")''
      ''("M-q", restart "xmonad" True)''
      ''("M-C-q", compileRestart True)''
      ''("M-C-t", spawn "touch /tmp/somefile")'' # create somefile
    ];

    newKeys = [
      ''("M-C-x", spawn "xterm")''
      ''("M-q", restart "xmonad" True)''
      ''("M-C-q", compileRestart True)''
      ''("M-C-r", spawn "rm /tmp/somefile")'' # delete somefile
    ];

    newConfig = pkgs.writeText "xmonad.hs" (mkConfig "newXMonad" newKeys);
  in
  {
    name = "xmonad";
    meta = with pkgs.lib.maintainers; {
      maintainers = [
        nequissimus
        ivanbrennan
      ];
    };

    nodes.machine =
      { pkgs, ... }:
      {
        imports = [
          ./common/x11.nix
          ./common/user-account.nix
        ];
        test-support.displayManager.auto.user = "alice";
        services.displayManager.defaultSession = "none+xmonad";
        services.xserver.windowManager.xmonad = {
          enable = true;
          enableConfiguredRecompile = true;
          enableContribAndExtras = true;
          extraPackages = with pkgs.haskellPackages; haskellPackages: [ xmobar ];
          config = mkConfig "oldXMonad" oldKeys;
        };
      };

    testScript =
      { nodes, ... }:
      let
        user = nodes.machine.config.users.users.alice;
      in
      ''
        machine.wait_for_x()
        machine.wait_for_file("${user.home}/.Xauthority")
        machine.succeed("xauth merge ${user.home}/.Xauthority")
        machine.send_key("alt-ctrl-x")
        machine.wait_for_window("${user.name}.*machine")
        machine.sleep(1)
        machine.screenshot("terminal1")
        machine.succeed("rm /tmp/oldXMonad")
        machine.send_key("alt-q")
        machine.wait_for_file("/tmp/oldXMonad")
        machine.wait_for_window("${user.name}.*machine")
        machine.sleep(1)
        machine.screenshot("terminal2")

        # /tmp/somefile should not exist yet
        machine.fail("stat /tmp/somefile")

        # original config has a keybinding that creates somefile
        machine.send_key("alt-ctrl-t")
        machine.wait_for_file("/tmp/somefile")

        # set up the new config
        machine.succeed("mkdir -p ${user.home}/.xmonad")
        machine.copy_from_host("${newConfig}", "${user.home}/.config/xmonad/xmonad.hs")

        # recompile xmonad using the new config
        machine.send_key("alt-ctrl-q")
        machine.wait_for_file("/tmp/newXMonad")

        # new config has a keybinding that deletes somefile
        machine.send_key("alt-ctrl-r")
        machine.wait_until_fails("stat /tmp/somefile", timeout=30)

        # restart with the old config, and confirm the old keybinding is back
        machine.succeed("rm /tmp/oldXMonad")
        machine.send_key("alt-q")
        machine.wait_for_file("/tmp/oldXMonad")
        machine.send_key("alt-ctrl-t")
        machine.wait_for_file("/tmp/somefile")
      '';
  }
)

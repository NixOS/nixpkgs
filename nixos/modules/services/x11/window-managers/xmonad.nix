{pkgs, lib, config, ...}:

with lib;
let
  inherit (lib) mkOption mkIf optionals literalExpression optionalString;
  cfg = config.services.xserver.windowManager.xmonad;

  ghcWithPackages = cfg.haskellPackages.ghcWithPackages;
  packages = self: cfg.extraPackages self ++
                   optionals cfg.enableContribAndExtras
                   [ self.xmonad-contrib self.xmonad-extras ];

  xmonad-vanilla = pkgs.xmonad-with-packages.override {
    inherit ghcWithPackages packages;
  };

  xmonad-config =
    let
      xmonadAndPackages = self: [ self.xmonad ] ++ packages self;
      xmonadEnv = ghcWithPackages xmonadAndPackages;
      configured = pkgs.writers.writeHaskellBin "xmonad" {
        ghc = cfg.haskellPackages.ghc;
        libraries = xmonadAndPackages cfg.haskellPackages;
        inherit (cfg) ghcArgs;
      } cfg.config;
    in
      pkgs.runCommand "xmonad" {
        preferLocalBuild = true;
        nativeBuildInputs = [ pkgs.makeWrapper ];
      } (''
        install -D ${xmonadEnv}/share/man/man1/xmonad.1.gz $out/share/man/man1/xmonad.1.gz
        makeWrapper ${configured}/bin/xmonad $out/bin/xmonad \
      '' + optionalString cfg.enableConfiguredRecompile ''
          --set XMONAD_GHC "${xmonadEnv}/bin/ghc" \
      '' + ''
          --set XMONAD_XMESSAGE "${pkgs.xorg.xmessage}/bin/xmessage"
      '');

  xmonad = if (cfg.config != null) then xmonad-config else xmonad-vanilla;
in {
  meta.maintainers = with maintainers; [ lassulus xaverdh ivanbrennan slotThe ];

  options = {
    services.xserver.windowManager.xmonad = {
      enable = mkEnableOption "xmonad";

      haskellPackages = mkOption {
        default = pkgs.haskellPackages;
        defaultText = literalExpression "pkgs.haskellPackages";
        example = literalExpression "pkgs.haskell.packages.ghc810";
        type = types.attrs;
        description = ''
          haskellPackages used to build Xmonad and other packages.
          This can be used to change the GHC version used to build
          Xmonad and the packages listed in
          {var}`extraPackages`.
        '';
      };

      extraPackages = mkOption {
        type = types.functionTo (types.listOf types.package);
        default = self: [];
        defaultText = literalExpression "self: []";
        example = literalExpression ''
          haskellPackages: [
            haskellPackages.xmonad-contrib
            haskellPackages.monad-logger
          ]
        '';
        description = ''
          Extra packages available to ghc when rebuilding Xmonad. The
          value must be a function which receives the attrset defined
          in {var}`haskellPackages` as the sole argument.
        '';
      };

      enableContribAndExtras = mkOption {
        default = false;
        type = lib.types.bool;
        description = "Enable xmonad-{contrib,extras} in Xmonad.";
      };

      config = mkOption {
        default = null;
        type = with lib.types; nullOr (either path str);
        description = ''
          Configuration from which XMonad gets compiled. If no value is
          specified, a vanilla xmonad binary is put in PATH, which will
          attempt to recompile and exec your xmonad config from $HOME/.xmonad.
          This setup is then analogous to other (non-NixOS) linux distributions.

          If you do set this option, you likely want to use "launch" as your
          entry point for xmonad (as in the example), to avoid xmonad's
          recompilation logic on startup. Doing so will render the default
          "mod+q" restart key binding dysfunctional though, because that attempts
          to call your binary with the "--restart" command line option, unless
          you implement that yourself. You way mant to bind "mod+q" to
          `(restart "xmonad" True)` instead, which will just restart
          xmonad from PATH. This allows e.g. switching to the new xmonad binary
          after rebuilding your system with nixos-rebuild.
          For the same reason, ghc is not added to the environment when this
          option is set, unless {option}`enableConfiguredRecompile` is
          set to `true`.

          If you actually want to run xmonad with a config specified here, but
          also be able to recompile and restart it from a copy of that source in
          $HOME/.xmonad on the fly, set {option}`enableConfiguredRecompile`
          to `true` and implement something like "compileRestart"
          from the example.
          This should allow you to switch at will between the local xmonad and
          the one NixOS puts in your PATH.
        '';
        example = ''
          import XMonad
          import XMonad.Util.EZConfig (additionalKeys)
          import Control.Monad (when)
          import Text.Printf (printf)
          import System.Posix.Process (executeFile)
          import System.Info (arch,os)
          import System.Environment (getArgs)
          import System.FilePath ((</>))

          compiledConfig = printf "xmonad-%s-%s" arch os

          myConfig = defaultConfig
            { modMask = mod4Mask -- Use Super instead of Alt
            , terminal = "urxvt" }
            `additionalKeys`
            [ ( (mod4Mask,xK_r), compileRestart True)
            , ( (mod4Mask,xK_q), restart "xmonad" True ) ]

          compileRestart resume = do
            dirs  <- asks directories
            whenX (recompile dirs True) $ do
              when resume writeStateToFile
              catchIO
                  ( do
                      args <- getArgs
                      executeFile (cacheDir dirs </> compiledConfig) False args Nothing
                  )

          main = getDirectories >>= launch myConfig

          --------------------------------------------
          {- For versions before 0.17.0 use this instead -}
          --------------------------------------------
          -- compileRestart resume =
          --   whenX (recompile True) $
          --     when resume writeStateToFile
          --       *> catchIO
          --         ( do
          --             dir <- getXMonadDataDir
          --             args <- getArgs
          --             executeFile (dir </> compiledConfig) False args Nothing
          --         )
          --
          -- main = launch myConfig
          --------------------------------------------

        '';
      };

      enableConfiguredRecompile = mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable recompilation even if {option}`config` is set to a
          non-null value. This adds the necessary Haskell dependencies (GHC with
          packages) to the xmonad binary's environment.
        '';
      };

      xmonadCliArgs = mkOption {
        default = [];
        type = with lib.types; listOf str;
        description = ''
          Command line arguments passed to the xmonad binary.
        '';
      };

      ghcArgs = mkOption {
        default = [];
        type = with lib.types; listOf str;
        description = ''
          Command line arguments passed to the compiler (ghc)
          invocation when xmonad.config is set.
        '';
      };

    };
  };
  config = mkIf cfg.enable {
    services.xserver.windowManager = {
      session = [{
        name = "xmonad";
        start = ''
           systemd-cat -t xmonad -- ${xmonad}/bin/xmonad ${lib.escapeShellArgs cfg.xmonadCliArgs} &
           waitPID=$!
        '';
      }];
    };

    environment.systemPackages = [ xmonad ];
  };
}

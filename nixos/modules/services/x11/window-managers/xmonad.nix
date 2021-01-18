{pkgs, lib, config, ...}:

with lib;
let
  inherit (lib) mkOption mkIf optionals literalExample;
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
      pkgs.runCommandLocal "xmonad" {
        nativeBuildInputs = [ pkgs.makeWrapper ];
      } ''
        install -D ${xmonadEnv}/share/man/man1/xmonad.1.gz $out/share/man/man1/xmonad.1.gz
        makeWrapper ${configured}/bin/xmonad $out/bin/xmonad \
          --set NIX_GHC "${xmonadEnv}/bin/ghc" \
          --set XMONAD_XMESSAGE "${pkgs.xorg.xmessage}/bin/xmessage"
      '';

  xmonad = if (cfg.config != null) then xmonad-config else xmonad-vanilla;
in {
  meta.maintainers = with maintainers; [ lassulus xaverdh ivanbrennan ];

  options = {
    services.xserver.windowManager.xmonad = {
      enable = mkEnableOption "xmonad";
      haskellPackages = mkOption {
        default = pkgs.haskellPackages;
        defaultText = "pkgs.haskellPackages";
        example = literalExample "pkgs.haskell.packages.ghc784";
        description = ''
          haskellPackages used to build Xmonad and other packages.
          This can be used to change the GHC version used to build
          Xmonad and the packages listed in
          <varname>extraPackages</varname>.
        '';
      };

      extraPackages = mkOption {
        default = self: [];
        defaultText = "self: []";
        example = literalExample ''
          haskellPackages: [
            haskellPackages.xmonad-contrib
            haskellPackages.monad-logger
          ]
        '';
        description = ''
          Extra packages available to ghc when rebuilding Xmonad. The
          value must be a function which receives the attrset defined
          in <varname>haskellPackages</varname> as the sole argument.
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
          <literal>(restart "xmonad" True)</literal> instead, which will just restart
          xmonad from PATH. This allows e.g. switching to the new xmonad binary
          after rebuilding your system with nixos-rebuild.

          If you actually want to run xmonad with a config specified here, but
          also be able to recompile and restart it from a copy of that source in
          $HOME/.xmonad on the fly, you will have to implement that yourself
          using something like "compileRestart" from the example.
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

          compileRestart resume =
            whenX (recompile True) $
              when resume writeStateToFile
                *> catchIO
                  ( do
                      dir <- getXMonadDataDir
                      args <- getArgs
                      executeFile (dir </> compiledConfig) False args Nothing
                  )

          main = launch defaultConfig
              { modMask = mod4Mask -- Use Super instead of Alt
              , terminal = "urxvt" }
              `additionalKeys`
              [ ( (mod4Mask,xK_r), compileRestart True)
              , ( (mod4Mask,xK_q), restart "xmonad" True ) ]
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

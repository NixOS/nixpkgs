{pkgs, lib, config, ...}:

with lib;
let
  inherit (lib) mkOption mkIf optionals literalExample;
  cfg = config.services.xserver.windowManager.xmonad;
  xmonad = pkgs.xmonad-with-packages.override {
    ghcWithPackages = cfg.haskellPackages.ghcWithPackages;
    packages = self: cfg.extraPackages self ++
                     optionals cfg.enableContribAndExtras
                     [ self.xmonad-contrib self.xmonad-extras ];
  };
  xmonadBin = pkgs.writers.writeHaskell "xmonad" {
    ghc = cfg.haskellPackages.ghc;
    libraries = [ cfg.haskellPackages.xmonad ] ++
                cfg.extraPackages cfg.haskellPackages ++
                optionals cfg.enableContribAndExtras
                (with cfg.haskellPackages; [ xmonad-contrib xmonad-extras ]);
  } cfg.config;

in
{
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
          Configuration from which XMonad gets compiled. If no value
          is specified, the xmonad config from $HOME/.xmonad is taken.
          If you use xmonad --recompile, $HOME/.xmonad will be taken as
          the configuration, but on the next restart of display-manager
          this config will be reapplied.
        '';
        example = ''
          import XMonad

          main = launch defaultConfig
                 { modMask = mod4Mask -- Use Super instead of Alt
                 , terminal = "urxvt"
                 }
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    services.xserver.windowManager = {
      session = [{
        name = "xmonad";
        start = if (cfg.config != null) then ''
          ${xmonadBin}
          waitPID=$!
        '' else ''
          systemd-cat -t xmonad ${xmonad}/bin/xmonad &
          waitPID=$!
        '';
      }];
    };

    environment.systemPackages = [ xmonad ];
  };
}

{pkgs, lib, config, ...}:

with lib;
let
  inherit (lib) mkOption mkIf optionals literalExample;
  wmcfg = config.services.xserver.windowManager;
  cfg = config.services.xserver.windowManager.xmonad;
  xmonad = pkgs.xmonad-with-packages.override {
    ghcWithPackages = cfg.haskellPackages.ghcWithPackages;
    packages = self: cfg.extraPackages self ++
                     optionals cfg.enableContribAndExtras
                     [ self.xmonad-contrib self.xmonad-extras ];
  };
in
{
  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "xmonad" ]);
    };

    services.xserver.windowManager.xmonad = {
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
    };
  };

  config = mkIf (elem "xmonad" wmcfg.select) {
    services.xserver.windowManager = {
      session = [{
        name = "xmonad";
        start = ''
          ${xmonad}/bin/xmonad &
          waitPID=$!
        '';
      }];
    };

    environment.systemPackages = [ xmonad ];
  };
}

let
  pkgs = import ../../.. {
    config = {};
    overlays = [];
  };

  common = import ./common.nix;
  inherit (common) outputPath indexPath;

  web-devmode = pkgs.devmode.override {
    buildArgs = "../../release.nix -A manualHTML.${builtins.currentSystem}";
    open = "/${outputPath}/${indexPath}";
  };
in
  pkgs.mkShell {
    packages = [
      web-devmode
    ];
  }

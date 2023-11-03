let
  pkgs = import ../. {
    config = {};
    overlays = [];
  };

  common = import ./common.nix;
  inherit (common) outputPath indexPath;

  web-devmode = pkgs.devmode.override {
    buildArgs = "./.";
    open = "/${outputPath}/${indexPath}";
  };
in
  pkgs.mkShell {
    packages = [
      web-devmode
    ];
  }

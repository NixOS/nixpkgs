let
  pkgs = import ../../.. {
    config = { };
    overlays = [ ];
  };

  common = import ./common.nix;
  inherit (common) outputPath indexPath;
  devmode = pkgs.callPackage ../../../pkgs/tools/nix/web-devmode.nix {
    buildArgs = "../../release.nix -A manualHTML.${builtins.currentSystem}";
    open = "/${outputPath}/${indexPath}";
  };
in
pkgs.mkShellNoCC {
  packages = [ devmode ];
}

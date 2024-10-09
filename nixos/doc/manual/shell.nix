let
  pkgs = import ../../.. {
    config = { };
    overlays = [ ];
  };

  common = import ./common.nix;
  inherit (common) outputPath indexPath;
in
pkgs.callPackage ../../../pkgs/tools/nix/web-devmode.nix {
  buildArgs = "../../release.nix -A manualHTML.${builtins.currentSystem}";
  open = "/${outputPath}/${indexPath}";
}

let
  pkgs = import ../. {
    config = { };
    overlays = [ ];
  };

  common = import ./common.nix;
  inherit (common) outputPath indexPath;

  web-devmode = import ../pkgs/tools/nix/web-devmode.nix {
    inherit pkgs;
    buildArgs = "./.";
    open = "/${outputPath}/${indexPath}";
  };
in
pkgs.mkShell {
  packages = [
    web-devmode
  ];
}

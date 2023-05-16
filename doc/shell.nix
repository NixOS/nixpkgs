<<<<<<< HEAD
let
  pkgs = import ../. {
    config = {};
    overlays = [];
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
=======
{ pkgs ? import ../. { } }:
(import ./default.nix { }).overrideAttrs
(x: { buildInputs = (x.buildInputs or [ ]) ++ [ pkgs.xmloscopy pkgs.ruby ]; })
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

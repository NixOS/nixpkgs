{ lib, stdenv, vscode-utils, callPackage }:
let
<<<<<<< HEAD
  version = "1.16.0";
=======
  version = "1.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  rescript-editor-analysis = callPackage ./rescript-editor-analysis.nix { inherit version; };
  arch =
    if stdenv.isLinux then "linux"
    else if stdenv.isDarwin then "darwin"
    else throw "Unsupported platform";
  analysisDir = "server/analysis_binaries/${arch}";
in
vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "rescript-vscode";
    publisher = "chenglou92";
    inherit version;
<<<<<<< HEAD
    sha256 = "sha256-JoC9+NkbLAZXkOKDDMB0Xgzmn+w90pHcokerMrdACi4=";
=======
    sha256 = "sha256-XZG0PRzc3wyAVq9tQeGDlaUZg5YAgkPxJ3NsrdUHoOk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  postPatch = ''
    rm -r ${analysisDir}
    ln -s ${rescript-editor-analysis}/bin ${analysisDir}
  '';

  meta = {
    description = "The official VSCode plugin for ReScript";
    homepage = "https://github.com/rescript-lang/rescript-vscode";
    maintainers = [ lib.maintainers.dlip lib.maintainers.jayesh-bhoot ];
    license = lib.licenses.mit;
  };
}

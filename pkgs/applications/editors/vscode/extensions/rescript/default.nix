{ lib, stdenv, vscode-utils, callPackage }:
let
  rescript-editor-analysis = (callPackage ./rescript-editor-analysis.nix { });
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
    version = "1.3.0";
    sha256 = "sha256-Sgi7FFOpI/XOeyPOrDhwZdZ+43ilUz7oQ49yB7tiMXk=";
  };
  postPatch = ''
    rm -r ${analysisDir}
    ln -s ${rescript-editor-analysis}/bin ${analysisDir}
  '';

  meta = with lib; {
    description = "The official VSCode plugin for ReScript";
    homepage = "https://github.com/rescript-lang/rescript-vscode";
    maintainers = with maintainers; [ dlip ];
    license = licenses.mit;
  };
}

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
    version = "1.1.3";
    sha256 = "1c1ipxgm0f0a3vlnhr0v85jr5l3rwpjzh9w8nv2jn5vgvpas0b2a";
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

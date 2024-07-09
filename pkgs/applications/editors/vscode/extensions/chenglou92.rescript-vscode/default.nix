{
  lib,
  stdenv,
  vscode-utils,
  callPackage,
}:
let
  version = "1.54.0";
  rescript-editor-analysis = callPackage ./rescript-editor-analysis.nix { inherit version; };
  arch =
    if stdenv.isLinux then
      "linux"
    else if stdenv.isDarwin then
      "darwin"
    else
      throw "Unsupported system: ${stdenv.system}";
  analysisDir = "server/analysis_binaries/${arch}";
in
vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "rescript-vscode";
    publisher = "chenglou92";
    inherit version;
    hash = "sha256-c7TJED5YpHRwn7Ooq8sG+N99b7tH6TOgeC9TTYdb4JA=";
  };
  postPatch = ''
    rm -r ${analysisDir}
    ln -s ${rescript-editor-analysis}/bin ${analysisDir}
  '';

  meta = {
    description = "Official VSCode plugin for ReScript";
    homepage = "https://github.com/rescript-lang/rescript-vscode";
    maintainers = [
      lib.maintainers.dlip
      lib.maintainers.jayesh-bhoot
    ];
    license = lib.licenses.mit;
  };
}

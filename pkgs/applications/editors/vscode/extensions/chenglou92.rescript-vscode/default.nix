{
  lib,
  stdenv,
  vscode-utils,
  callPackage,
}:
let
  extVersion = "1.62.0";
  rescript-editor-analysis = callPackage ./rescript-editor-analysis.nix { };

  # Ensure the versions match
  version =
    if rescript-editor-analysis.version == extVersion then
      rescript-editor-analysis.version
    else
      throw "analysis and extension versions must match";

  arch =
    if stdenv.hostPlatform.isLinux then
      "linux"
    else if stdenv.hostPlatform.isDarwin then
      "darwin"
    else
      throw "Unsupported system: ${stdenv.system}";
  analysisDir = "server/analysis_binaries/${arch}";
in

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "rescript-vscode";
    publisher = "chenglou92";
    inherit version;
    hash = "sha256-yUAhysTM9FXo9ZAzrto+tnjnofIUEQAGBg3tjIainrY=";
  };

  # For rescript-language-server
  passthru.rescript-editor-analysis = rescript-editor-analysis;

  strictDeps = true;
  postPatch = ''
    rm -r ${analysisDir}
    ln -s ${rescript-editor-analysis}/bin ${analysisDir}
  '';

  meta = {
    description = "Official VSCode plugin for ReScript";
    homepage = "https://github.com/rescript-lang/rescript-vscode";
    maintainers = [
      lib.maintainers.jayesh-bhoot
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.mit;
  };
}

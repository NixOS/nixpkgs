{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchNpmDeps,
  nix-update-script,
  nodejs,
  npmHooks,
  replaceVars,
  vsce,
  vscode-utils,
  pandoc,
}:

let
  version = "0.7.3";
  src = stdenvNoCC.mkDerivation (finalAttrs: {
    sourceName = "chrischinchilla-vscode-pandoc";
    name = "${finalAttrs.sourceName}-${finalAttrs.version}.vsix";
    pname = "${finalAttrs.sourceName}-vsix";
    inherit version;
    src = fetchFromGitHub {
      owner = "ChrisChinchilla";
      repo = "vscode-pandoc";
      tag = "v${finalAttrs.version}";
      hash = "sha256-tn3qQzbwjUnbuZtwCs4kXiGcrR/pTDECoHIirG/0WrU=";
    };
    patches = [
      (replaceVars ./add-pandoc-to-path.patch {
        pandocBin = lib.makeBinPath [ pandoc ];
      })
    ];
    npmDeps = fetchNpmDeps {
      inherit (finalAttrs) src;
      hash = "sha256-1j+bDx2CiViEgLfanyx0dwLRgY1aYV9rQDWP3nDl1Bw=";
    };
    nativeBuildInputs = [
      nodejs
      npmHooks.npmConfigHook
      vsce
    ];
    strictDeps = true;
    __structuredAttrs = true;
    dontConfigure = true;
    buildPhase = ''
      runHook preBuild
      vsce package --no-dependencies --out $out
      runHook postBuild
    '';
    dontInstall = true;
  });
in
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "chrischinchilla-vscode-pandoc";
  inherit version src;
  vscodeExtPublisher = "chrischinchilla";
  vscodeExtName = "vscode-pandoc";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";
  buildInputs = [ pandoc ]; # The Nix path scanner can't see into the VSIX.
  passthru.updateScript = nix-update-script {
    attrPath = "vscode-extensions.chrischinchilla.vscode-pandoc.src";
  };
  meta = {
    description = "Converts Markdown files to pdf, docx, or html files using pandoc";
    homepage = "https://github.com/ChrisChinchilla/vscode-pandoc#readme";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=chrischinchilla.vscode-pandoc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})

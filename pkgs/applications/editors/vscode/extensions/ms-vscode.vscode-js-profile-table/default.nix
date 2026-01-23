{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  vsce,
  vscode-utils,
  nix-update-script,
}:

let
  vsix = stdenvNoCC.mkDerivation (finalAttrs: {
    name = "vscode-js-profile-table-${finalAttrs.version}.vsix";
    pname = "vscode-js-profile-table-vsix";
    version = "1.0.10";

    src = fetchFromGitHub {
      owner = "microsoft";
      repo = "vscode-js-profile-visualizer";
      tag = "v${finalAttrs.version}";
      hash = "sha256-NlL5o6PHkLY49Yo2bJOxYNs0IbO9x9DcMxGHEDKUOAk=";
    };

    patches = [ ./package-lock-json.patch ];

    npmDeps = fetchNpmDeps {
      name = "${finalAttrs.pname}-npm-deps";
      inherit (finalAttrs) src patches;
      hash = "sha256-4Z5MjEM5WUKtISDjkpaEPR3jl1WWI7cbV4uTmgVoloU=";
    };
    makeCacheWritable = true;

    nativeBuildInputs = [
      nodejs
      npmHooks.npmConfigHook
      vsce
    ];

    strictDeps = true;

    buildPhase = ''
      runHook preBuild
      node --run compile:core
      node --run compile:table
      cp ./LICENSE ./packages/vscode-js-profile-table/LICENSE
      (cd packages/vscode-js-profile-table && vsce package --no-dependencies)
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp ./packages/vscode-js-profile-table/vscode-js-profile-table-${finalAttrs.version}.vsix $out
      runHook postInstall
    '';
  });
in
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "vscode-js-profile-table";
  inherit (finalAttrs.src) version;

  vscodeExtPublisher = "ms-vscode";
  vscodeExtName = "vscode-js-profile-table";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";

  src = vsix;

  passthru = {
    vsix = finalAttrs.src;
    updateScript = nix-update-script {
      attrPath = "vscode-extensions.ms-vscode.vscode-js-profile-table.vsix";
    };
  };

  meta = {
    description = "Text visualizer for profiles taken from the JavaScript debugger";
    homepage = "https://github.com/microsoft/vscode-js-profile-visualizer";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-js-profile-table";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
})

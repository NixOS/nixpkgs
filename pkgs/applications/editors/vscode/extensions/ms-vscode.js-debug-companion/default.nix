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
    name = "vscode-js-debug-companion-${finalAttrs.version}.vsix";
    pname = "vscode-js-debug-companion-vsix";
    version = "1.1.3";

    src = fetchFromGitHub {
      owner = "microsoft";
      repo = "vscode-js-debug-companion";
      tag = "v${finalAttrs.version}";
      hash = "sha256-+w6s6S1Vk99ABEJyQPEZXVPj0aNt6MvrD2nPGbxrsw0=";
    };

    npmDeps = fetchNpmDeps {
      name = "${finalAttrs.pname}-npm-deps";
      inherit (finalAttrs) src;
      hash = "sha256-yirZRytdOYp7EMYIN6Yc7GC/9EFHONzarj+K/idj3pQ=";
    };

    nativeBuildInputs = [
      nodejs
      npmHooks.npmConfigHook
      vsce
    ];

    strictDeps = true;

    buildPhase = ''
      runHook preBuild
      vsce package
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp ./js-debug-companion-$version.vsix $out
      runHook postInstall
    '';
  });
in
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "vscode-js-debug-companion";
  inherit (finalAttrs.src) version;

  vscodeExtPublisher = "ms-vscode";
  vscodeExtName = "js-debug-companion";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";

  src = vsix;

  passthru = {
    vsix = finalAttrs.src;
    updateScript = nix-update-script {
      attrPath = "vscode-extensions.ms-vscode.js-debug-companion.vsix";
    };
  };

  meta = {
    description = "Companion extension to js-debug that provides capability for remote debugging";
    homepage = "https://github.com/microsoft/vscode-js-debug-companion";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.js-debug-companion";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
})

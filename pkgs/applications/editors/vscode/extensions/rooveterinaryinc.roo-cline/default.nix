{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  vscode-utils,
  nix-update-script,
}:

let
  pnpm = pnpm_10;

  vsix = stdenvNoCC.mkDerivation (finalAttrs: {
    name = "roo-code-${finalAttrs.version}.vsix";
    pname = "roo-code-vsix";
    version = "3.52.0";

    src = fetchFromGitHub {
      owner = "RooCodeInc";
      repo = "Roo-Code";
      tag = "v${finalAttrs.version}";
      hash = "sha256-DvuL1WByEJER+v73pCvwNdRNfM8j+c1VQGGjAyV79p8=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      fetcherVersion = 3;
      hash = "sha256-t2sPuhn8xdk6hGfmViPGG+5TAhtBBOMYNoOb6DlPzws=";
    };

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm
    ];

    buildPhase = ''
      runHook preBuild

      node --run vsix

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp ./bin/roo-cline-$version.vsix $out

      runHook postInstall
    '';
  });
in
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "roo-code";
  inherit (finalAttrs.src) version;

  vscodeExtPublisher = "RooVeterinaryInc";
  vscodeExtName = "roo-cline";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";

  src = vsix;

  passthru = {
    vsix = finalAttrs.src;
    updateScript = nix-update-script {
      attrPath = "vscode-extensions.rooveterinaryinc.roo-cline.vsix";
    };
  };

  meta = {
    description = "AI-powered autonomous coding agent that lives in your editor";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=RooVeterinaryInc.roo-cline";
    homepage = "https://github.com/RooCodeInc/Roo-Code";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
})

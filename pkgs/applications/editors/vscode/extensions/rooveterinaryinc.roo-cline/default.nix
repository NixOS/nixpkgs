{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  vscode-utils,
  nix-update-script,
}:

let
  vsix = stdenvNoCC.mkDerivation (finalAttrs: {
    name = "roo-code-${finalAttrs.version}.vsix";
    pname = "roo-code-vsix";
    version = "3.45.0";

    src = fetchFromGitHub {
      owner = "RooCodeInc";
      repo = "Roo-Code";
      tag = "v${finalAttrs.version}";
      hash = "sha256-ZWt2R50yFxUHDJ2jrkMKaNoWUD6mSNm0ucq/FXPC2VE=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 2;
      hash = "sha256-QAzk+aXdCtQQ/KEoqGfn5j7l7Gx3HDvlL3aO+81hABM=";
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

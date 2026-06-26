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
    version = "3.54.0";

    src = fetchFromGitHub {
      owner = "RooCodeInc";
      repo = "Roo-Code";
      tag = "v${finalAttrs.version}";
      hash = "sha256-pVJcFAI/xxNflzf+wj0fOASP8Fx9oybu9V6dGrDx7do=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      fetcherVersion = 3;
      hash = "sha256-VD4DDLpZdnsfZNkg2oD0DT+zoxsk4CUh2pFll8n3mu4=";
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

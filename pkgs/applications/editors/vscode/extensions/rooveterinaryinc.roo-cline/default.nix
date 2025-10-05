{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pnpm,
  nodejs,
  vscode-utils,
  nix-update-script,
}:

let
  vsix = stdenvNoCC.mkDerivation (finalAttrs: {
    name = "roo-code-${finalAttrs.version}.zip";
    pname = "roo-code-vsix";
    version = "3.34.7";

    src = fetchFromGitHub {
      owner = "RooCodeInc";
      repo = "Roo-Code";
      tag = "v${finalAttrs.version}";
      hash = "sha256-ptSelnPvAT2Dd+bGSZsPF3SA1ifBIkxK9drQguAoLDw=";
    };

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 2;
      hash = "sha256-8Hnr+tyf1K3kY/E6RqIWHkfYVK29zl9Ze4w02/UAs7U=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
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

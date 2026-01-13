{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeBinaryWrapper,
  nix-update-script,
  nodejs,
  pnpm,
  pnpmConfigHook,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "e-invoice-eu";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "gflohr";
    repo = "e-invoice-eu";
    tag = "v${finalAttrs.version}";
    hash = "";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "";
    fetcherVersion = 3;
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpmConfigHook
    pnpm
  ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter "@e-invoice-eu/cli" build

    runHook postBuild
  '';

  env.CI = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/cli
    mkdir $out/bin

    # Re-install only production dependencies
    rm -rf node_modules packages/*/node_modules apps/*/node_modules
    pnpm config set nodeLinker hoisted
    pnpm config set preferSymlinkedExecutables false
    pnpm --filter @e-invoice-eu/cli install --offline --prod --ignore-scripts

    cp -r apps/cli/dist $out/lib/node_modules/cli/
    cp -rL node_modules $out/lib/node_modules/cli/

    makeWrapper ${lib.getExe nodejs} $out/bin/e-invoice-eu \
      --add-flags $out/lib/node_modules/cli/dist/index.js

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Generate e-invoices conforming to EN16931 (Factur-X/ZUGFeRD, UBL, CII, XRechnung aka X-Rechnung) from LibreOffice Calc/Excel data or JSON";
    mainProgram = "e-invoice-eu";
    homepage = "https://github.com/gflohr/e-invoice-eu";
    changelog = "https://github.com/gflohr/e-invoice-eu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ derdennisop ];
    inherit (nodejs.meta) platforms;
  };
})

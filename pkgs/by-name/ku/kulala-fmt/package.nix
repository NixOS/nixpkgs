{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  kulala-core,
  makeBinaryWrapper,
  nodejs,
  pnpm_11,
  pnpmConfigHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kulala-fmt";
  version = "4.3.4";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mistweaverco";
    repo = "kulala-fmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sARZDtrF8JihVuE2Ix/f4h/OWIbdGW48xpVJlVmTdYY=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-wPMWFYRd3R570oAMORHTKamE0qcmIT+LFRuTiXFX97M=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpm_11
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/cli.cjs $out/lib/kulala-fmt/cli.cjs
    makeBinaryWrapper ${lib.getExe nodejs} $out/bin/kulala-fmt \
      --add-flags $out/lib/kulala-fmt/cli.cjs \
      --set KULALA_CORE_PATH ${lib.getExe kulala-core}

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/kulala-fmt --version | grep -x ${lib.escapeShellArg finalAttrs.version}
    printf '%s\n' 'GET https://example.com' | $out/bin/kulala-fmt format --stdin | grep 'GET https://example.com'

    runHook postInstallCheck
  '';

  meta = {
    description = "Opinionated .http and .rest files linter and formatter";
    homepage = "https://github.com/mistweaverco/kulala-fmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ CnTeng ];
    mainProgram = "kulala-fmt";
    platforms = nodejs.meta.platforms;
  };
})

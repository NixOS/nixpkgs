{
  fetchFromGitHub,
  fetchPnpmDeps,
  lib,
  makeWrapper,
  nodejs_22,
  pnpmConfigHook,
  pnpm_11,
  stdenvNoCC,
}:
let
  pnpm = pnpm_11;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "otel-gui";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "metafab";
    repo = "otel-gui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EClh/Vr5myf4SsyXl70bl11rwZXyRRQKUw2XC1ECXE4=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs_22
    pnpm
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname src version;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-rwH9sgRhUJiiHPBFEElRTwB6PkFKMy0sez5baAm1BpE=";
  };

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail '"packageManager": "pnpm@11.13.0"' \
        '"packageManager": "pnpm@11.27.0"'
  '';

  buildPhase = ''
    runHook preBuild
    pnpm run build
    pnpm run sea:bundle
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    CI=true pnpm install --prod --offline --frozen-lockfile --ignore-scripts

    appDir="$out/lib/otel-gui"
    mkdir -p "$appDir" "$out/bin"
    cp -r build node_modules package.json packages proto "$appDir/"
    cp dist/sea-launcher.cjs "$appDir/otel-gui.cjs"

    makeWrapper ${nodejs_22}/bin/node "$out/bin/otel-gui" \
      --add-flags "$appDir/otel-gui.cjs"
    runHook postInstall
  '';

  meta = {
    description = "Lightweight OpenTelemetry viewer for traces, logs, and metrics";
    homepage = "https://github.com/metafab/otel-gui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ metafab ];
    mainProgram = "otel-gui";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})

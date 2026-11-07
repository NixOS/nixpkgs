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
  version = "3.1.0";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "metafab";
    repo = "otel-gui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nMe2qmy9SxmNZR6LHREOIQc5wjwS6TFKL/a3UBIzDO8=";
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
    hash = "sha256-/XmdWuECHUdhNifnum7P0E4r59tsH4eX+D15meb09AA=";
  };

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

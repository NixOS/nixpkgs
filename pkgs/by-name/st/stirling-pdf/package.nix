{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  rustPlatform,

  cargo,
  cargo-tauri,
  go-task,
  gradle_8,
  makeBinaryWrapper,
  nodejs,
  npmHooks,
  pkg-config,
  wrapGAppsHook3,

  glib-networking,
  jdk25,
  libsoup_3,
  openssl,
  webkitgtk_4_1,

  nix-update-script,
  nixosTests,

  isDesktopVariant ? false,
  withAdditionalFeatures ? !isDesktopVariant,
  buildWithFrontend ? !isDesktopVariant,
}:

# you may only toggle this when building the server
assert isDesktopVariant -> !buildWithFrontend;

let
  gradle = gradle_8;
  jre = jdk25;
in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "stirling-pdf" + lib.optionalString isDesktopVariant "-desktop";
  version = "2.14.3";

  src = fetchFromGitHub {
    owner = "Stirling-Tools";
    repo = "Stirling-PDF";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jh7F3e7Zho3BlaBZD8xfXSCjwXyF5qQk4VSm8DIwIBY=";
  };

  patches = [
    # remove timestamp from the header of a generated .properties file
    ./remove-props-file-timestamp.patch

    # tests require network facilities intentionally unavailable in the Nix sandbox
    ./skip-sandbox-incompatible-tests.patch

    ./skip-tests-with-expired-certs.patch
  ];

  postPatch = lib.optionalString isDesktopVariant ''
    # Nixpkgs does not produce artifacts for Stirling-PDF's upstream updater
    # and does not have access to upstream's private signing key.
    substituteInPlace frontend/editor/src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'
  '';

  npmRoot = "frontend";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src patches;
    postPatch = "cd ${finalAttrs.npmRoot}";
    hash = "sha256-3JYcOtX0pBMIgUtcK6LoejIhoSR2jpnQRzhePdCfJzI=";
  };

  cargoRoot = "frontend/editor/src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      cargoRoot
      ;
    hash = "sha256-YhDFSmx6XK7x5wzQaPslyuaRbiX8W/X8y/Z0fxjbGwk=";
  };

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  env = {
    PUPPETEER_SKIP_DOWNLOAD = "1";
    DISABLE_ADDITIONAL_FEATURES = if withAdditionalFeatures then "false" else "true";
  };

  gradleFlags = [
    "-PnoSpotless" # disable spotless because it tries to fetch files not in deps.json and also because it slows down the build process
  ]
  ++ lib.optionals buildWithFrontend [ "-PbuildWithFrontend=true" ];

  doCheck = true;

  nativeBuildInputs = [
    go-task
    gradle
    jre # one of the tests also require that the `java` command is available on the command line
    makeBinaryWrapper
  ]
  ++ lib.optionals (buildWithFrontend || isDesktopVariant) [
    nodejs
    npmHooks.npmConfigHook
  ]
  ++ lib.optionals isDesktopVariant [
    cargo
    cargo-tauri.hook
    rustPlatform.cargoSetupHook
  ]
  ++ lib.optionals (isDesktopVariant && stdenv.hostPlatform.isLinux) [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = lib.optionals (isDesktopVariant && stdenv.hostPlatform.isLinux) [
    glib-networking
    libsoup_3
    openssl
    webkitgtk_4_1
  ];

  dontUseGradleBuild = isDesktopVariant; # we'll use the buildPhase from cargo-tauri-hook for the desktop app

  # prepare the resources before building the desktop app
  preBuild = lib.optionals isDesktopVariant ''
    MODE=desktop task frontend:prepare

    # this simulates what the desktop:jlink:jar would do
    gradle bootJar
    install -Dm644 ./app/core/build/libs/stirling-pdf-*.jar -t ./frontend/editor/src-tauri/libs

    # creates as minimal jre via jlink
    task desktop:jlink:runtime

    substituteInPlace frontend/editor/src-tauri/stirling-pdf.desktop \
      --replace-fail 'MimeType=application/pdf;' 'MimeType=application/pdf;x-scheme-handler/stirlingpdf;'
  '';

  # we use the installPhase from cargo-tauri-hook when we're building the desktop variant
  installPhase = lib.optionalString (!isDesktopVariant) ''
    runHook preInstall

    install -Dm644 ./app/core/build/libs/stirling-pdf-*.jar $out/share/stirling-pdf/Stirling-PDF.jar
    makeWrapper ${lib.getExe jre} $out/bin/Stirling-PDF \
      --add-flags "-jar $out/share/stirling-pdf/Stirling-PDF.jar"

    runHook postInstall
  '';

  postInstall = lib.optionalString (isDesktopVariant && stdenv.hostPlatform.isDarwin) ''
    makeWrapper "$out/Applications/Stirling PDF.app/Contents/MacOS/Stirling-PDF" "$out/bin/stirling-pdf"
  '';

  passthru = {
    tests = {
      inherit (nixosTests) stirling-pdf-desktop; # TODO: fix or remove
    };
  }
  // lib.optionalAttrs (!isDesktopVariant) {
    # this being optional makes the auto-update PRs always put stirling-pdf in the title
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v${finalAttrs.version}";
    description =
      "Powerful, open-source PDF editing platform "
      + (if isDesktopVariant then "runnable as a desktop app" else "hostable as a web app");
    homepage = "https://github.com/Stirling-Tools/Stirling-PDF";
    license = lib.licenses.mit; # TODO: figure out what proper licensing should be
    mainProgram = if isDesktopVariant then "stirling-pdf" else "Stirling-PDF";
    maintainers = with lib.maintainers; [
      tomasajt
      staticdev
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # java deps
      binaryNativeCode # bundled jpdfium inside jar
    ];
  };
})

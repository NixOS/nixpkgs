{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  rustPlatform,

  cargo,
  cargo-tauri,
  go-task,
  gradle_9,
  makeBinaryWrapper,
  nodejs,
  npmHooks,
  pkg-config,
  python3,
  wrapGAppsHook3,

  glib-networking,
  jdk25,
  libsoup_3,
  openssl,
  webkitgtk_4_1,

  nix-update-script,
  nixosTests,
  stirling-pdf,

  isDesktopVariant ? false,
  withAdditionalFeatures ? !isDesktopVariant,
  buildWithFrontend ? !isDesktopVariant,
}:

# you may only toggle this when building the server
assert isDesktopVariant -> !buildWithFrontend;

let
  gradle = gradle_9;
  jre = jdk25;
  python = python3.withPackages (ps: [ ps.fonttools ]);
in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname =
    "stirling-pdf"
    + lib.optionalString isDesktopVariant "-desktop"
    + lib.optionalString (!isDesktopVariant && !withAdditionalFeatures) "-free";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "Stirling-Tools";
    repo = "Stirling-PDF";
    tag = "v${finalAttrs.version}";
    hash =
      if withAdditionalFeatures || isDesktopVariant then
        "sha256-YhXyEFGWL3Z6vJadxK5asZe30OTQpRU6htTvd+/NYdA="
      else
        "sha256-T+3PbRluwjjQi+RoISciG/pWLgu56ld5ATa93UkgKLc=";
    # The public cache must not distribute directories under the upstream
    # User License when building the MIT-only server.
    postFetch = lib.optionalString (!withAdditionalFeatures && !isDesktopVariant) ''
      rm -rf "$out/app/proprietary" "$out/app/saas" "$out/engine"
      rm -rf "$out/frontend/editor/src/"{proprietary,desktop,saas,cloud,prototypes,portal,portal-saas}
    '';
  };

  patches = [
    # remove timestamp from the header of a generated .properties file
    ./remove-props-file-timestamp.patch

    # JPDFium declares Linux x64 as a transitive runtime dependency on every host.
    ./select-host-jpdfium-native.patch

    # tests require network facilities intentionally unavailable in the Nix sandbox
    ./skip-sandbox-incompatible-tests.patch
  ]
  ++ lib.optionals (withAdditionalFeatures || isDesktopVariant) [
    ./skip-proprietary-network-test.patch
    # Upstream corpus tests filter /build from absolute paths, hiding every fixture in Nix builds.
    ./fix-corpus-tests-in-build-directory.patch
  ]
  ++ lib.optionals (!withAdditionalFeatures && !isDesktopVariant) [ ./free-source.patch ];

  postPatch = lib.optionalString isDesktopVariant ''
    # Nixpkgs does not produce artifacts for Stirling-PDF's upstream updater
    # and does not have access to upstream's private signing key.
    substituteInPlace frontend/editor/src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'
  '';

  npmRoot = "frontend";

  npmDeps = fetchNpmDeps {
    name = "stirling-pdf-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src patches;
    postPatch = "cd ${finalAttrs.npmRoot}";
    hash = "sha256-UQfkdERCa2Bl+E+yXJCzW98wL01+f6IE5A+QQ/iQtLk=";
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
    hash = "sha256-dSk5zpMvY5qZ82TxRPOk/siicaPSTUyHm6Z6FuJzSqw=";
  };

  mitmCache = gradle.fetchDeps {
    # The shared lock is generated from the full source so it covers both
    # server variants without adding the restricted source to the free output.
    pkg = if withAdditionalFeatures || isDesktopVariant then finalAttrs.finalPackage else stirling-pdf;
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

  gradleUpdateScript = ''
    runHook preBuild
    runHook preGradleUpdate

    # The build selects one JPDFium native jar for its host. Cache every
    # upstream platform and both feature variants in the same lockfile.
    DISABLE_ADDITIONAL_FEATURES=false gradle nixDownloadDeps -PjpdfiumPlatforms=all
    DISABLE_ADDITIONAL_FEATURES=true gradle nixDownloadDeps -PjpdfiumPlatforms=all

    runHook postGradleUpdate
  '';

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
  preBuild = lib.optionalString isDesktopVariant ''
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
    install -Dm644 ./scripts/convert_cff_to_ttf.py $out/share/stirling-pdf/scripts/convert_cff_to_ttf.py
    makeWrapper ${lib.getExe jre} $out/bin/Stirling-PDF \
      --add-flags "-jar $out/share/stirling-pdf/Stirling-PDF.jar" \
      --set-default PDFEDITOR_CFFCONVERTER_PYTHONCOMMAND ${lib.getExe python} \
      --set-default PDFEDITOR_CFFCONVERTER_PYTHONSCRIPT $out/share/stirling-pdf/scripts/convert_cff_to_ttf.py

    runHook postInstall
  '';

  postInstall = ''
    install -Dm644 LICENSE $out/share/licenses/stirling-pdf/LICENSE
  ''
  + lib.optionalString withAdditionalFeatures ''
    install -Dm644 app/proprietary/LICENSE $out/share/licenses/stirling-pdf/app-proprietary-LICENSE
    install -Dm644 frontend/editor/src/proprietary/LICENSE $out/share/licenses/stirling-pdf/frontend-proprietary-LICENSE
  ''
  + lib.optionalString isDesktopVariant ''
    install -Dm644 frontend/editor/src/desktop/LICENSE $out/share/licenses/stirling-pdf/frontend-desktop-LICENSE
    install -Dm644 frontend/editor/src/proprietary/LICENSE $out/share/licenses/stirling-pdf/frontend-proprietary-LICENSE
  ''
  + lib.optionalString (isDesktopVariant && stdenv.hostPlatform.isDarwin) ''
    makeWrapper "$out/Applications/Stirling PDF.app/Contents/MacOS/Stirling-PDF" "$out/bin/stirling-pdf"
  '';

  passthru = {
    tests = {
      inherit (nixosTests) stirling-pdf-desktop; # TODO: fix or remove
    }
    // lib.optionalAttrs (!isDesktopVariant) {
      inherit (nixosTests) stirling-pdf;
    };
  }
  // lib.optionalAttrs (!isDesktopVariant && withAdditionalFeatures) {
    # this being optional makes the auto-update PRs always put stirling-pdf in the title
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v${finalAttrs.version}";
    description =
      "PDF editing platform "
      + (if isDesktopVariant then "runnable as a desktop app" else "hostable as a web app");
    homepage = "https://github.com/Stirling-Tools/Stirling-PDF";
    license =
      if withAdditionalFeatures || isDesktopVariant then
        [
          lib.licenses.mit
          lib.licenses.unfree
        ]
      else
        lib.licenses.mit;
    mainProgram = if isDesktopVariant then "stirling-pdf" else "Stirling-PDF";
    maintainers = with lib.maintainers; [
      tomasajt
      staticdev
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # java deps
      binaryNativeCode # bundled jpdfium inside jar
    ];
  };
})

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
  pax-utils,
  pkg-config,
  unzip,
  wrapGAppsHook3,
  zip,

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
  # jpdfium 1.0.2's bundled x86_64 libicudata.so.74 has an erroneous executable
  # PT_GNU_STACK; the arm64 archive was checked and already has a non-executable stack.
  # Fixed upstream for the next natives release; remove when Stirling-PDF updates jpdfium.
  # https://github.com/Stirling-Tools/Stirling-PDF/issues/6869
  # https://github.com/Stirling-Tools/JPDFium/pull/19
  patchJpdfium = lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) ''
    nativeJars=(
      "$GRADLE_USER_HOME"/caches/modules-2/files-2.1/com.stirling/jpdfium-natives-linux-x64/*/*/jpdfium-natives-linux-x64-*.jar
    )
    if (( ''${#nativeJars[@]} != 1 )); then
      echo "expected exactly one jpdfium native JAR, found ''${#nativeJars[@]}" >&2
      exit 1
    fi
    nativeJar="''${nativeJars[0]}"

    patchDir="$(mktemp -d)"
    unzip -q "$nativeJar" natives/linux-x64/libicudata.so.74 -d "$patchDir"
    scanelf -X -e "$patchDir/natives/linux-x64/libicudata.so.74"
    touch --date=@315532800 "$patchDir/natives/linux-x64/libicudata.so.74"

    chmod u+w "$nativeJar"
    (cd "$patchDir" && zip -q -X "$nativeJar" natives/linux-x64/libicudata.so.74)

    bootJars=( ./app/core/build/libs/stirling-pdf-*.jar )
    if (( ''${#bootJars[@]} != 1 )); then
      echo "expected exactly one Stirling-PDF JAR, found ''${#bootJars[@]}" >&2
      exit 1
    fi
    bootJar="$(realpath "''${bootJars[0]}")"
    nestedJar="BOOT-INF/lib/$(basename "$nativeJar")"
    mkdir -p "$patchDir/$(dirname "$nestedJar")"
    cp "$nativeJar" "$patchDir/$nestedJar"
    touch --date=@315532800 "$patchDir/$nestedJar"

    chmod u+w "$bootJar"
    (cd "$patchDir" && zip -q -X -0 "$bootJar" "$nestedJar")
    rm -rf "$patchDir"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "stirling-pdf" + lib.optionalString isDesktopVariant "-desktop";
  version = "2.14.2";

  src = fetchFromGitHub {
    owner = "Stirling-Tools";
    repo = "Stirling-PDF";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2u4d9K4OEuOw9qE4YgpGXDvVLExVGUKAeXYNCySqy1c=";
  };

  patches = [
    # remove timestamp from the header of a generated .properties file
    ./remove-props-file-timestamp.patch

    # tests require network facilities intentionally unavailable in the Nix sandbox
    ./skip-sandbox-incompatible-tests.patch
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
    hash = "sha256-ujvSzang7n6DJZbNU/lDlG0x1265N5LJ6prkPbBYEic=";
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
    pax-utils
    unzip
    zip
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
    ${patchJpdfium}
    install -Dm644 ./app/core/build/libs/stirling-pdf-*.jar -t ./frontend/editor/src-tauri/libs

    # creates as minimal jre via jlink
    task desktop:jlink:runtime

    substituteInPlace frontend/editor/src-tauri/stirling-pdf.desktop \
      --replace-fail 'MimeType=application/pdf;' 'MimeType=application/pdf;x-scheme-handler/stirlingpdf;'
  '';

  postBuild = lib.optionalString (!isDesktopVariant) patchJpdfium;

  # we use the installPhase from cargo-tauri-hook when we're building the desktop variant
  installPhase = lib.optionalString (!isDesktopVariant) ''
    runHook preInstall

    install -Dm644 ./app/core/build/libs/stirling-pdf-*.jar $out/share/stirling-pdf/Stirling-PDF.jar
    makeWrapper ${lib.getExe jre} $out/bin/Stirling-PDF \
      --add-flags "-jar $out/share/stirling-pdf/Stirling-PDF.jar"

    runHook postInstall
  '';

  postInstall = lib.optionalString (isDesktopVariant && stdenv.hostPlatform.isDarwin) ''
    makeWrapper "$out/Applications/Stirling-PDF.app/Contents/MacOS/stirling-pdf" "$out/bin/stirling-pdf"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) stirling-pdf-desktop; };
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

{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  rustPlatform,

  cargo,
  cargo-tauri,
  gradle_8,
  makeBinaryWrapper,
  nodejs,
  npmHooks,
  pkg-config,
  wrapGAppsHook3,

  glib-networking,
  jre,
  libsoup_3,
  openssl,
  webkitgtk_4_1,

  isDesktopVariant, # set in all-packages.nix
  buildWithFrontend ? !isDesktopVariant,
}:

# you may only toggle this when building the server
assert isDesktopVariant -> !buildWithFrontend;

let
  gradle = gradle_8;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "stirling-pdf" + lib.optionalString isDesktopVariant "-desktop";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "Stirling-Tools";
    repo = "Stirling-PDF";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vFahWnJ7GsRgqSduVW/cqBY5OkKcS66qGX/9QVnzve0=";
  };

  patches = [
    # remove timestamp from the header of a generated .properties file
    ./remove-props-file-timestamp.patch
  ];

  npmRoot = "frontend";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src patches;
    postPatch = "cd ${finalAttrs.npmRoot}";
    hash = "sha256-zuw3pIvTzV1pr3oQqDJfm6pukMyeX0KYPNsT1vBHojY=";
  };

  cargoRoot = "frontend/src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      cargoRoot
      ;
    hash = "sha256-ZfXLHjf1ufqtmTF+GXfWrGAoEK8JlFw/z1F8fKYerTU=";
  };

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  # we'll trigger it manually in postBuild
  dontTauriBuild = true;

  env.PUPPETEER_SKIP_DOWNLOAD = "1";

  # disable spotless because it tries to fetch files not in deps.json
  # and also because it slows down the build process
  gradleFlags = [
    "-x"
    "spotlessApply"
    "-DDISABLE_ADDITIONAL_FEATURES=true"
  ]
  ++ lib.optionals buildWithFrontend [ "-PbuildWithFrontend=true" ];

  doCheck = true;

  nativeBuildInputs = [
    gradle
    gradle.jdk # one of the tests also require that the `java` command is available on the command line
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

  postBuild = lib.optionalString isDesktopVariant ''
    install -Dm644 ./app/core/build/libs/stirling-pdf-*.jar -t ./frontend/src-tauri/libs
    mkdir -p ./frontend/src-tauri/runtime/
    ln -s ${jre} ./frontend/src-tauri/runtime/jre

    # Unset these, since tauriBuildHook would recursively call them
    unset preBuild postBuild
    tauriBuildHook
  '';

  # we use the installPhase from cargo-tauri-hook when we're building the desktop variant
  installPhase = lib.optionalString (!isDesktopVariant) ''
    runHook preInstall

    install -Dm644 ./app/core/build/libs/stirling-pdf-*.jar $out/share/stirling-pdf/Stirling-PDF.jar
    makeWrapper ${lib.getExe jre} $out/bin/Stirling-PDF \
      --add-flags "-jar $out/share/stirling-pdf/Stirling-PDF.jar"

    runHook postInstall
  '';

  # tauri installs the jre without preserving symlinks
  # so we just symlink it again into the install location
  # on darwin, we also create a wrapper for the binary inside the app bundle
  postInstall = lib.optionalString isDesktopVariant ''
    res_dir="$out/lib/Stirling-PDF/"
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      res_dir="$out/Applications/Stirling-PDF.app/Contents/Resources"
      makeWrapper "$out/Applications/Stirling-PDF.app/Contents/MacOS/stirling-pdf" "$out/bin/stirling-pdf"
    ''}
    rm -r "$res_dir/runtime/jre"
    ln -s ${jre} "$res_dir/runtime/jre"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v${finalAttrs.version}";
    description =
      "Powerful, open-source PDF editing platform "
      + (if isDesktopVariant then "runnable as a desktop app" else "hostable as a web app");
    homepage = "https://github.com/Stirling-Tools/Stirling-PDF";
    license = lib.licenses.mit;
    mainProgram = if isDesktopVariant then "stirling-pdf" else "Stirling-PDF";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # java deps
    ];
  };
})

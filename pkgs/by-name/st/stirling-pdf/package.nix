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
  jdk25,
  libsoup_3,
  openssl,
  webkitgtk_4_1,

  nix-update-script,

  isDesktopVariant ? false,
  buildWithFrontend ? !isDesktopVariant,

  callPackage,
}:

# you may only toggle this when building the server
assert isDesktopVariant -> !buildWithFrontend;

let
  gradle = gradle_8;
  jre = jdk25;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "stirling-pdf" + lib.optionalString isDesktopVariant "-desktop";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "Stirling-Tools";
    repo = "Stirling-PDF";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nsC/U+9kJo0i5Sh2u+OrjzDO6YREKjVAe+1KBKgtybY=";
  };

  patches = [
    # remove timestamp from the header of a generated .properties file
    ./remove-props-file-timestamp.patch

    # Note: only affects the desktop variant
    # fix path to the stirling-pdf binary
    # and add support for the stirlingpdf:// protocol
    ./fix-desktop-file.patch
  ];

  npmRoot = "frontend";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src patches;
    postPatch = "cd ${finalAttrs.npmRoot}";
    hash = "sha256-uMWc/yoOWFtP2JTMr69V/nRPu9YfrGxqvBnOw2DZkQQ=";
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
    hash = "sha256-JvrZKgTmPGP6m95GBr/UJo1FLaR86KSmJ9LzLlzQhfE=";
  };

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  # we'll trigger it manually in postBuild
  dontTauriBuild = true;

  env = {
    PUPPETEER_SKIP_DOWNLOAD = "1";
    # taken from here https://github.com/Stirling-Tools/Stirling-PDF/blob/main/.github/workflows/tauri-build.yml#L346-L348
    VITE_SUPABASE_PUBLISHABLE_DEFAULT_KEY = "sb_publishable_UHz2SVRF5mvdrPHWkRteyA_yNlZTkYb";
    VITE_SAAS_SERVER_URL = "https://app.stirlingpdf.com";
    VITE_SAAS_BACKEND_API_URL = "https://api.stirlingpdf.com";
  };

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

  passthru = {
    services.default = {
      imports = [
        # do what importApply does without duplicating tons of arguments
        (lib.setDefaultModuleLocation ./service.nix (callPackage ./service.nix { }))
      ];
      stirling-pdf.package = lib.mkDefault finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
    tests = callPackage ./tests { };
  };

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

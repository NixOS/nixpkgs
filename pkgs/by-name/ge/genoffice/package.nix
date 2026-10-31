{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  rustPlatform,
  gtk3,
  libnotify,
  nss,
  libxscrnsaver,
  libxtst,
  at-spi2-core,
  libuuid,
  libsecret,
  libappindicator,
  makeWrapper,
  nodejs_22,
  electron_43,
  cargo,
  rustc,
  pkg-config,
  libglvnd,
  makeDesktopItem,
  copyDesktopItems,
}:

buildNpmPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "genoffice";
  version = "0.12.29";
  nodejs = nodejs_22;
  npmDepsHash = "sha256-M3RiWGnEByNwaRO4nxNEs57/FM3Fbu+LnUnH46bv0xg=";

  src = fetchFromGitHub {
    owner = "genspark-ai";
    repo = "genoffice";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OxZxMH/mHNkJ8Fp2yCqraYRUz7QrJzuIZTjHhUpLFgc=";
  };

  buildInputs = [
    gtk3
    libnotify
    nss
    libxscrnsaver
    libxtst
    at-spi2-core
    libuuid
    libsecret
    libappindicator
    libglvnd
  ];

  postPatch = ''
    substituteInPlace apps/shell/electron-builder.cjs \
      --replace-fail \
        "afterAllArtifactBuild: 'build/notarize-dmg.js'," \
        ""
  '';

  npmDepsFetcherVersion = 2;
  npmBuildScript = "build:all";
  postBuild = ''
    mkdir -p node_modules/electron/dist

    ln -s \
      ${electron_43}/libexec/electron/LICENSES.chromium.html \
      node_modules/electron/dist/LICENSES.chromium.html

    ./node_modules/.bin/electron-builder \
      --projectDir apps/shell \
      --linux \
      --x64 \
      --dir \
      -c.electronDist=${electron_43}/libexec/electron \
      -c.electronVersion=${electron_43.version}
  '';
  npmFlags = [ "--ignore-scripts" ];
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  cargoRoot = "apps/sheets/native/xlsx-engine";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-0oqiWvxWxdz4Rtb0h8zcL4C4wQKkDokZvnAQqAhqbHI=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    pkg-config
    cargo
    rustPlatform.cargoSetupHook
    rustc
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "genoffice";
      desktopName = "GenOffice";
      exec = "genoffice %U";
      icon = "genoffice";
      comment = "AI-native office suite";
      categories = [ "Office" ];
      startupWMClass = "genoffice";
    })
  ];

  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/libexec/genoffice" "$out/bin"

    # Keep the complete unpacked Electron application.  Launching app.asar with
    # the system Electron makes Electron think this is an unpackaged app and
    # points process.resourcesPath at the Electron package instead of here.
    cp -r apps/shell/release/linux-unpacked/. "$out/libexec/genoffice/"

    makeWrapper "$out/libexec/genoffice/genoffice" "$out/bin/genoffice" \
      --add-flags "--no-sandbox" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libglvnd ]}" \
      --inherit-argv0

    for size in 16 32 48 64 128 256 512 1024; do
      install -Dm644 "apps/shell/build/icons/''${size}x''${size}.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/genoffice.png"
    done

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    resources="$out/libexec/genoffice/resources"

    echo "Checking GenOffice resources..."

    for file in \
      "$resources/app.asar" \
      "$resources/native/xlsx-sidecar" \
      "$resources/wasm/pdfium.wasm" \
      "$resources/wasm/hb-subset.wasm"; do
      if [ ! -f "$file" ]; then
        echo "Missing: $file" >&2
        exit 1
      fi
    done

    for module in docs sheets slides pdf markdown html; do
      if [ ! -f "$resources/modules/$module/main/index.js" ]; then
        echo "Missing module: $module" >&2
        exit 1
      fi
    done

    test -x "$resources/native/xlsx-sidecar"
    test -x "$out/bin/genoffice"
    test -x "$out/libexec/genoffice/genoffice"

    runHook postInstallCheck
  '';

  meta = {
    description = "AI-native office suite: Word, Excel, PowerPoint, PDF and Markdown in one local app";
    homepage = "https://genoffice.ai/";
    downloadPage = "https://github.com/genspark-ai/genoffice/releases";
    mainProgram = "genoffice";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kmalone42 ];
    platforms = [ "x86_64-linux" ];
  };
})

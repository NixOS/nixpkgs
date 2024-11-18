{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  wrapGAppsHook3,
  glib-networking,
  gst_all_1,
  libayatana-appindicator,
  nodejs,
  openssl,
  pkg-config,
  yq-go,
  pnpm,
  webkitgtk_4_1,
  copyDesktopItems,
  cargo-tauri,
  desktop-file-utils,
}:

let
  webkitgtk_4_1' = webkitgtk_4_1.override {
    enableExperimental = true;
  };

  shelter = fetchurl {
    url = "https://raw.githubusercontent.com/uwu/shelter-builds/c6fb071f74089639a7b2b6177144d31192cbf916/shelter.js";
    hash = "sha256-2zMvRITkgNnLJvKYtdMHwyXKaC8yIwjUezqYmsihz+o=";
    meta = {
      homepage = "https://github.com/uwu/shelter";
      sourceProvenance = [ lib.sourceTypes.binaryBytecode ]; # actually, minified JS
      license = lib.licenses.cc0;
    };
  };
in

# buildRustPackage doesn't respect cargoRoot
# ..so use stdenv.mkDerivation and rust hooks instead (see #350541)
stdenv.mkDerivation (finalAttrs: {
  pname = "dorion";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "SpikeHD";
    repo = "Dorion";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7isOL/853IMOUkepbu81INNFgjTHpo9dyvPaxMkBU1U=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.cargoRoot}";
    hash = "sha256-SX6OsGQK8Asj+vXiwK9W/wlYzP7DxRrPmi1EXWQsGQs=";
    patches = [
      ./cargo-lock.patch
    ];
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-qrB+IpuAhoiKfwZvfF8RSZbiyASGIABmYUd70iqSPyw=";
  };

  nativeBuildInputs = [
    pnpm.configHook
    rustPlatform.cargoSetupHook
    cargo-tauri.hook
    rustPlatform.cargoCheckHook
    nodejs
    pkg-config
    wrapGAppsHook3
    yq-go
    desktop-file-utils
    copyDesktopItems
  ];

  buildInputs = [
    openssl
    webkitgtk_4_1
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    glib-networking
    libayatana-appindicator
  ];

  runtimeDependencies = [
    libayatana-appindicator
  ];

  patches = [
    ./cargo-toml.patch
  ];

  postPatch = ''
    # apply cargo-lock patch (we have to do it from src-tauri subdir so cant use patches = [..])
    (cd /build/source/src-tauri && patch -p1 < ${./cargo-lock.patch})

    # patch cargo-deps
    (cd $cargoDepsCopy/tauri-plugin-shell-* && patch -p1 < /build/source/src-tauri/patches/tauri-plugin-shell+2.0.1.patch)
    (cd $cargoDepsCopy/tauri-utils-* && patch -p3 <${./tauri-env-resource-dir.patch})
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"

    # disable pre-build script and disable auto-updater
    yq -iPo=json '
        .bundle.resources = (.bundle.resources | map(select(. != "updater*")))
    ' /build/source/src-tauri/tauri.conf.json

    # copy shelter injection
    cp ${shelter} /build/source/src-tauri/injection/shelter.js

    # Very hacky and 99% sure its not even right
    mkdir -p /build/source/src-tauri/html
    cp -r /build/source/src/* /build/source/src-tauri/html
  '';

  preBuild = ''
    pnpm build:js
  '';

  postInstall = ''
    mkdir -p $out/lib/dorion
    cp -r /build/source/src-tauri/{injection,html} $out/lib/dorion
    desktop-file-edit \
      --set-comment "Tiny alternative Discord client" \
      --set-key="Exec" --set-value="Dorion %U" \
      --set-key="TryExec" --set-value="Dorion" \
      --set-key="StartupWMClass" --set-value="Dorion" \
      --set-key="StartupNotify" --set-value="true" \
      --set-key="Categories" --set-value="Network;InstantMessaging;Chat;" \
      --set-key="Keywords" --set-value="dorion;discord;vencord;chat;im;vc;ds;dc;dsc;tauri;" \
      --set-key="Terminal" --set-value="false" \
      --set-key="MimeType" --set-value="x-scheme-handler/discord" \
      $out/share/applications/dorion.desktop
  '';

  env = {
    TAURI_RESOURCE_DIR = "${placeholder "out"}/lib";
  };

  meta = {
    homepage = "https://spikehd.github.io/projects/dorion/";
    description = "Tiny alternative Discord client";
    longDescription = ''
      Dorion is an alternative Discord client aimed towards lower-spec or
      storage-sensitive PCs that supports themes, plugins, and more!
    '';
    changelog = "https://github.com/SpikeHD/Dorion/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/SpikeHD/Dorion/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "Dorion";
    maintainers = with lib.maintainers; [
      nyabinary
      aleksana
      griffi-gh
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = [
      lib.sourceTypes.binaryBytecode # actually, minified JS
      lib.sourceTypes.fromSource
    ];
  };
})

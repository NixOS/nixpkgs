{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  cmake,
  ninja,
  makeBinaryWrapper,
  wrapGAppsHook4,
  glib-networking,
  gst_all_1,
  libsysprof-capture,
  libayatana-appindicator,
  nodejs,
  openssl,
  pkg-config,
  yq-go,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  webkitgtk_4_1,
  cargo-tauri,
  desktop-file-utils,
  pipewire,
  apple-sdk_15,
  darwin,
}:

let
  webkitgtk_4_1' = webkitgtk_4_1.override {
    enableExperimental = true;
  };

  shelter = fetchurl {
    url = "https://raw.githubusercontent.com/uwu/shelter-builds/7a1beaff4bb4ec5e8590d069549686fda4200e82/shelter.js";
    hash = "sha256-LeZTxrGRQb0rl3BMP34UFHIEFnil4k3Fet3MTujvVB8=";
    meta = {
      homepage = "https://github.com/uwu/shelter";
      sourceProvenance = [ lib.sourceTypes.binaryBytecode ]; # actually, minified JS
      license = lib.licenses.cc0;
    };
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dorion";
  version = "6.12.2";

  src = fetchFromGitHub {
    owner = "SpikeHD";
    repo = "Dorion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aPYQOec4D0I4N/6nmSwodXsh3pvcHnlD37fUIw5kMjo=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-3FS8w9K3Wx7KbT7iy+0pAMdmreZnL+ZFMSAnwesnS7Y=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-E45X3JEns1TE+SVbtbBEl+RzwRgTiGN7/N4OgJ5o63o=";
  };

  # CMake (webkit extension, Linux only)
  cmakeDir = ".";
  cmakeBuildDir = "src-tauri/extension_webkit";
  dontUseCmakeConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaCheck = true;
  dontUseNinjaInstall = true;
  cmakeFlags = [
    "-GNinja"
  ];

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_9
    cargo-tauri.hook
    nodejs
    pkg-config
    yq-go
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook4
    desktop-file-utils
    cmake
    ninja
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
    darwin.autoSignDarwinBinariesHook
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1'
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-rs
    glib-networking
    libsysprof-capture
    libayatana-appindicator
    pipewire
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

  postPatch = ''
    # remove updater
    rm -rf updater

    # disable pre-build script and disable auto-updater
    yq -iPo=json '
      .bundle.resources = (.bundle.resources | map(select(. != "updater*")))
    ' src-tauri/tauri.conf.json

    # link shelter injection
    ln -s "${shelter}" src-tauri/injection/shelter.js

    # link html/frontend data
    ln -s "$(pwd)/src" src-tauri/html
  ''
  # disable Tauri's built-in codesigning
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    yq -iPo=json '
      .bundle.macOS.signingIdentity = null
    ' src-tauri/tauri.conf.json
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace "$cargoDepsCopy"/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  configurePhase = ''
    runHook preConfigure
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    cmakeConfigurePhase
  ''
  + ''
    pnpmConfigHook
    runHook postConfigure
  '';

  buildPhase =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      ninjaBuildPhase
      cd ../..
    ''
    + ''
      tauriBuildHook
    '';

  postInstall = ''
    mkdir -p "$out/lib/Dorion"
    ln -s "$out/lib/Dorion" "$out/lib/dorion"
    rm -rf "$out/lib/Dorion/injection"
    cp -r src-tauri/injection "$out/lib/Dorion"
    cp -r src "$out/lib/Dorion"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
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
      "$out/share/applications/Dorion.desktop"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeBinaryWrapper "$out/Applications/Dorion.app/Contents/MacOS/Dorion" "$out/bin/Dorion"
  '';

  # error: failed to run custom build command for `Dorion v6.5.3 (/build/source/src-tauri)`
  # Permission denied (os error 13)
  doCheck = false;

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
    license = [
      lib.licenses.gpl3Only
      shelter.meta.license
    ];
    mainProgram = "Dorion";
    maintainers = with lib.maintainers; [
      nyabinary
      aleksana
      griffi-gh
      getchoo
    ];
    platforms = lib.platforms.unix;
    sourceProvenance = [
      lib.sourceTypes.binaryBytecode # actually, minified JS
      lib.sourceTypes.fromSource
    ];
  };
})

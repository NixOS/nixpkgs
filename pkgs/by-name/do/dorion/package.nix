{
  lib,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  cmake,
  ninja,
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
  fetchpatch,
  pipewire,
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
  version = "6.12.0";

  src = fetchFromGitHub {
    owner = "SpikeHD";
    repo = "Dorion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pykmoSiV3iSaD/V/Sd5GSV/BZWhk9XVg8io1j8wZv5k=";
  };

  patches = [
    # https://github.com/SpikeHD/Dorion/issues/419
    (fetchpatch {
      url = "https://github.com/SpikeHD/Dorion/commit/98d50dadd1a7fb018698a3fe61ac104cbe89b5d4.patch";
      hash = "sha256-1VbB2CVMUWw18lWC4EL83VS4SdC03AxDUKRq/hQNAAg=";
    })
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-FJ4gQKgZkYqvjcqcRapJ8IQWP52kIg4uOTxifKG8zyo=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-qSmIyLv8A+JDbTVG+Qcvq3gqBXBGtfbH4/tN+CvEmd8=";
  };

  # CMake (webkit extension)
  cmakeDir = ".";
  cmakeBuildDir = "src-tauri/extension_webkit";
  dontUseCmakeConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaCheck = true;
  dontUseNinjaInstall = true;
  # cmake's supposed to set this automatically
  # ... but the detection is based on the presence of ninja build hook
  cmakeFlags = [
    "-GNinja"
  ];

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_9
    cargo-tauri.hook
    nodejs
    pkg-config
    wrapGAppsHook4
    yq-go
    desktop-file-utils
    cmake
    ninja
  ];

  buildInputs = [
    openssl
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
  ];

  postPatch = ''
    # remove updater
    rm -rf updater

    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"

    # disable pre-build script and disable auto-updater
    yq -iPo=json '
      .bundle.resources = (.bundle.resources | map(select(. != "updater*")))
    ' src-tauri/tauri.conf.json

    # link shelter injection
    ln -s ${shelter} src-tauri/injection/shelter.js

    # link html/frontend data
    ln -s $(pwd)/src src-tauri/html
  '';

  configurePhase = ''
    runHook preConfigure

    cmakeConfigurePhase
    pnpmConfigHook

    runHook postConfigure
  '';

  buildPhase = ''
    ninjaBuildPhase
    cd ../..
    tauriBuildHook
  '';

  postInstall = ''
    # Set up the resource directories
    mkdir -p $out/lib/Dorion
    ln -s $out/lib/Dorion $out/lib/dorion
    rm -rf $out/lib/Dorion/injection
    cp -r src-tauri/injection $out/lib/Dorion
    cp -r src $out/lib/Dorion

    # Modify the desktop file
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
      $out/share/applications/Dorion.desktop
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
    platforms = lib.platforms.linux;
    sourceProvenance = [
      lib.sourceTypes.binaryBytecode # actually, minified JS
      lib.sourceTypes.fromSource
    ];
  };
})

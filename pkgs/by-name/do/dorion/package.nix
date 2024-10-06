{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  autoPatchelfHook,
  wrapGAppsHook3,
  glib-networking,
  gst_all_1,
  libappindicator,
  libayatana-appindicator,
  nodejs,
  openssl,
  pkg-config,
  yq-go,
  pnpm,
  webkitgtk_4_1,
  makeDesktopItem,
  copyDesktopItems,
}:

let
  pname = "dorion";
  version = "6.1.0";

  webkitgtk_4_1' = webkitgtk_4_1.override { enableExperimental = true; };

  src = fetchFromGitHub {
    owner = "SpikeHD";
    repo = "Dorion";
    rev = "v${version}";
    hash = "sha256-YkXFK/tOdi14otSNOR9IgkZb1EqplLJz6BkNrIkpnPc=";

    nativeBuildInputs = [ pnpm.configHook ];
  };

  shelter = fetchurl {
    url = "https://raw.githubusercontent.com/uwu/shelter-builds/69feda53ab1de14f3131a1432728a2b281a1f91e/shelter.js";
    hash = "sha256-wmXIe85ejWnhu+pyTsEEO+v3Z+XrKYuoUdiXr4cJFq8=";
    meta = {
      homepage = "https://github.com/uwu/shelter";
      sourceProvenance = [ lib.sourceTypes.binaryBytecode ]; # actually, minified JS
      license = lib.licenses.cc0;
    };
  };

  frontend = stdenv.mkDerivation {
    pname = "dorion-ui";
    inherit version src;

    pnpmDeps = pnpm.fetchDeps {
      inherit pname version src;
      hash = "sha256-Dy+nKepmGXKlFi5UBRKNFm/TN0m7ubu0PyxbwkFoMpc=";
    };

    nativeBuildInputs = [
      pnpm.configHook
      nodejs
      copyDesktopItems
    ];

    buildPhase = ''
      runHook preBuild

      cp ${shelter} src-tauri/injection/shelter.js
      pnpm build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r src-tauri/{injection,html} $out

      runHook postInstall
    '';
  };

in

rustPlatform.buildRustPackage {
  inherit pname version src;

  sourceRoot = "${src.name}/src-tauri";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rsrpc-0.16.3" = "sha256-40vvvtphTPEcyKlCZKUILrvy5ESx0yVHR2encIA4j9E=";
      "simple-websockets-0.1.6" = "sha256-iySzwntHw5Wf5HwKMBYL8mrMl7kjGZrZonL7/zrkeCo=";
      "window_titles-0.1.0" = "sha256-lk2T+6curAwqOUuQ8RtYCjX2ygGBgzt4ILBAMV+ql0w=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    yq-go
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    webkitgtk_4_1
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    glib-networking
  ];

  runtimeDependencies = [
    libappindicator
    libayatana-appindicator
  ];

  env = {
    TAURI_RESOURCE_DIR = "${placeholder "out"}/lib";
  };

  postPatch = ''
    # disable pre-build script, change distribution dir from an URL to src, and disable auto-updater
    yq -iPo=json '
        .build.beforeBuildCommand = "" |
        .build.frontendDist = "src" |
        .bundle.resources = (.bundle.resources | map(select(. != "updater*")))
    ' tauri.conf.json

    (cd $cargoDepsCopy/tauri-utils-* && patch -p3 <${./tauri-env-resource-dir.patch})
  '';

  preConfigure = ''
    cp -r ${frontend}/* ./
  '';

  postInstall = ''
    mkdir -p $out/lib/dorion
    cp -r {injection,html} $out/lib/dorion
    install -Dm644 "$out/share/icons/hicolor/32x32/apps/dorion.png" "./${src.name}/src-tauri/icons/32x32icon.png"
    install -Dm644 "$out/share/icons/hicolor/128x128/apps/dorion.png" "./${src.name}/src-tauri/icons/128x128.png"
    install -Dm644 "$out/share/icons/hicolor/256x256/apps/dorion.png" "./${src.name}/src-tauri/icons/128x128@2.png"
    install -Dm644 "$out/share/icons/hicolor/512x512/apps/dorion.png" "./${src.name}/src-tauri/icons/icon.png"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "dorion";
      genericName = "Internet Messenger";
      desktopName = "Dorion";
      exec = "dorion %U";
      tryExec = "dorion %U";
      icon = "dorion";
      comment = "Tiny alternative Discord client";
      keywords = [
        "discord"
        "vencord"
        "tauri"
        "chat"
      ];
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      mimeTypes = [ "x-scheme-handler/discord" ];
      startupWMClass = "Dorion";
      terminal = false;
    })
  ];

  passthru = {
    inherit frontend;
  };

  meta = {
    homepage = "https://github.com/SpikeHD/Dorion";
    description = "Tiny alternative Discord client";
    license = lib.licenses.gpl3Only;
    mainProgram = "dorion";
    maintainers = with lib.maintainers; [
      nyabinary
      aleksana
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = [
      lib.sourceTypes.binaryBytecode # actually, minified JS
      lib.sourceTypes.fromSource
    ];
  };
}

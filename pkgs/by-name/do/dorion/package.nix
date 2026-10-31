{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  ninja,
  makeBinaryWrapper,
  wrapGAppsHook4,
  glib-networking,
  libayatana-appindicator,
  nodejs,
  openssl,
  pkg-config,
  yq-go,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  webkitgtk_4_1,
  cargo-tauri,
  desktop-file-utils,
  apple-sdk_15,
  darwin,
  shelter,
  cef-binary,
  lld,
  gtk3,
  libsoup_3,
  alsa-lib,
  atk,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  libdrm,
  libgbm,
  libGL,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxshmfence,
  nspr,
  nss,
  pango,
  udev,
  nix-update-script,
}:

let
  cefPath = cef-binary.overrideAttrs (finalAttrs: {
    pname = "cef-path";
    postInstall = ''
      find "$out" -mindepth 1 -delete
      strip ./Release/*.so*
      mv ./Release/* "$out"/
      find "./Resources/locales" -maxdepth 1 -type f ! -name 'en-US.pak' -delete
      mv ./Resources/* "$out"/
      mv ./include "$out"/
    '';
  });
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dorion";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "SpikeHD";
    repo = "Dorion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-amZ9zFx3aNQSEDouhtC8YXccPrvz00ZDSXC0LZmsYqU=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-YaRbwlqr3D0ai9Mf1nQ2R5ZsEaoQY0O2xN9GVQ+ctmU=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-8ZbW4eLOQQ9kpkXJuxGr15iY8jmgl0Li91n7SX+U+Jk=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_10
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
    lld
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
    darwin.autoSignDarwinBinariesHook
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    cefPath
    gtk3
    libsoup_3
    webkitgtk_4_1
    # Runtime dependencies of the bundled CEF libraries.
    alsa-lib
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    glib-networking
    libdrm
    libgbm
    libGL
    libayatana-appindicator
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    libxshmfence
    nspr
    nss
    pango
    udev
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
    ln -s ${shelter}/shelter.js src-tauri/injection/shelter.js

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

    # Upstream's beforeBundleCommand expects the CEF auto-downloader output; we provide CEF ourselves, so disable it.
    yq -iPo=json '
      .build.beforeBundleCommand = "" | .bundle.linux.deb.files = {} | .bundle.linux.rpm.files = {}
    ' src-tauri/tauri.linux.conf.json

    # A small /dev/shm makes CEF renderer time out and the UI fail to load; fall back to /tmp.
    substituteInPlace src-tauri/src/main.rs \
      --replace-fail '("--no-sandbox".into(), None),' \
        '("--no-sandbox".into(), None),
      ("--disable-dev-shm-usage".into(), None),'

    # cef-dll-sys refuses a CEF_PATH that is not an official download dir, so skip its archive check.
    substituteInPlace "$cargoDepsCopy"/*/cef-dll-sys-*/build.rs \
      --replace-fail 'download_cef::check_archive_json(&package_version, &path.to_string_lossy())?;' ""
  '';

  # error: failed to run custom build command for `Dorion v6.5.3 (/build/source/src-tauri)`
  # Permission denied (os error 13)
  doCheck = false;

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

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    # libcef.so is loaded via dlopen, so autoPatchelf does not add its path; append it.
    patchelf --add-rpath "${
      lib.makeLibraryPath [
        cefPath
        alsa-lib
        atk
        at-spi2-atk
        at-spi2-core
        cairo
        cups
        dbus
        expat
        glib-networking
        libdrm
        libgbm
        libGL
        libayatana-appindicator
        libx11
        libxcb
        libxcomposite
        libxdamage
        libxext
        libxfixes
        libxkbcommon
        libxrandr
        libxshmfence
        nspr
        nss
        pango
        udev
      ]
    }:${cefPath}:$out/bin" "$out/bin/.Dorion-wrapped"
  '';

  env = {
    # pnpm 10 prompts before purging node_modules in non-interactive builds.
    CI = "true";
    TAURI_RESOURCE_DIR = "${placeholder "out"}/lib";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    # Consumed by cef-dll-sys at build time.
    CEF_PATH = cefPath;
  };

  passthru.updateScript = nix-update-script { };

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
      getchoo
    ];
    platforms = lib.platforms.unix;
    sourceProvenance = [
      lib.sourceTypes.fromSource
    ];
  };
})

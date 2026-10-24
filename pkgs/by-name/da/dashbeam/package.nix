{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,
  nodejs_22,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  jq,
  gtk3,
  webkitgtk_4_1,
  libsoup_3,
  glib-networking,
  openssl,
  libayatana-appindicator,
  librsvg,
  dbus,
  gdk-pixbuf,
  at-spi2-atk,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dashbeam";
  version = "0.7.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tonyantony300";
    repo = "dashbeam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5dcG2Hw+dI/UGY0wbxJW3AGq29Wpx+FHh+s90667Lco=";
  };

  # The Cargo workspace lives in src-tauri/; engine/ is a path dependency of it.
  # cargo-tauri.hook only points CARGO_TARGET_DIR at ./target when this is set,
  # and its install step reads $targetDir/bundle/deb/*/data/usr -- without it the
  # artifacts land in src-tauri/target and that glob matches nothing.
  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-7g4LlSm+/FOgE0awN9HQ8AtPCk+UnVghWqDIGpuBLGA=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-oDk6jPkDz84Bsxpp0tkuYzAf0XGLMZEecCu1nxdV3D0=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    pkg-config
    wrapGAppsHook3
    nodejs_22
    pnpm_10
    pnpmConfigHook
    jq
  ];

  buildInputs = [
    gtk3
    webkitgtk_4_1
    libsoup_3
    glib-networking # TLS inside the webview
    openssl # reqwest, via default-tls
    libayatana-appindicator # tray-icon feature
    librsvg
    dbus # tray and notifications
    gdk-pixbuf
    at-spi2-atk
  ];

  postPatch = ''
    # Upstream's beforeBuildCommand also runs `pnpm run build:wasm`, which compiles
    # the wasm-bridge crate for wasm32 and requires wasm-bindgen. That bridge only
    # serves the browser build: vite.config.ts aliases `wasm-bridge-engine` to
    # frontend/src/wasm/wasm-bridge-stub.ts unless the mode is `web`. Skip it.
    #
    # The updater must not reach upstream. Emptying the endpoint list keeps the
    # plugin's config deserialisable (removing the key entirely makes the plugin
    # panic at startup) while leaving it with nowhere to download from — its
    # self-update would write into the store, which cannot work. Updates go
    # through nix-update.
    jq '
      .build.beforeBuildCommand = "pnpm run build"
      | .plugins.updater.endpoints = []
      | .bundle.createUpdaterArtifacts = false
    ' src-tauri/tauri.conf.json > tauri.conf.json.tmp
    mv tauri.conf.json.tmp src-tauri/tauri.conf.json
  '';

  # libappindicator-sys dlopen()s libayatana-appindicator3.so.1 when the tray is
  # set up, so the library never shows up in DT_NEEDED and no RPATH is generated
  # for it. Without it the binary panics right after the window is created; the
  # wrapper puts the directory on LD_LIBRARY_PATH, which dlopen() always honours.
  preFixup = ''
    gappsWrapperArgs+=(--suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libayatana-appindicator ]}")
  '';

  # cargo-tauri.hook installs $targetDir/bundle/deb/*/data/usr into $out itself.
  # Only the product name is left to fix: the bundle calls it "DashBeam".
  postInstall = ''
    if [ -e $out/bin/DashBeam ]; then
      mv $out/bin/DashBeam $out/bin/dashbeam
    fi
    if [ -e $out/share/applications/DashBeam.desktop ]; then
      substituteInPlace $out/share/applications/DashBeam.desktop \
        --replace-fail "Exec=DashBeam" "Exec=dashbeam" \
        --replace-fail "Icon=DashBeam" "Icon=dashbeam"
      mv $out/share/applications/DashBeam.desktop $out/share/applications/dashbeam.desktop
    fi
    for dir in $out/share/icons/hicolor/*/apps; do
      if [ -e "$dir/DashBeam.png" ]; then
        mv "$dir/DashBeam.png" "$dir/dashbeam.png"
      fi
    done
  '';

  # The test suite starts real child processes and dials real iroh relays.
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "P2P file transfer with NAT hole punching, built on iroh";
    homepage = "https://github.com/tonyantony300/dashbeam";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ myul ];
    mainProgram = "dashbeam";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})

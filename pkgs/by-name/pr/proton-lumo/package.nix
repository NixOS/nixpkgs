{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
  wrapGAppsHook3,
  aws-lc,
  dbus,
  glib-networking,
  gst_all_1,
  libayatana-appindicator,
  webkitgtk_4_1,
  xdg-utils,
  cacert,
  procps,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "proton-lumo";
  version = "0.5.10";

  src = fetchFromGitHub {
    owner = "ProtonLumo";
    repo = "lumo-desktop";
    # Upstream does not push tags; this is the merge commit of the release branch.
    rev = "b977c17705964b51d31d1ae384b068b105dd9f2d";
    hash = "sha256-kbhIyidScxemwohCJsBWpT5QktQXZLEwevPrSammhzY=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-AcA2zfbkMlI6CJ/wTalHh7ieDiiqQ+DsxRf98iiXbGc=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-ZhMrc+nZ02ow/6appPU+mdQm4n2yQjbBT4acL+FG6r4=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  patches = [
    # Updates are delivered through Nix, not the in-app updater
    ./disable-updater.patch
  ];

  postPatch = ''
    # disable-updater.patch only covers update checks made through updater.rs
    if grep -rn --include='*.rs' --exclude=updater.rs \
      -e updater_builder -e UpdaterExt -e '\.updater()' src-tauri/src; then
      echo "Found an update check outside updater.rs; extend disable-updater.patch" >&2
      exit 1
    fi

    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"

    # The autostart entry would otherwise point at the unwrapped binary in this store path
    substituteInPlace $cargoDepsCopy/*/tauri-plugin-autostart-*/src/lib.rs \
      --replace-fail "builder.set_app_path(&current_exe.display().to_string());" \
                     'builder.set_app_path("${finalAttrs.meta.mainProgram}");'
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    aws-lc
    dbus
    glib-networking
    libayatana-appindicator
    webkitgtk_4_1
    # Microphone capture for dictation
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  # Upstream defaults to Proton's internal development environment. This origin
  # is also the only remote page granted IPC and microphone access.
  env.LUMO_URL = "https://lumo.proton.me";

  postInstall = ''
    # The bundler files the 256px icon in the directory for 512px HiDPI icons
    mv $out/share/icons/hicolor/256x256{@2,}
    install -Dm644 src-tauri/icons/icon.png $out/share/icons/hicolor/512x512/apps/lumo-desktop.png
  '';

  # Sign-in happens in the default browser
  preFixup = ''
    gappsWrapperArgs+=(--suffix PATH : ${lib.makeBinPath [ xdg-utils ]})
  '';

  nativeCheckInputs = [
    # reqwest refuses to build a client without CA certificates
    cacert
    # The bash connector tests call ps
    procps
  ];

  # Upstream runs its test suite in the dev profile; the release profile would
  # link every test binary with fat LTO
  checkType = "debug";
  checkFeatures = [ "test-utils" ];

  passthru = {
    tests = { inherit (nixosTests) proton-lumo; };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Desktop app for Lumo, Proton's AI assistant";
    homepage = "https://proton.me/lumo";
    changelog = "https://github.com/ProtonLumo/lumo-desktop/blob/${finalAttrs.src.rev}/changelog.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ WitteShadovv ];
    mainProgram = "lumo-desktop";
    platforms = lib.platforms.linux;
  };
})

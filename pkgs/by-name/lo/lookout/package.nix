{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  glib-networking,
  gst_all_1,
  gtk3,
  gdk-pixbuf,
  libayatana-appindicator,
  libclang,
  libgbm,
  librsvg,
  nodejs,
  npmHooks,
  openssl,
  pipewire,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lookout";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "hackclub";
    repo = "lookout";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EbScibZev4dAivW3pSXAtVvu8o6B4UOm4wb9CvsBy2k=";
  };

  cargoRoot = "clients/desktop/src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-eNVTOu1KyM0aJX3X5/YNq4W6EKa2dfSBn6NZRtEJWbA=";

  # upstream src/window_shape.rs doctest embeds ASCII-art (┌───┐) that the
  # rustdoc lexer rejects; the real unit/integration tests all pass
  cargoTestFlags = [
    "--lib"
    "--bins"
    "--tests"
  ];

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    fetcherVersion = 2;
    hash = "sha256-1BYF8hfXNctFi/KZYj3j1lbAa/qyXU+4fEI4nYjuhGY=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    libclang.lib
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  env.LIBCLANG_PATH = "${libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${stdenv.cc.libc.dev}/include -isystem ${libclang.lib}/lib/clang/${lib.versions.major libclang.version}/include";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
    gtk3
    gdk-pixbuf
    libayatana-appindicator
    libgbm
    librsvg
    openssl
    pipewire
    webkitgtk_4_1
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    # strip tauri-plugin-updater (nixpkgs policy: no in-app downloaders)
    substituteInPlace clients/desktop/src-tauri/Cargo.toml \
      --replace "tauri-plugin-updater = \"2\"" ""
    substituteInPlace clients/desktop/src-tauri/src/lib.rs \
      --replace ".plugin(tauri_plugin_updater::Builder::new().build())" ""
    substituteInPlace clients/desktop/src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'
    # capabilities still references the removed plugin's permissions
    sed -i '/"updater:default",/d' clients/desktop/src-tauri/capabilities/default.json
    # frontend is built in preBuild; neutralize Tauri's beforeBuildCommand so
    # its cwd (src-tauri vs app root) can't cause a spurious npm failure
    substituteInPlace clients/desktop/src-tauri/tauri.conf.json \
      --replace-fail '"beforeBuildCommand": "npm run build"' '"beforeBuildCommand": "true"'

    # libappindicator-sys dlopens "libayatana-appindicator3.so.1" at runtime;
    # hardpoint it to the store path so the tray icon resolves.
    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"

    # Neutralize the frontend background updater (30-min check + auto-install).
    # The Rust plugin is gone, so `check()` would reject at runtime every
    # launch; stub the hook to an idle phase instead. UpdatePill renders
    # nothing for state === "idle", so the UI is unchanged.
    cat > clients/desktop/src/hooks/useAppUpdate.ts <<'EOF'
    export type UpdatePhase =
      | { state: "idle" }
      | { state: "downloading"; version: string; progress: number }
      | { state: "ready"; version: string }
      | { state: "installing"; version: string };

    export function useAppUpdate(): { phase: UpdatePhase; restart: () => void } {
      return { phase: { state: "idle" }, restart: () => {} };
    }
    EOF
  '';

  preBuild = ''
    # npm workspaces: build deps in dependency order before `vite build`
    npm run build -w @lookout/shared
    npm run build -w @lookout/react
    npm run build -w @lookout/desktop
  '';

  meta = {
    description = "Hack Club time-tracking desktop app that captures periodic screenshots";
    homepage = "https://github.com/hackclub/lookout";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ cloudglides ];
    platforms = lib.platforms.linux;
    mainProgram = "lookout-desktop";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})

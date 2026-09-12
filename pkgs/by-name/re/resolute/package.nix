{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchpatch,

  cargo-tauri,
  desktop-file-utils,
  jq,
  makeBinaryWrapper,
  moreutils,
  nodejs,
  npmHooks,
  pkg-config,
  wrapGAppsHook3,

  glib-networking,
  libayatana-appindicator,
  libsoup_3,
  openssl,
  webkitgtk_4_1,

  nix-update-script,
}:

let
  # Nix owns package upgrades; remove the bundled self-updater and its dependencies.
  # Carried in https://github.com/LingLambda/Resolute/commits/nixpkgs-0.8.3-fixes/ until upstreamed.
  disableUpdaterPatch = fetchpatch {
    url = "https://github.com/LingLambda/Resolute/commit/d3631ff31f2462f4e3e8da821bef4d5491206173.patch";
    hash = "sha256-1lcZr5GjXu0aNyatuKECb/djxNcZ7UCNlJ4xKhXedgs=";
  };

  # Replace upstream's unsafe mutable static database builder with safe process-lifetime ownership.
  fixDatabaseBuilderPatch = fetchpatch {
    url = "https://github.com/LingLambda/Resolute/commit/d80e3295f06d8431dcea6aaa0bf6fdc4b01d4b25.patch";
    hash = "sha256-zZzkxTghd5asCh9gvzJ3VQVdtY8krfN1eFZRtHGW3XI=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "resolute";
  version = "0.8.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Gawdl3y";
    repo = "Resolute";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gLWucwtVTOuCHRokNPIbKEXJdwWvtEYPwXD1mih8k8Q=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    patches = [ disableUpdaterPatch ];
    hash = "sha256-ZFX8yZ4F0ICIb/pObjO1G3H0XdN7/nakQVo2N8Uxffo=";
  };
  cargoPatches = [
    disableUpdaterPatch
    fixDatabaseBuilderPatch
  ];

  cargoHash = "sha256-ZHBOVDmtZqaJv81hERmOvOanCAmy4kFf5U9/F2cZDgg=";

  # Workspace Cargo.lock lives at the repo root.
  buildAndTestSubdir = "crates/tauri-app";

  # Production embed of ui/dist. cargo-tauri.hook forwards this to
  # `cargo tauri build -- --features=…`.
  buildFeatures = [ "custom-protocol" ];

  nativeBuildInputs = [
    cargo-tauri.hook
    jq
    moreutils
    nodejs
    npmHooks.npmConfigHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    desktop-file-utils
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeBinaryWrapper ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    libayatana-appindicator
    libsoup_3
    openssl
    webkitgtk_4_1
  ];

  postPatch = ''
    jq '
      del(.build.beforeBuildCommand)
      | .app.windows[0].dragDropEnabled = .app.windows[0].fileDropEnabled
      | del(.app.windows[0].fileDropEnabled)
    ' crates/tauri-app/tauri.conf.json | sponge crates/tauri-app/tauri.conf.json

    # Tauri renamed this field after the beta release. Accept the stable CLI's
    # spelling in the beta tauri-utils used to compile the application.
    substituteInPlace $cargoDepsCopy/*/tauri-utils-2.0.0-beta.9/src/config.rs \
      --replace-fail \
        '#[serde(default = "default_true", alias = "file-drop-enabled")]' \
        '#[serde(default = "default_true", alias = "file-drop-enabled", alias = "dragDropEnabled")]'

    # time 0.3.34 (from Cargo.lock) fails on rustc 1.80+.
    # https://github.com/time-rs/time/issues/681
    substituteInPlace $cargoDepsCopy/*/time-0.3.34/src/format_description/parse/mod.rs \
      --replace-fail '.collect::<Result<Box<_>, _>>()?' ".collect::<Result<Box<[format_item::Item<'_>]>, _>>()?"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # libappindicator-sys dlopens this library, so it cannot be discovered by autoPatchelfHook.
    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    jq '.bundle.macOS.signingIdentity = null' \
      crates/tauri-app/tauri.conf.json | sponge crates/tauri-app/tauri.conf.json
  '';

  # preBuild runs from the workspace root, where package.json and Vite live.
  preBuild = ''
    npm run build
  '';

  # Upstream pins Tauri 2.0.0-beta, while nixpkgs provides the stable CLI.
  # Permit that version split after applying the configuration compatibility fix above.
  tauriBuildFlags = [ "--ignore-version-mismatches" ];

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      mv "$out/bin/resolute-app" "$out/bin/resolute"
      install -Dm644 crates/tauri-app/icons/icon.png \
        "$out/share/icons/hicolor/512x512/apps/resolute-app.png"
      desktop-file-edit \
        --set-key=Categories --set-value="Utility;" \
        --set-key=Exec --set-value=resolute \
        --set-key=StartupWMClass --set-value=Resolute \
        "$out/share/applications/"*.desktop
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/bin"
      makeWrapper \
        "$out/Applications/Resolute.app/Contents/MacOS/resolute-app" \
        "$out/bin/resolute"
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mod manager GUI for Resonite";
    homepage = "https://github.com/Gawdl3y/Resolute";
    changelog = "https://github.com/Gawdl3y/Resolute/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ LingLambda ];
    inherit (cargo-tauri.hook.meta) platforms;
    mainProgram = "resolute";
  };
})

{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchPnpmDeps,
  npmHooks,
  pnpm_10,
  pnpmConfigHook,
  nodejs,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  librsvg,
  libsoup_3,
  sqlite,
  libayatana-appindicator,
  dbus,
  webkitgtk_4_1,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "hatoba";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "scarletkc";
    repo = "Hatoba";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KIN/LTTyxtRqyeut5l5XHf7ecA3Z78h5lq3skKfwd10=";
  };

  cargoHash = "sha256-HuGTxevABQRYByeWPSRQtA24WTC47Guacnq6/CJ+xJg=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 5;
    hash = "sha256-BRFA+uJ2dEj0K0fyIOe5vvfd1TaiUCIU3XZUgTGV5hk=";
  };

  # `scripts/worker/bundle.mjs` bundles the sync Worker that the app deploys;
  # it reads its own dependency tree in `workers/sync`.
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-worker-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/workers/sync";
    hash = "sha256-sNWAxV46FYnh6EHjrAwEo+/JP3xjn7ZKQg99Y8ePFdU=";
  };
  npmRoot = "workers/sync";

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pnpmConfigHook
    pnpm_10
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus
    gtk3
    libayatana-appindicator
    librsvg
    libsoup_3
    sqlite
    webkitgtk_4_1
  ];

  buildAndTestSubdir = "apps/desktop/src-tauri";

  postPatch = ''
    # A Nix build has no updater signing key, and the updater artifacts are
    # only useful for the upstream release channel.
    substituteInPlace apps/desktop/src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'

    # `npmConfigHook` has already populated `workers/sync/node_modules`, so the
    # bundle script must not try to run `npm ci` (it has no network access).
    substituteInPlace apps/desktop/src-tauri/tauri.conf.json \
      --replace-fail 'pnpm -w worker:bundle' 'pnpm -w worker:bundle --no-install'
  '';

  # `libayatana-appindicator` is loaded with dlopen() and therefore invisible
  # to autoPatchelfHook.
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libayatana-appindicator ]}"
    )
  '';

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop SSH client with an AI assistant and end-to-end encrypted sync";
    homepage = "https://hatoba.fog.moe";
    changelog = "https://github.com/scarletkc/Hatoba/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "Hatoba";
    maintainers = with lib.maintainers; [ YoumingXK ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  pkg-config,
  webkitgtk_4_1,
  libayatana-appindicator,
  libxscrnsaver,
  cacert,
  wrapGAppsHook3,
  autoPatchelfHook,
  nix-update-script,
  swift,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluux-messenger";
  version = "0.18.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    name = "${finalAttrs.pname}-${finalAttrs.version}-source";
    owner = "processone";
    repo = "fluux-messenger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3hOe7pEs9QMuAX4K3SGrDRFIjpWK4PEsR3KuQVbGr9Y=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-mKGzLzgMtdY09x/pHBd1R1HZbUccofl1Ho0xE1hYuMw=";
  };

  cargoRoot = "apps/fluux/src-tauri";

  # The swift-rs pin is a macOS-only workaround that Cargo.lock lists as
  # [[patch.unused]]; fetchCargoVendor does not vendor it, so the offline
  # build would try to fetch it.
  postPatch = ''
    substituteInPlace ${finalAttrs.cargoRoot}/Cargo.toml \
      --replace-fail 'swift-rs = { git = ' '# swift-rs = { git = '
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace ${finalAttrs.cargoRoot}/tauri.macos.conf.json \
      --replace-fail 'node scripts/tauri-macos-share.mjs' 'node apps/fluux/scripts/tauri-macos-share.mjs'
    substituteInPlace apps/fluux/scripts/tauri-macos-share.mjs \
      --replace-fail "run('/usr/bin/xcrun', ['swiftc'," "run('swiftc', [" \
      --replace-fail "run('/usr/bin/xcrun', ['lipo'," "run('lipo', ["
  '';

  cargoHash = "sha256-BEhToIykuf4ZMHlYETzZ3hdaVcjbp25FLSflLawcj6s=";

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ swift ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
    libayatana-appindicator
    libxscrnsaver
  ];

  nativeCheckInputs = [ cacert ];

  # libayatana-appindicator is not in the RUNPATH by default
  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [ libayatana-appindicator ];

  tauriBuildFlags = [ "--no-sign" ];

  # setting buildAndTestSubdir from the beginning interferes with buildPhase
  preCheck = "export buildAndTestSubdir=${finalAttrs.cargoRoot}";
  # tauriInstallHook only works when we are in cargoRoot
  preInstall = "pushd $buildAndTestSubdir";
  postInstall = "popd";

  # Stripping the Share Extension executable invalidates its bundle signature.
  stripExclude = lib.optionals stdenv.hostPlatform.isDarwin [ "FluuxShare" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "XMPP client for communities and organizations";
    longDescription = "A modern, Web and Desktop cross-platform XMPP client for communities and organizations, built with a reusable Typescript SDK and Tauri for desktop";
    changelog = "https://github.com/processone/fluux-messenger/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    homepage = "https://github.com/processone/fluux-messenger";
    license = lib.licenses.agpl3Plus;
    mainProgram = "fluux";
    maintainers = [ lib.maintainers.haansn08 ];
    platforms = lib.platforms.all;
    # see also https://github.com/processone/fluux-messenger/blob/main/fluux-messenger.doap
  };
})

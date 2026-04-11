{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # build tools
  cargo-tauri,
  nodejs_22,
  pnpmConfigHook,
  pnpm_10,
  fetchPnpmDeps,
  pkg-config,
  makeBinaryWrapper,
  wrapGAppsHook4,

  # Linux dependencies
  glib-networking,
  libayatana-appindicator,
  openssl,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chiri";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "SapphoSys";
    repo = "chiri";
    tag = "app-v${finalAttrs.version}";
    hash = "sha256-VrENUwkItT+8C7JowoEfqjIX4RhThTm+4hntdm9ifVk=";
  };

  cargoHash = "sha256-2CDwuZiE4b5cBUPZs8l4pf9/FyvtSpRwNwQZ5gp85zc=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    hash = "sha256-z2AMfMYNEK4pmjlE5YXn1DRCGyIcOO0EWCFlhXSxwrU=";
    fetcherVersion = 3;
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs_22
    pnpmConfigHook
    pnpm_10
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook4
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    libayatana-appindicator
    webkitgtk_4_1
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  postPatch =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      for libappindicatorRs in $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs; do
        if [[ -f "$libappindicatorRs" ]]; then
          substituteInPlace "$libappindicatorRs" \
            --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
        fi
      done
    ''
    + ''
      substituteInPlace src-tauri/tauri.conf.json \
        --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'
    '';

  # This is needed since the signing keys are private, and are only used in CI during releases anyways. Regular users won't need this.
  preBuild = ''
    unset TAURI_SIGNING_PRIVATE_KEY
    unset TAURI_SIGNING_PUBLIC_KEY
    pnpm build
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin
    makeWrapper "$out/Applications/Chiri.app/Contents/MacOS/chiri" "$out/bin/chiri"
  '';

  doCheck = false;

  meta = {
    description = "Cross-platform CalDAV task management app";
    homepage = "https://github.com/SapphoSys/chiri";
    changelog = "https://github.com/SapphoSys/chiri/releases/tag/app-v${finalAttrs.version}";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ SapphoSys ];
    mainProgram = "chiri";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

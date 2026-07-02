{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,

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
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "SapphoSys";
    repo = "chiri";
    tag = "app-v${finalAttrs.version}";
    hash = "sha256-45a1mmh8dxrWw+UQzJcbPAujFjCYC4ovsGhdAn39LkI=";
  };

  cargoHash = "sha256-TLYiCdkF/uX3uIVwplI7L1b7Ta5LTRdKqFlmnvCxFFc=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    hash = "sha256-jDSljbGzEGDl0PsnjdmyhIGXX4fUPVeCndv5pUm/utE=";
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

  postInstall =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/bin
        makeWrapper "$out/Applications/Chiri.app/Contents/MacOS/chiri" "$out/bin/chiri"
      ''
    else
      ''
        mv $out/bin/Chiri $out/bin/chiri
        substituteInPlace $out/share/applications/Chiri.desktop \
          --replace-fail "Exec=Chiri" "Exec=chiri"
      '';

  doCheck = false;

  passthru.updateScript = nix-update-script;

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

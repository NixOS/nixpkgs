{
  lib,
  cargo-tauri,
  fetchFromGitHub,
  glib-networking,
  libayatana-appindicator,
  libsoup_3,
  nix-update-script,
  nodejs,
  openssl,
  pkg-config,
  pnpm_9,
  protobuf,
  rustPlatform,
  stdenv,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:
rustPlatform.buildRustPackage rec {
  pname = "rquickshare";
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "Martichou";
    repo = "rquickshare";
    tag = "v${version}";
    hash = "sha256-DZdzk0wqKhVa51PgQf8UsAY6EbGKvRIGru71Z8rvrwA=";
  };

  patches = [ ./fix-pnpm-outdated-lockfile.patch ];

  # from https://github.com/NixOS/nixpkgs/blob/04e40bca2a68d7ca85f1c47f00598abb062a8b12/pkgs/by-name/ca/cargo-tauri/test-app.nix#L23-L26
  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  pnpmRoot = "app/main";
  pnpmDeps = pnpm_9.fetchDeps {
    inherit
      pname
      version
      src
      patches
      ;
    postPatch = "cd ${pnpmRoot}";
    fetcherVersion = 1;
    hash = "sha256-V46V/VPwCKEe3sAp8zK0UUU5YigqgYh1GIOorqIAiNE=";
  };

  cargoRoot = "app/main/src-tauri";
  buildAndTestSubdir = cargoRoot;
  cargoPatches = [
    ./remove-duplicate-versions-of-sys-metrics.patch
    ./remove-code-signing-darwin.patch
  ];
  cargoHash = "sha256-XfN+/oC3lttDquLfoyJWBaFfdjW/wyODCIiZZksypLM=";

  nativeBuildInputs = [
    cargo-tauri.hook

    # Setup pnpm
    nodejs
    pnpm_9.configHook

    protobuf
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    libayatana-appindicator
    libsoup_3
    openssl
    webkitgtk_4_1
  ];

  env.OPENSSL_NO_VENDOR = 1;

  passthru.updateScript = nix-update-script;

  meta = {
    description = "Rust implementation of NearbyShare/QuickShare from Android for Linux and macOS";
    homepage = "https://github.com/Martichou/rquickshare";
    changelog = "https://github.com/Martichou/rquickshare/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    mainProgram = "rquickshare";
    maintainers = with lib.maintainers; [
      perchun
      luftmensch-luftmensch
    ];
  };
}

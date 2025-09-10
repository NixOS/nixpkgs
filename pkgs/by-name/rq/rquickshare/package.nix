{
  lib,
  cargo-tauri,
  cargo-tauri_1,
  fetchFromGitHub,
  glib-networking,
  libayatana-appindicator,
  libsoup_2_4,
  libsoup_3,
  nix-update,
  nodejs,
  openssl,
  pkg-config,
  pnpm_9,
  protobuf,
  rustPlatform,
  stdenv,
  webkitgtk_4_0,
  webkitgtk_4_1,
  wrapGAppsHook4,
  writeShellScript,

  # This package provides can be built using tauri v1 or v2.
  # Try legacy (v1) version if main (v2) doesn't work.
  app-type ? "main", # main or legacy
}:
let
  app-type-either =
    arg1: arg2:
    if app-type == "main" then
      arg1
    else if app-type == "legacy" then
      arg2
    else
      throw "Wrong argument for app-type in rquickshare package";

  proper-cargo-tauri = app-type-either cargo-tauri cargo-tauri_1;
in
rustPlatform.buildRustPackage rec {
  pname = "rquickshare" + (app-type-either "" "-legacy");
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

  pnpmRoot = "app/${app-type}";
  pnpmDeps = pnpm_9.fetchDeps {
    inherit
      pname
      version
      src
      patches
      ;
    postPatch = "cd ${pnpmRoot}";
    fetcherVersion = 1;
    hash = app-type-either "sha256-V46V/VPwCKEe3sAp8zK0UUU5YigqgYh1GIOorqIAiNE=" "sha256-8QRigYNtxirXidFFnTzA6rP0+L64M/iakPqe2lZKegs=";
  };

  cargoRoot = "app/${app-type}/src-tauri";
  buildAndTestSubdir = cargoRoot;
  cargoPatches = [
    ./remove-duplicate-versions-of-sys-metrics.patch
    ./remove-code-signing-darwin.patch
  ];
  cargoHash = app-type-either "sha256-XfN+/oC3lttDquLfoyJWBaFfdjW/wyODCIiZZksypLM=" "sha256-4vBHxuKg4P9H0FZYYNUT+AVj4Qvz99q7Bhd7x47UC2w=";

  nativeBuildInputs = [
    proper-cargo-tauri.hook

    # Setup pnpm
    nodejs
    pnpm_9.configHook

    protobuf
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux (
    [
      glib-networking
      libayatana-appindicator
      openssl
    ]
    ++ lib.optionals (app-type == "main") [
      libsoup_3
      webkitgtk_4_1
    ]
    ++ lib.optionals (app-type == "legacy") [
      libsoup_2_4
      webkitgtk_4_0
    ]
  );

  env.OPENSSL_NO_VENDOR = 1;

  passthru =
    # Don't set an update script for the legacy version
    # so r-ryantm won't create two duplicate PRs
    lib.optionalAttrs (app-type == "main") {
      updateScript = writeShellScript "update-rquickshare.sh" ''
        ${lib.getExe nix-update} rquickshare
        sed -i 's/version = "0.0.0";/' pkgs/by-name/rq/rquickshare/package.nix
        ${lib.getExe nix-update} rquickshare-legacy
      '';
    };

  meta = {
    description = "Rust implementation of NearbyShare/QuickShare from Android for Linux and macOS";
    homepage = "https://github.com/Martichou/rquickshare";
    changelog = "https://github.com/Martichou/rquickshare/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    mainProgram = app-type-either "rquickshare" "r-quick-share";
    maintainers = with lib.maintainers; [
      perchun
      luftmensch-luftmensch
    ];
  };
}

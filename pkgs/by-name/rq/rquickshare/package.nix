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
  perl,
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
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "Martichou";
    repo = "rquickshare";
    tag = "v${version}";
    hash = "sha256-6gXt1UGcjOFInsCep56s3K5Zk/KIz2ZrFlmrgXP7/e8=";
  };

  # from https://github.com/NixOS/nixpkgs/blob/04e40bca2a68d7ca85f1c47f00598abb062a8b12/pkgs/by-name/ca/cargo-tauri/test-app.nix#L23-L26
  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  pnpmRoot = "app/${app-type}";
  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;

    sourceRoot = "${src.name}/app/${app-type}";
    hash = app-type-either "sha256-V46V/VPwCKEe3sAp8zK0UUU5YigqgYh1GIOorqIAiNE=" "sha256-sDHysaKMdNcbL1szww7/wg0bGHOnEKsKoySZJJCcPik=";
  };

  useFetchCargoVendor = true;
  cargoRoot = "app/${app-type}/src-tauri";
  buildAndTestSubdir = cargoRoot;
  cargoPatches = [ ./remove-duplicate-versions-of-sys-metrics.patch ];
  cargoHash = app-type-either "sha256-R1RDBV8lcEuFdkh9vrNxFRSPSYVOWDvafPQAmQiJV2s=" "sha256-tgnSOICA/AFASIIlxnRoSjq5nx30Z7C6293bcvnWl0k=";

  nativeBuildInputs = [
    proper-cargo-tauri.hook

    # Setup pnpm
    nodejs
    pnpm_9.configHook

    # Make sure we can find our libraries
    perl
    pkg-config
    protobuf
    wrapGAppsHook4
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      glib-networking
      libayatana-appindicator
    ]
    ++ lib.optionals (app-type == "main") [
      webkitgtk_4_1
      libsoup_3
    ]
    ++ lib.optionals (app-type == "legacy") [
      webkitgtk_4_0
      libsoup_2_4
    ];

  passthru.updateScript =
    let
      updateScript = writeShellScript "update-rquickshare.sh" ''
        ${lib.getExe nix-update} rquickshare
        sed -i 's/version = "0.0.0";/' pkgs/by-name/rq/rquickshare/package.nix
        ${lib.getExe nix-update} rquickshare-legacy
      '';
    in
    # Don't set an update script for the legacy version
    # so r-ryantm won't create two duplicate PRs
    app-type-either updateScript null;

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

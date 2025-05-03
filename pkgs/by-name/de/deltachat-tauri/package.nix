{
  cargo-tauri,
  fetchFromGitHub,
  lib,
  libayatana-appindicator,
  makeWrapper,
  nodejs,
  openssl,
  perl,
  pkg-config,
  pnpm_9,
  python3,
  rustPlatform,
  stdenv,
  versionCheckHook,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:

let
  pnpm = pnpm_9;
in
rustPlatform.buildRustPackage rec {
  pname = "deltachat-tauri";
  version = "1.57.0";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-desktop";
    tag = "v${version}";
    hash = "sha256-B7rM2NIbkQp9PvpLUYJ8wTKHXOijUZmZ2eyhO4oBNj8=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-6UgDT1SK4cVY6nZG9x+YBs1YV3tifKwis7cvDx+Ppv8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-YK4YCOmV5cbk871RlG47UJ8BMMy1h6ClRa7IwWlYxUk=";

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail libayatana-appindicator3.so.1 '${libayatana-appindicator}/lib/libayatana-appindicator3.so.1'
  '';

  nativeBuildInputs =
    [
      cargo-tauri.hook
      nodejs
      perl
      pnpm.configHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      pkg-config
      python3
      wrapGAppsHook4
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libayatana-appindicator
    openssl
    webkitgtk_4_1
  ];

  buildAndTestSubdir = "packages/target-tauri";

  env = {
    VERSION_INFO_GIT_REF = src.tag;
  };

  # FIXME error[E0603]: module `util` is private
  doCheck = false;

  postInstall = ''
    install -Dm 444 images/tray/deltachat.svg "$out/share/icons/hicolor/scalable/apps/deltachat-tauri.svg"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Email-based instant messaging for Desktop";
    homepage = "https://github.com/deltachat/deltachat-desktop";
    changelog = "https://github.com/deltachat/deltachat-desktop/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    mainProgram = "deltachat-tauri";
    maintainers = with lib.maintainers; [ dotlambda ];
    # FIXME fails on aarch64-darwin with `ld: symbol(s) not found for architecture arm64`
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
}

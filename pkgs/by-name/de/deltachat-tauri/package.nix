{
  apple-sdk_14,
  cargo-tauri,
  darwin,
  fetchFromGitHub,
  fetchPnpmDeps,
  gst_all_1,
  lib,
  libayatana-appindicator,
  nodejs,
  openssl,
  perl,
  pkg-config,
  pnpm_10,
  pnpmConfigHook,
  python3,
  rustPlatform,
  stdenv,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:

let
  pnpm = pnpm_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deltachat-tauri";
  version = "2.59.0-unstable-2026-08-15";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-tauri";
    rev = "ea854b4799578d7291e4dc9d6b76ddb5a001d2f0";
    fetchSubmodules = true;
    hash = "sha256-EdtSrr/5QKzBFhocCdFyAUFYHhuQUEUzMyw/fjgsIIg=";
  };

  cargoHash = "sha256-Z3uZ+IARmCZbJiIotYjdQRzYZFplRwE3xO0Yb0tLbcE=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-IzMl6dZ8r8CH0eELOzHuFYVuzhQTdSS4NvYFOp7jHIs=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail libayatana-appindicator3.so.1 '${libayatana-appindicator}/lib/libayatana-appindicator3.so.1'
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    perl
    pnpm
    pnpmConfigHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    python3
    wrapGAppsHook4
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.autoSignDarwinBinariesHook
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gstreamer
      libayatana-appindicator
      openssl
      webkitgtk_4_1
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_14
    ];

  env = {
    VERSION_INFO_GIT_REF = finalAttrs.src.rev;
  };

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm 444 images/tray/deltachat.svg "$out/share/icons/hicolor/scalable/apps/deltachat-tauri.svg"
  '';

  meta = {
    broken = true; # Error Found version mismatched Tauri packages.
    description = "Email-based instant messaging for Desktop";
    homepage = "https://github.com/deltachat/deltachat-tauri";
    license = lib.licenses.gpl3Plus;
    mainProgram = "deltachat-tauri";
    maintainers = [ lib.maintainers.dotlambda ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
})

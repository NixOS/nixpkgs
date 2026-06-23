{
  apple-sdk_14,
  cargo-tauri,
  darwin,
  deltachat-desktop,
  fetchFromGitHub,
  fetchPnpmDeps,
  gst_all_1,
  lib,
  libayatana-appindicator,
  makeWrapper,
  nodejs,
  openssl,
  perl,
  pkg-config,
  pnpm_10,
  pnpmConfigHook,
  python3,
  rustPlatform,
  stdenv,
  versionCheckHook,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:

let
  pnpm = pnpm_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deltachat-tauri";
  inherit (deltachat-desktop)
    version
    src
    pnpmDeps
    ;
  __structuredAttrs = true;

  cargoHash = "sha256-euRUA4LTmAdb9466DAMqKgAPX3N4KNXCh1ED9cL42lA=";

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
      gst_all_1.gst-vaapi
      gst_all_1.gstreamer
      libayatana-appindicator
      openssl
      webkitgtk_4_1
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_14
    ];

  buildAndTestSubdir = "packages/target-tauri";

  env = {
    VERSION_INFO_GIT_REF = finalAttrs.src.tag;
  };

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm 444 images/tray/deltachat.svg "$out/share/icons/hicolor/scalable/apps/deltachat-tauri.svg"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    changelog = "https://github.com/deltachat/deltachat-desktop/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Email-based instant messaging for Desktop";
    homepage = "https://github.com/deltachat/deltachat-desktop";
    license = lib.licenses.gpl3Plus;
    mainProgram = "deltachat-tauri";
    maintainers = [ lib.maintainers.dotlambda ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
})

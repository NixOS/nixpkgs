{
  apple-sdk_14,
  cargo-tauri,
  darwin,
  fetchFromGitHub,
  gst_all_1,
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
  version = "2.25.3";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-desktop";
    tag = "v${version}";
    hash = "sha256-xaeO1mHqJJwEMAuuzlKnFP9TiPYPygGAV+26QdXoAxk=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    fetcherVersion = 2;
    hash = "sha256-skjfQPzl/Q5MbY6C8L+4Bn5ZBm3x0r6FtI+kQq9M3Ck=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-R3KybqhQP4JohxGG738HDgWyzTUzN/hgCASQH8GYwq8=";

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail libayatana-appindicator3.so.1 '${libayatana-appindicator}/lib/libayatana-appindicator3.so.1'
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    perl
    pnpm.configHook
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
    VERSION_INFO_GIT_REF = src.tag;
  };

  # FIXME error[E0603]: module `util` is private
  doCheck = false;

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
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
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
}

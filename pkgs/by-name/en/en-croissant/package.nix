{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  pnpm_9,
  nodejs,
  cargo-tauri_1,
  pkg-config,
  wrapGAppsHook3,
  makeBinaryWrapper,

  openssl,
  libsoup_2_4,
  webkitgtk_4_0,
  gst_all_1,
  apple-sdk_11,
}:

rustPlatform.buildRustPackage rec {
  pname = "en-croissant";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "franciscoBSalgueiro";
    repo = "en-croissant";
    rev = "refs/tags/v${version}";
    hash = "sha256-EiGML3oFCJR4TZkd+FekUrJwCYe/nGdWD9mAtKKtITQ=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-hvWXSegUWJvwCU5NLb2vqnl+FIWpCLxw96s9NUIgJTI=";
  };

  cargoRoot = "src-tauri";

  useFetchCargoVendor = true;
  cargoHash = "sha256-6cBGOdJ7jz+mOl2EEXxoLNeX9meW+ybQxAxnnHAplIc=";

  buildAndTestSubdir = cargoRoot;

  nativeBuildInputs =
    [
      pnpm_9.configHook
      nodejs
      cargo-tauri_1.hook
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook3 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeBinaryWrapper ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      openssl
      libsoup_2_4
      webkitgtk_4_0
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-good
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_11 ];

  doCheck = false; # many scoring tests fail

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeWrapper "$out"/Applications/en-croissant.app/Contents/MacOS/en-croissant $out/bin/en-croissant
  '';

  meta = {
    description = "Ultimate Chess Toolkit";
    homepage = "https://github.com/franciscoBSalgueiro/en-croissant/";
    license = lib.licenses.gpl3Only;
    mainProgram = "en-croissant";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

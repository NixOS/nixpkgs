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
  # webkitgtk_4_0,
  gst_all_1,
}:

rustPlatform.buildRustPackage rec {
  pname = "en-croissant";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "franciscoBSalgueiro";
    repo = "en-croissant";
    tag = "v${version}";
    hash = "sha256-EiGML3oFCJR4TZkd+FekUrJwCYe/nGdWD9mAtKKtITQ=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    fetcherVersion = 1;
    hash = "sha256-hvWXSegUWJvwCU5NLb2vqnl+FIWpCLxw96s9NUIgJTI=";
  };

  cargoRoot = "src-tauri";

  cargoHash = "sha256-6cBGOdJ7jz+mOl2EEXxoLNeX9meW+ybQxAxnnHAplIc=";

  buildAndTestSubdir = cargoRoot;

  nativeBuildInputs = [
    pnpm_9.configHook
    nodejs
    cargo-tauri_1.hook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook3 ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeBinaryWrapper ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
    libsoup_2_4
    # webkitgtk_4_0
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
  ];

  doCheck = false; # many scoring tests fail

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeWrapper "$out"/Applications/en-croissant.app/Contents/MacOS/en-croissant $out/bin/en-croissant
  '';

  meta = {
    # webkitgtk_4_0 was removed
    broken = true;
    description = "Ultimate Chess Toolkit";
    homepage = "https://github.com/franciscoBSalgueiro/en-croissant/";
    license = lib.licenses.gpl3Only;
    mainProgram = "en-croissant";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  pnpm_9,
  nodejs,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,
  makeBinaryWrapper,

  openssl,
  libsoup_3,
  webkitgtk_4_1,
  gst_all_1,
}:

rustPlatform.buildRustPackage rec {
  pname = "en-croissant";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "franciscoBSalgueiro";
    repo = "en-croissant";
    tag = "v${version}";
    hash = "sha256-xSd16F3+h29g/AW3VVj9oyLWxKP8J9Y/ckULWSvmkcA=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    fetcherVersion = 1;
    hash = "sha256-6qR1I1BFkzjUIRkYZn0ieOUxSMB/LTr2/rABB/nnQOA=";
  };

  cargoRoot = "src-tauri";

  cargoHash = "sha256-tJ2Fsb/0wtSlvx/Z2khf/gQk4Ib24j4EzNjPL5shqAU=";

  buildAndTestSubdir = cargoRoot;

  postPatch = ''
    # Disable updater artifact creation in the Tauri configuration
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": "v1Compatible"' '"createUpdaterArtifacts": false'
  '';

  nativeBuildInputs = [
    pnpm_9.configHook
    nodejs
    cargo-tauri.hook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook3 ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeBinaryWrapper ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
    libsoup_3
    webkitgtk_4_1
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
    description = "Ultimate Chess Toolkit";
    homepage = "https://github.com/franciscoBSalgueiro/en-croissant/";
    license = lib.licenses.gpl3Only;
    mainProgram = "en-croissant";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

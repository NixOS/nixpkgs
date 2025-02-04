{
  lib,
  stdenv,
  rustPlatform,
  cargo-tauri_1,
  glib-networking,
  nodejs,
  openssl,
  pkg-config,
  webkitgtk_4_0,
  wrapGAppsHook4,
  fetchFromGitHub,
  pnpm_9
}:

rustPlatform.buildRustPackage rec {
  pname = "Choreo";
  version = "2025.0.2";

  src = fetchFromGitHub {
    owner = "SleipnirGroup";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/6vo0wei+a4Uz5qxhXkGJA6+gEJX8qjjVHzsArduK2Q=";
  };

  cargoRoot = "";
  buildAndTestSubdir = cargoRoot;

  sourceRoot = src.name;
  cargoHash = "sha256-saJPtBSc9aiBTawTnRfnv+88YlTUxZkFyxnFDdadTUU=";

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-aB02TFERyohQA+RTMdZTu/MBclqw6fXVSVGtt0g6vhs=";
  };

  nativeBuildInputs =
    [
      cargo-tauri_1.hook

      nodejs
      pnpm_9.configHook

      pkg-config
      wrapGAppsHook4
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      rustPlatform.bindgenHook
    ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      glib-networking
      webkitgtk_4_0
    ];

  meta = {
    homepage = "https://choreo.autos/";
    description = "A graphical tool for planning time-optimized trajectories for autonomous mobile robots in the FIRST Robotics Competition.";
    license = lib.licenses.gpl3Only;
    # maintainers = with lib.maintainers; [ supercoolspy ];
    mainProgram = "choreo";
  };
}

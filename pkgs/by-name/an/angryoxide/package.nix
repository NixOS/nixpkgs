{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  sqlite,
  zlib,
  stdenv,
  darwin,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "angryoxide";
  version = "0.8.28";

  src = fetchFromGitHub {
    owner = "Ragnt";
    repo = "AngryOxide";
    rev = "v${version}";
    hash = "sha256-n2c1G8Y9dFV+0MZehCRBAKkzN6XOWfDX0AVWb+o08VI=";
  };

  cargoHash = "sha256-cir3UNHE7z+pq3oBdBo8U9tcRh6jCCSN/bwuDTg5rrw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libxkbcommon
      sqlite
      zlib
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
    ]
    ++ lib.optionals stdenv.isLinux [
      wayland
    ];

  meta = {
    description = "802.11 Attack Tool";
    homepage = "https://github.com/Ragnt/AngryOxide/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fvckgrimm ];
    mainProgram = "angryoxide";
  };
}

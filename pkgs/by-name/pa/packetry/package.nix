{
  fetchFromGitHub,
  lib,
  stdenv,
  rustPlatform,
  gtk4,
  pkg-config,
  pango,
  wrapGAppsHook4,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "packetry";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "packetry";
    rev = "refs/tags/v${version}";
    hash = "sha256-FlimHJS3hwB2Tkulb8uToKFe165uv/gFxJ4uezVNka4=";
  };

  cargoHash = "sha256-n1hPoSUEFUGpEUOiuirSbeAnU+qiENDg4XyN5Jkjo/Y=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs =
    [
      gtk4
      pango
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
    ];

  # Tests need a display to run
  doCheck = false;

  meta = with lib; {
    description = "USB 2.0 protocol analysis application for use with Cynthion";
    homepage = "https://github.com/greatscottgadgets/packetry";
    license = licenses.bsd3;
    maintainers = with maintainers; [ carlossless ];
    mainProgram = "packetry";
    platforms = platforms.linux ++ platforms.darwin;
  };
}

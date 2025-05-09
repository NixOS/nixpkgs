{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-screenshot";
  version = "1.0.0-alpha.7";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-screenshot";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-VvU/9vYdoTvy3yzdeXrhKrtS9tUHMKnaSAeNTEKk5PA=";
  };

  cargoHash = "sha256-fzIVyxzNknEjGJoR9sgXkY+gyuTC0T4Sy513X8umbWA=";

  nativeBuildInputs = [
    just
    pkg-config
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-screenshot"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-screenshot";
    description = "Screenshot tool for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-screenshot";
  };
}

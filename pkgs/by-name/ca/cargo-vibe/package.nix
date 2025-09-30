{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  udev,
  openssl,
}:
rustPlatform.buildRustPackage {
  pname = "cargo-vibe";
  version = "0-unstable-2022-12-29";

  src = fetchFromGitHub {
    owner = "Shadlock0133";
    repo = "cargo-vibe";
    rev = "a54d87b080ff7d8b3207f83f8f434b226572f0fe";
    hash = "sha256-0IwxbMcRH+6WgrzpcU5zfRuKs80XY0mDBjDE9DBnOFk=";
  };

  cargoHash = "sha256-qQLBq3jV3Ii/8KDTNRPi0r2KnJDtFIJURNx9zTsGDMQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    openssl
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux udev;

  meta = with lib; {
    description = "Cargo x Buttplug.io";
    mainProgram = "cargo-vibe";
    homepage = "https://github.com/shadlock0133/cargo-vibe";
    license = licenses.mit;
    maintainers = with maintainers; [ _999eagle ];
  };
}

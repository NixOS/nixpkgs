{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  pkg-config,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-randr";
  version = "1.0.0-alpha.3";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-randr";
    rev = "epoch-${version}";
    hash = "sha256-xakK4APhlNKuWbCMP6nJXLyOaQ0hFCvzOht3P8CkV/0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-protocols-0.1.0" = "sha256-6XM6kcM2CEGAziCkal4uO0EL1nEWOKb3rFs7hFh6r7Y=";
    };
  };

  nativeBuildInputs = [
    just
    pkg-config
  ];
  buildInputs = [ wayland ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-randr"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-randr";
    description = "Library and utility for displaying and configuring Wayland outputs";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-randr";
  };
}

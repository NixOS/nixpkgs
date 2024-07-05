{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, just
, pkg-config
, wayland
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-randr";
  version = "unstable-2023-12-22";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "8a082103a0365b02fbed2c17c02373eceb7ad4d3";
    hash = "sha256-LsZpey9OhNq9FTtHXvZXtHyhXttJ+tr5qBS6eSL27dE=";
  };

  cargoHash = "sha256-XpN9X8CZUGOe6mQhWWQy766gyoiTPObKsv9J8xiDvdA=";

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [ just pkg-config ];
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
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-randr";
  };
}

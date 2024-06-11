{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, just
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-screenshot";
  version = "unstable-2023-11-08";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "b413a7128ddcdfb3c63e84bdade5c5b90b163a9a";
    hash = "sha256-SDxBBhmnqNDX95Rb7QiI46sAxrfodB5tSq8AbXAU480=";
  };

  cargoHash = "sha256-ZRsAhIWPm38Ys9jM/3yVJLW818lUGLCcSfFZb+UTbnU=";

  nativeBuildInputs = [ just pkg-config ];

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
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-screenshot";
  };
}

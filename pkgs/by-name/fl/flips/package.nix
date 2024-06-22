{
  lib,
  fetchFromGitHub,
  gtk3,
  libdivsufsort,
  pkg-config,
  stdenv,
  wrapGAppsHook3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flips";
  version = "0-unstable-2024-04-17";

  src = fetchFromGitHub {
    owner = "Alcaro";
    repo = "Flips";
    rev = "20b0da9ab95d23da89f821bbddedb11b8e0e6531";
    hash = "sha256-/i/0FvZqMvG4FFIKaOtUe0A5BfG4NXjpBfLYIQOFky8=";
  };

  patches = [ ./000-use-system-libdivsufsort.patch ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libdivsufsort
  ];

  strictDeps = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    homepage = "https://github.com/Alcaro/Flips";
    description = "A patcher for IPS and BPS files";
    license = lib.licenses.gpl3Plus;
    mainProgram = "flips";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})

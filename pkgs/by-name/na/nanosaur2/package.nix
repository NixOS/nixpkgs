{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  libGL,
  cmake,
  makeWrapper,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "nanosaur2";
  version = "2.1.0-unstable-2023-05-21";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = "nanosaur2";
    rev = "72d93ed08148d81aa89bab511a9650d7b929d4c7";
    hash = "sha256-1AvM2KTQB9aUYB0e/7Y6h18yQvzsxMOgGkF9zPgTzFo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
  buildInputs = [
    SDL2
    libGL
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    mkdir -p "$out/share/Nanosaur2"
    mv Data ReadMe.txt "$out/share/Nanosaur2/"
    install -Dm755 {.,$out/bin}/Nanosaur2
    wrapProgram $out/bin/Nanosaur2 --chdir "$out/share/Nanosaur2"
    install -Dm644 $src/packaging/io.jor.nanosaur2.desktop $out/share/applications/nanosaur2.desktop
    install -Dm644 $src/packaging/io.jor.nanosaur2.png $out/share/pixmaps/nanosaur2.png
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Port of Nanosaur2, a 2004 Macintosh game by Pangea Software, for modern operating systems";
    longDescription = ''
      Nanosaur is a 2004 Macintosh game by Pangea Software.

      Is a continuation of the original Nanosaur storyline, only this time you get to fly a pterodactyl who’s loaded with hi-tech weaponry.
    '';
    homepage = "https://github.com/jorio/Nanosaur2";
    license = licenses.cc-by-sa-40;
    mainProgram = "Nanosaur2";
    maintainers = with maintainers; [ lux ];
    platforms = platforms.linux;
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  cmake,
  makeWrapper,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "mighty-mike";
  version = "3.0.2-unstable-2024-04-01";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = "MightyMike";
    rev = "0a1d6c4c80a90ed6e333651cd0a438ec003cfbe5";
    hash = "sha256-c7o0Q9KTbJhYOZ2c/V1EdV4ibdR3AnHTCZBManJQzrw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    SDL2
    cmake
    makeWrapper
  ];

  buildInputs = [ SDL2 ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/MightyMike"
    mv Data ReadMe.txt "$out/share/MightyMike/"

    install -Dm755 {.,$out/bin}/MightyMike
    wrapProgram $out/bin/MightyMike --chdir "$out/share/MightyMike"

    install -Dm644 $src/packaging/io.jor.mightymike.desktop $out/share/applications/mightymike.desktop
    install -Dm644 $src/packaging/io.jor.mightymike.png $out/share/pixmaps/mightymike-desktopicon.png

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Port of Mighty Mike, a 1995 Macintosh game by Pangea Software, for modern operating systems";
    longDescription = ''
      This is Pangea Software's Mighty Mike updated to run on modern systems.
      Set in a toy store, this top-down action game is a staple of 90's Macintosh games.
      It was initially published in 1995 under the name Power Pete.
    '';
    homepage = "https://jorio.itch.io/mightymike";
    license = lib.licenses.cc-by-nc-sa-40;
    mainProgram = "MightyMike";
    maintainers = with lib.maintainers; [ nateeag ];
    platforms = lib.platforms.linux;
  };
}

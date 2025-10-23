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
  pname = "nanosaur";
  version = "1.4.4-unstable-2024-04-06";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = "nanosaur";
    rev = "4f2612f81697a0852f63fa2ea1ac80892f8a5a9c";
    hash = "sha256-MQmlZbsQSREAIqKXyIIOF6Psa1rqY/iUsBHpeKGekBI=";
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
    mkdir -p "$out/share/Nanosaur"
    mv Data ReadMe.txt "$out/share/Nanosaur/"
    install -Dm755 {.,$out/bin}/Nanosaur
    wrapProgram $out/bin/Nanosaur --chdir "$out/share/Nanosaur"
    install -Dm644 $src/packaging/io.jor.nanosaur.desktop $out/share/applications/nanosaur.desktop
    install -Dm644 $src/packaging/io.jor.nanosaur.png $out/share/pixmaps/nanosaur-desktopicon.png
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Port of Nanosaur, a 1998 Macintosh game by Pangea Software, for modern operating systems";
    longDescription = ''
      Nanosaur is a 1998 Macintosh game by Pangea Software.
      In it, you’re a cybernetic dinosaur from the future who’s sent back in time 20 minutes before a giant asteroid hits the Earth.
      And you get to shoot at T-Rexes with nukes.
    '';
    homepage = "https://github.com/jorio/Nanosaur";
    license = licenses.cc-by-sa-40;
    mainProgram = "Nanosaur";
    maintainers = with maintainers; [ lux ];
    platforms = platforms.linux;
  };
}

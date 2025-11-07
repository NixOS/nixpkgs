{
  lib,
  stdenv,
  fetchFromGitHub,
  sdl3,
  libGL,
  cmake,
  makeWrapper,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "OttoMatic";
  version = "4.0.1-unstable-2025-09-28";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = "OttoMatic";
    rev = "636056a92c1f276a5af5c3dc7df5c3cb952fd47a";
    hash = "sha256-nSLa/g1irZY9uU7lZkeT9C0iNPgBuD5wm1AxIrIzG54=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    sdl3
    libGL
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mkdir -p "$out/share/OttoMatic"
    mv Data ReadMe.txt "$out/share/OttoMatic/"
    install -Dm755 {.,$out/bin}/OttoMatic
    wrapProgram $out/bin/OttoMatic --chdir "$out/share/OttoMatic"
    install -Dm644 $src/packaging/io.jor.ottomatic.desktop $out/share/applications/io.jor.ottomatic.desktop
    install -Dm644 $src/packaging/io.jor.ottomatic.png $out/share/pixmaps/io.jor.ottomatic.png

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Port of Otto Matic, a 2001 Macintosh game by Pangea Software, for modern operating systems";
    homepage = "https://github.com/jorio/OttoMatic";
    license = lib.licenses.cc-by-sa-40;
    maintainers = with lib.maintainers; [ lux ];
    platforms = lib.platforms.linux;
    mainProgram = "OttoMatic";
  };
}

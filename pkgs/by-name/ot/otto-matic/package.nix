{ lib, stdenv, fetchFromGitHub, SDL2, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "OttoMatic";
  version = "unstable-2023-11-13";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = pname;
    rev = "8a5411779762684066d3748fbf4d33747ca871a4";
    hash = "sha256-cZ2gHNXmjMocfTgbA+0T2nwKs55ZMDoB+JTf0Qdqe8U=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    SDL2
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

  meta = with lib; {
    description = "Port of Otto Matic, a 2001 Macintosh game by Pangea Software, for modern operating systems";
    homepage = "https://github.com/jorio/OttoMatic";
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ lux ];
    platforms = platforms.linux;
    mainProgram = "OttoMatic";
  };
}

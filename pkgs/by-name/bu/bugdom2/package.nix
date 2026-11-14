{ lib, stdenv, fetchFromGitHub, SDL2, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "bugdom2";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+Snw5B5DPhzLPxKu9cThO/CNwoffNkSCLat1h1xRdAM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    SDL2
  ];

  buildInputs = [
    SDL2
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    mkdir -p "$out/share/Bugdom2"
    mv Data "$out/share/Bugdom2/"
    install -Dm644 ReadMe.txt "$out/share/doc/bugdom2-${version}/ReadMe.txt"
    install -Dm755 {.,$out/bin}/Bugdom2
    wrapProgram $out/bin/Bugdom2 --chdir "$out/share/Bugdom2"
    install -Dm644 $src/packaging/io.jor.bugdom2.desktop $out/share/applications/io.jor.bugdom2.desktop
    install -Dm644 $src/packaging/io.jor.bugdom2.png $out/share/pixmaps/io.jor.bugdom2.png
    runHook postInstall
  '';

  meta = with lib; {
    description = "A port of Pangea Softwares 2002 game Bugdom 2 to modern operating systems";
    homepage = "https://github.com/jorio/Bugdom2";
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ lux ];
    platforms = platforms.linux;
    mainProgram = "Bugdom2";
  };
}

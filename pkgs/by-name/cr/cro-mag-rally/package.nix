{ lib
, stdenv
, fetchFromGitHub
, SDL2
, cmake
, makeWrapper
}:

stdenv.mkDerivation {
  pname = "CroMagRally";
  version = "3.0.0-unstable-2023-05-21";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = "CroMagRally";
    rev = "5983de40c180b50bbbec8b04f5f5f1ceccd1901b";
    hash = "sha256-QbUkrNY7DZQts8xaimE83yXpCweKvnn0uDb1CawLfEE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
  buildInputs = [
    SDL2
  ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/CroMagRally"
    mv Data ReadMe.txt "$out/share/CroMagRally/"
    install -Dm755 {.,$out/bin}/CroMagRally
    wrapProgram $out/bin/CroMagRally --chdir "$out/share/CroMagRally"
    install -Dm644 $src/packaging/cromagrally.desktop $out/share/applications/cromagrally.desktop
    install -Dm644 $src/packaging/cromagrally-desktopicon.png $out/share/pixmaps/cromagrally-desktopicon.png
    runHook postInstall
  '';

  meta = with lib; {
    description = "Port of Cro-Mag Rally, a 2000 Macintosh game by Pangea Software, for modern operating systems";
    homepage = "https://github.com/jorio/CroMagRally";
    changelog = "https://github.com/jorio/CroMagRally/releases";
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ lux ];
    platforms = platforms.linux;
    mainProgram = "CroMagRally";
  };
}

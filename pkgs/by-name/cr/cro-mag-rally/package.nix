{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  libGL,
  cmake,
  makeBinaryWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "CroMagRally";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = "CroMagRally";
    tag = finalAttrs.version;
    hash = "sha256-6KmvILl5tZYxbDYg58LVstmtqoCogc6TV11oagKvqcg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
  ];

  buildInputs = [
    SDL2
    libGL
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/CroMagRally
    mv Data ReadMe.txt $out/share/CroMagRally/
    install -Dm755 CroMagRally $out/bin/CroMagRally
    wrapProgram $out/bin/CroMagRally --chdir $out/share/CroMagRally
    install -Dm644 ${finalAttrs.src}/packaging/io.jor.cromagrally.desktop $out/share/applications/cromagrally.desktop
    install -Dm644 ${finalAttrs.src}/packaging/io.jor.cromagrally.png $out/share/pixmaps/io.jor.cromagrally.png

    runHook postInstall
  '';

  meta = {
    description = "Port of Cro-Mag Rally, a 2000 Macintosh game by Pangea Software, for modern operating systems";
    homepage = "https://github.com/jorio/CroMagRally";
    changelog = "https://github.com/jorio/CroMagRally/releases";
    license = lib.licenses.cc-by-sa-40;
    maintainers = with lib.maintainers; [ lux ];
    platforms = lib.platforms.linux;
    mainProgram = "CroMagRally";
  };
})

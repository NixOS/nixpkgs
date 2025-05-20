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

stdenv.mkDerivation rec {
  pname = "OttoMatic";
  version = "4.0.1-unstable-2025-04-27";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = "OttoMatic";
    rev = "69f0111d1768abe56498bf8121f0f9cbc85aedd3";
    hash = "sha256-7RpEVL3tNhEhkZYVjgsI6S+CQfyiz/ukroldrtohA4k=";
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

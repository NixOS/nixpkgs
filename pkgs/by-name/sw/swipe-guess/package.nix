{
  lib,
  stdenv,
  fetchFromSourcehut,
}:

stdenv.mkDerivation rec {
  pname = "swipe-guess";
  version = "0.2.1";

  src = fetchFromSourcehut {
    owner = "~earboxer";
    repo = "swipeGuess";
    rev = "v${version}";
    hash = "sha256-8bPsnqjLeeZ7btTre9j1T93VWY9+FdBdJdxyvBVt34s=";
  };

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    ${lib.getExe stdenv.cc} swipeGuess.c -o swipeGuess

    runHook postBuild
  '';

  postInstall = ''
    install -Dm555 swipeGuess -t $out/bin
  '';

  meta = {
    description = "Completion plugin for touchscreen-keyboards on mobile devices";
    homepage = "https://git.sr.ht/~earboxer/swipeGuess/";
    license = lib.licenses.agpl3Only;
    mainProgram = "swipeGuess";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
}

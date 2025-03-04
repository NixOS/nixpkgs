{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  ncurses,
  pkg-config,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "robotfindskitten";
  version = "2.8284271.702";

  src = fetchFromGitHub {
    owner = "robotfindskitten";
    repo = "robotfindskitten";
    rev = finalAttrs.version;
    hash = "sha256-z6//Yfp3BtJAtUdY05m1eKVrTdH19MvK7LZOwX5S1CM=";
  };

  outputs = [
    "out"
    "man"
    "info"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    texinfo
  ];

  buildInputs = [
    ncurses
  ];

  makeFlags = [
    "execgamesdir=$(out)/bin"
  ];

  postInstall = ''
    install -Dm644 nki/vanilla.nki -t $out/share/games/robotfindskitten/
  '';

  meta = {
    description = "Yet another zen simulation; A simple find-the-kitten game";
    homepage = "http://robotfindskitten.org/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "robotfindskitten";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})

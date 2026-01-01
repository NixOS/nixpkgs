{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  readline,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "bitwise";
  version = "0.50";

  src = fetchFromGitHub {
    owner = "mellowcandle";
    repo = "bitwise";
    rev = "v${version}";
    sha256 = "sha256-x+ky1X0c0bQZnkNvNNuXN2BoMDtDSCt/8dBAG92jCCQ=";
  };

  buildInputs = [
    ncurses
    readline
  ];
  nativeBuildInputs = [ autoreconfHook ];

<<<<<<< HEAD
  meta = {
    description = "Terminal based bitwise calculator in curses";
    homepage = "https://github.com/mellowcandle/bitwise";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.whonore ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Terminal based bitwise calculator in curses";
    homepage = "https://github.com/mellowcandle/bitwise";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.whonore ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "bitwise";
  };
}

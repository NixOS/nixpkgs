{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  readline,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bitwise";
  version = "0.50";

  src = fetchFromGitHub {
    owner = "mellowcandle";
    repo = "bitwise";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-x+ky1X0c0bQZnkNvNNuXN2BoMDtDSCt/8dBAG92jCCQ=";
  };

  buildInputs = [
    ncurses
    readline
  ];
  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Terminal based bitwise calculator in curses";
    homepage = "https://github.com/mellowcandle/bitwise";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.whonore ];
    platforms = lib.platforms.unix;
    mainProgram = "bitwise";
  };
})

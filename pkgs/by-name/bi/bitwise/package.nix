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
  version = "0.60";

  src = fetchFromGitHub {
    owner = "mellowcandle";
    repo = "bitwise";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-wVd45OLBfQr13SYEKVSHu0VRJCCFxH2sXCeAs2DEUMM=";
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

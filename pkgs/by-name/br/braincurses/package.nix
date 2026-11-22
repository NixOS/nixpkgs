{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "braincurses";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bderrly";
    repo = "braincurses";
    tag = finalAttrs.version;
    sha256 = "0gpny9wrb0zj3lr7iarlgn9j4367awj09v3hhxz9r9a6yhk4anf5";
  };

  buildInputs = [ ncurses ];

  # There is no install target in the Makefile
  installPhase = ''
    install -Dt $out/bin braincurses
  '';

  meta = {
    homepage = "https://github.com/bderrly/braincurses";
    description = "Version of the classic game Mastermind";
    mainProgram = "braincurses";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
})

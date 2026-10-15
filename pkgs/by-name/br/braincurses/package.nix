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
    hash = "sha256-xVlFJvRGpZx+h3DsBCRXxwwik300q3gyHfKDlXny9j4=";
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

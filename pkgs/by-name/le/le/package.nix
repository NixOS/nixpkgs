{
  lib,
  stdenv,
  nix-update-script,
  fetchFromGitHub,
  automake,
  autoconf,
  gnulib,
  gettext,
  ncurses,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "le";
  version = "1.16.8";

  src = fetchFromGitHub {
    owner = "lavv17";
    repo = "le";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-1V/IuvrqaqX4weRJnkY0JTMEhnB6hZCWuXtxlMl/6LU=";
  };

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    automake
    autoconf
    gnulib
    gettext
    perl
  ];
  buildInputs = [ ncurses ];

  configurePhase = ''
    runHook preConfigure

    ./autogen.sh \
        --with-curses-include=${ncurses.dev}/include \
        --with-curses-lib=${ncurses}/lib \
        --prefix=$out

    runHook postConfigure
  '';

  meta = {
    description = "LE – full screen text editor inspired by Norton Editor";
    homepage = "https://github.com/lavv17/le";
    longDescription = ''
      LE is a text editor which offers wide range of capabilities with a
      simple interface. It has a pull down menu and a simple help system to
      get started.

      Among its features there are: various operations with stream and
      rectangular blocks, search and replace with full regular expressions,
      text formatting, undelete/uninsert, hex editing, tunable key sequences,
      tunable colors, tunable syntax highlighting.
    '';
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    mainProgram = "le";
  };
})

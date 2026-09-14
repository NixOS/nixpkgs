{
  lib,
  stdenv,
  fetchFromGitLab,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hexer";
  version = "1.0.7";

  strictDeps = true;

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "hexer";
    repo = "hexer";
    tag = "release/${finalAttrs.version}";
    hash = "sha256-xDgqz2n9urquJHq4N6prh0DYDb3BvH/ijPLgPMbrSLU=";
  };

  buildInputs = [
    ncurses
  ];

  postPatch = ''
    substituteInPlace Makefile --replace-fail "-lcurses" "-lncurses"
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "DESTDIR="
  ];

  meta = {
    description = "Multi-buffer editor for binary files with a Vi-like interface";
    longDescription = ''
      Hexer is a multi-buffer editor for binary files for Unix-like systems
      that displays its buffer(s) as a hex dump.  The user interface is kept
      similar to vi/ex.
    '';
    homepage = "https://devel.ringlet.net/editors/hexer/";
    license = [
      lib.licenses.bsd2
      lib.licenses.bsd3
    ];
    mainProgram = "hexer";
    maintainers = with lib.maintainers; [ tbutter ];
    platforms = lib.platforms.linux;
  };
})

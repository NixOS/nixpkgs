{
  lib,
  stdenv,
  autoreconfHook,
  fetchcvs,
  ncurses,
  texinfo,
  versionCheckHook,
}:

stdenv.mkDerivation {
  pname = "astwar";
  version = "0.4.5";

  src = fetchcvs {
    cvsRoot = ":pserver:anonymous@cvs.savannah.nongnu.org:/sources/astwar";
    module = "astwar";
    date = "2002-07-21";
    hash = "sha256-/9logwWAOtXfUQpcWw6zSsWQ3q983+E+K33+yHulCA0=";
  };

  NIX_CFLAGS_COMPILE = [
    "-include"
    "stdlib.h"
    "-include"
    "string.h"
    "-DHAVE_VPRINTF=1"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    texinfo
  ];

  buildInputs = [ ncurses ];

  postInstall = ''
    install -Dm644 AUTHORS ChangeLog NEWS README astwar.pdf -t "$out/share/doc/astwar"
    install -Dm644 COPYING -t "$out/share/licenses/astwar"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = {
    description = "2D Space Shooter";
    homepage = "https://savannah.nongnu.org/projects/astwar";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ Zaczero ];
    mainProgram = "astwar";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  ncurses,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "cmatrix";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "abishekvashok";
    repo = "cmatrix";
    tag = "v${version}";
    sha256 = "1h9jz4m4s5l8c3figaq46ja0km1gimrkfxm4dg7mf4s84icmasbm";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ncurses ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-V";
  doInstallCheck = true;

  meta = {
    description = "Simulates the falling characters theme from The Matrix movie";
    longDescription = ''
      CMatrix simulates the display from "The Matrix" and is based
      on the screensaver from the movie's website.
    '';
    homepage = "https://github.com/abishekvashok/cmatrix";
    platforms = ncurses.meta.platforms;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Tert0 ];
    mainProgram = "cmatrix";
  };
}

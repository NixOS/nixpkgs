{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  ncurses,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cmatrix";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "abishekvashok";
    repo = "cmatrix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dWlVWSRIE1fPa6R2N3ONL9QJlDQEqxfdYIgWTSr5MsE=";
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
    changelog = "https://github.com/abishekvashok/cmatrix/releases/tag/v${finalAttrs.version}";
    platforms = ncurses.meta.platforms;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Tert0 ];
    mainProgram = "cmatrix";
  };
})

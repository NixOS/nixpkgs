{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  ncurses,
  pkg-config,
  texinfo,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "robotfindskitten";
  version = "3.0000000.726";

  src = fetchFromGitHub {
    owner = "robotfindskitten";
    repo = "robotfindskitten";
    tag = finalAttrs.version;
    hash = "sha256-N5mdO9RNVI+d7OCZzzGcPLVpWVqL43R8g82Hu9QnApU=";
  };

  outputs = [
    "out"
    "man"
    "info"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    texinfo
  ];

  buildInputs = [
    ncurses
  ];

  makeFlags = [
    "execgamesdir=$(out)/bin"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "-V";

  meta = {
    description = "Yet another zen simulation; A simple find-the-kitten game";
    homepage = "http://robotfindskitten.org/";
    changelog = "https://github.com/robotfindskitten/robotfindskitten/blob/${finalAttrs.version}/NEWS";
    license = lib.licenses.gpl2Plus;
    mainProgram = "robotfindskitten";
    maintainers = with lib.maintainers; [ kamadorueda ];
    platforms = lib.platforms.unix;
  };
})

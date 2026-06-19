{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "par2cmdline";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Parchive";
    repo = "par2cmdline";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-KUOlklxwJkCZKO7T5gsN73Hwltojx1WOTeyx1C6tink=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    homepage = "https://github.com/Parchive/par2cmdline";
    description = "PAR 2.0 compatible file verification and repair tool";
    longDescription = ''
      par2cmdline is a program for creating and using PAR2 files to detect
      damage in data files and repair them if necessary. It can be used with
      any kind of file.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})

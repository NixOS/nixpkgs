{
  lib,
  stdenv,
  openssl,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "readpe";
  version = "0.85.1";

  src = fetchFromGitHub {
    owner = "mentebinaria";
    repo = "readpe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e9omL/HSlzBkJSUnjw271hmXGhasZlWw9X8P8ohoRi0=";
  };

  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  makeFlags = [ "prefix=$(out)" ];

  installFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Full-featured, open source, multiplatform command line toolkit to work with PE (Portable Executables) binaries";
    homepage = "https://pev.sourceforge.io/";
    license = lib.licenses.gpl2;
    mainProgram = "readpe";
    maintainers = with lib.maintainers; [ jeschli ];
    platforms = lib.platforms.linux;
  };
})

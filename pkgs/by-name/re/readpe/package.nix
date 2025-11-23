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
    tag = finalAttrs.version;
    hash = "sha256-e9omL/HSlzBkJSUnjw271hmXGhasZlWw9X8P8ohoRi0=";
  };

  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  makeFlags = [ "prefix=$(out)" ];

  installFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "Full-featured, open source, multiplatform command line toolkit to work with PE (Portable Executables) binaries";
    homepage = "https://pev.sourceforge.net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jeschli ];
    platforms = platforms.linux;
  };
})

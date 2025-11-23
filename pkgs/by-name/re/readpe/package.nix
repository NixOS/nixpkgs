{
  lib,
  stdenv,
  openssl,
  fetchFromGitHub,
}:
let
  version = "0.85.1";
in
stdenv.mkDerivation {
  pname = "readpe";
  inherit version;

  src = fetchFromGitHub {
    owner = "mentebinaria";
    repo = "readpe";
    rev = version;
    hash = "sha256-e9omL/HSlzBkJSUnjw271hmXGhasZlWw9X8P8ohoRi0=";
    fetchSubmodules = true;
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
}

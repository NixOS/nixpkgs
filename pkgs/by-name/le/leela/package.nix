{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  poppler,
}:

stdenv.mkDerivation {
  pname = "leela";
  version = "12.fe7a35a";

  src = fetchFromGitHub {
    owner = "TrilbyWhite";
    repo = "Leela";
    rev = "576a60185b191d3a3030fef10492fe32d2125563";
    sha256 = "1k6n758r9dhjmc1pnpk6qzpg0q7pkq2hf18z3b0s2z198jpkg9s3";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ poppler ];

  installFlags = [
    "PREFIX=$(out)"
    "MANDIR=$(out)/share/man"
  ];

  meta = {
    description = "CLI frontend to the poppler-glib library of PDF tools";
    homepage = "https://github.com/TrilbyWhite/Leela";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.puffnfresh ];
    platforms = lib.platforms.linux;
    mainProgram = "leela";
  };
}

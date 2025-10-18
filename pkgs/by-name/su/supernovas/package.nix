{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
}:
stdenv.mkDerivation rec {
  pname = "supernovas";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "smithsonian";
    repo = "supernovas";
    tag = "v${version}";
    hash = "sha256-NkTcqsys+sZXXkkW8m0mT15uvSNfjkDWWsnxySermdY=";
  };

  buildInputs = [ which ];

  installFlags = [ "prefix=$(out)" ];

  meta = {
    description = "High-performance astrometry library for C/C++";
    homepage = "https://smithsonian.github.io/SuperNOVAS/";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ kiranshila ];
    platforms = lib.platforms.all;
  };
}

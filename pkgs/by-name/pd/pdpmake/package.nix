{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "pdpmake";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "rmyorston";
    repo = "pdpmake";
    rev = version;
    hash = "sha256-N9MT+3nE8To0ktNTPT9tDHkKRrn4XsTYiTeYdBk9VtI=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;
  checkTarget = "test";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/rmyorston/pdpmake";
    description = "Public domain POSIX make";
    license = licenses.unlicense;
    maintainers = with maintainers; [ eownerdead ];
    mainProgram = "pdpmake";
    platforms = platforms.all;
    badPlatforms = platforms.darwin; # Requires `uimensat`
  };
}

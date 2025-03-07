{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "pdpmake";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "rmyorston";
    repo = "pdpmake";
    rev = version;
    hash = "sha256-drHo8IUC3xQ/O6T4xCMQSK9m+O/6hTOJSw0OMl1W9WA=";
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

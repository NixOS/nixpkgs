{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "pdpmake";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "rmyorston";
    repo = "pdpmake";
    rev = version;
    hash = "sha256-E9AcWwMfPp2sn4k/gv2gjBuqQ6k8J0TSfncMKuXh/Cc=";
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

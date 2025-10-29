{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  boehmgc,
}:

stdenv.mkDerivation rec {
  version = "1.03";
  pname = "libhomfly";

  src = fetchFromGitHub {
    owner = "miguelmarco";
    repo = "libhomfly";
    rev = version;
    hash = "sha256-lav/c5i4TXiQSp4r376sy7s+xLO85GutTb/UZJ70gh8=";
  };

  buildInputs = [
    boehmgc
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/miguelmarco/libhomfly/";
    description = "Library to compute the homfly polynomial of knots and links";
    license = licenses.unlicense;
    teams = [ teams.sage ];
    platforms = platforms.all;
  };
}

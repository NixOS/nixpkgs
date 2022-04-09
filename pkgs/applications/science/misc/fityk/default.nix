{ lib, stdenv, fetchFromGitHub, autoreconfHook, wxGTK30, boost, lua, zlib, bzip2
, xylib, readline, gnuplot, swig3 }:

stdenv.mkDerivation rec {
  pname = "fityk";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "wojdyr";
    repo = "fityk";
    rev = "v${version}";
    sha256 = "0kmrjjjwrh6xgw590awcd52b86kksmv6rfgih75zvpiavr1ygwsi";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ wxGTK30 boost lua zlib bzip2 xylib readline
    gnuplot swig3 ];

  meta = {
    description = "Curve fitting and peak fitting software";
    license = lib.licenses.gpl2;
    homepage = "https://fityk.nieto.pl/";
    platforms = lib.platforms.linux;
  };
}

{ lib, stdenv, fetchFromGitHub, autoreconfHook, wxGTK30, boost, lua, zlib, bzip2
, xylib, readline, gnuplot, swig3 }:

stdenv.mkDerivation rec {
  pname = "fityk";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "wojdyr";
    repo = "fityk";
    rev = "v${version}";
    sha256 = "sha256-m2RaZMYT6JGwa3sOUVsBIzCdZetTbiygaInQWoJ4m1o=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ wxGTK30 boost lua zlib bzip2 xylib readline
    gnuplot swig3 ];

  NIX_CFLAGS_COMPILE = [
    "-std=c++11"
  ];

  meta = {
    description = "Curve fitting and peak fitting software";
    license = lib.licenses.gpl2;
    homepage = "https://fityk.nieto.pl/";
    platforms = lib.platforms.linux;
  };
}

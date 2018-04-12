{ stdenv, fetchFromGitHub, autoreconfHook, wxGTK_2, boost, lua, zlib, bzip2
, xylib, readline, gnuplot, swig3 }:

stdenv.mkDerivation rec {
  name = "fityk-${version}";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "wojdyr";
    repo = "fityk";
    rev = "v${version}";
    sha256 = "0kmrjjjwrh6xgw590awcd52b86kksmv6rfgih75zvpiavr1ygwsi";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ wxGTK_2 boost lua zlib bzip2 xylib readline
    gnuplot swig3 ];

  meta = with stdenv.lib; {
    description = "Curve fitting and peak fitting software";
    license = licenses.gpl2;
    homepage = http://fityk.nieto.pl/;
    platforms = platforms.linux;
  };
}

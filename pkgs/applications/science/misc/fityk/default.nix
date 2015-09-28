{ stdenv, fetchFromGitHub, autoreconfHook, wxGTK30, boost, lua, zlib, bzip2
, xylib, readline, gnuplot, swig3 }:

let
  name    = "fityk";
  version = "1.3.0";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchFromGitHub {
    owner = "wojdyr";
    repo = "fityk";
    rev = "v${version}";
    sha256 = "07xzhy47q5ddg1qn51qds4wp6r5g2cx8bla0hm0a9ipr2hg92lm9";
  };

  buildInputs = [ autoreconfHook wxGTK30 boost lua zlib bzip2 xylib readline
    gnuplot swig3 ];

  meta = {
    description = "Curve fitting and peak fitting software";
    license = stdenv.lib.licenses.gpl2;
    homepage = http://fityk.nieto.pl/;
    platforms = stdenv.lib.platforms.linux;
  };
}

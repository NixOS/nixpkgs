{ stdenv, fetchurl, wxGTK30, boost, lua, zlib, bzip2, xylib, readline, gnuplot }:

let
  name    = "fityk";
  version = "1.2.9";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "https://github.com/wojdyr/fityk/releases/download/v${version}/${name}-${version}.tar.bz2";
    sha256 = "1gl938nd2jyya8b3gzbagm1jab2mkc9zvr6zsg5d0vkfdqlk0pv1";
  };

  buildInputs = [wxGTK30 boost lua zlib bzip2 xylib readline gnuplot ];

  meta = {
    description = "Fityk -- curve fitting and peak fitting software";
    license = "GPL2";
    homepage = http://fityk.nieto.pl/;
    platforms = stdenv.lib.platforms.linux;
  };
}

{stdenv, fetchurl, qt, libXext, libX11}:

stdenv.mkDerivation rec {
  name = "qgit-1.5.8";
  meta =
  {
    license = "GPLv2";
    homepage = http://git.or.cz;
    description = "Graphical front-end to Git";
  };
  src = fetchurl
  {
    url = "http://todo/${name}.tar.bz2";
    sha256 = "0qmgd1cjny5aciljpvn2bczgdvlpgd2f7wzafda24zj4mzqnppsq";
  };
  buildInputs = [qt libXext libX11];
}

{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "links-1.00pre15";
  src = fetchurl {
    url = http://artax.karlin.mff.cuni.cz/~mikulas/links/download/links-1.00pre15.tar.gz;
    md5 = "f64823b9a1ac2d79df578a991dfae8b8";
  };
}

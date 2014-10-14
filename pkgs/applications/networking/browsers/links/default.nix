{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "links-1.00pre15";
  src = fetchurl {
    url = http://artax.karlin.mff.cuni.cz/~mikulas/links/download/links-1.00pre15.tar.gz;
    sha256 = "0yzgzc6jm9vhv7rgbj5s9zwxn9fnf4nyap9l6dzgpwsn7m18vprv";
  };
}

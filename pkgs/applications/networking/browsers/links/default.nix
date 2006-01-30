{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "links-1.00pre15";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/links-1.00pre15.tar.gz;
    md5 = "f64823b9a1ac2d79df578a991dfae8b8";
  };
}

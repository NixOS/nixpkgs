{stdenv, fetchurl, wxGTK, chmlib}:

stdenv.mkDerivation {
  name = "xchm-0.9.1";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/xchm-0.9.1.tar.gz;
    md5 = "5ba671e09e4c3ac46ffb5ce9d2c985eb";
  };
  buildInputs = [wxGTK chmlib];
}

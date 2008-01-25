{stdenv, fetchurl, boost, zlib}:

stdenv.mkDerivation {
  name = "monotone-0.38";
  src = fetchurl {
    url = http://monotone.ca/downloads/0.38/monotone-0.38.tar.gz;
    md5 = "c1a0d2619f451a664289b042c104860d";
  };
  buildInputs = [boost zlib];
}

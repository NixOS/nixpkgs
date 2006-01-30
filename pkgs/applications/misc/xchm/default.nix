{stdenv, fetchurl, wxGTK, chmlib}:

stdenv.mkDerivation {
  name = "xchm-1.2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/xchm-1.2.tar.gz;
    md5 = "17f2cda873f61470636dbfeebb4a531d";
  };
  buildInputs = [wxGTK chmlib];
}

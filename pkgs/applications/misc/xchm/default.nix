{stdenv, fetchurl, wxGTK, chmlib}:

stdenv.mkDerivation {
  name = "xchm-1.2";
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/xchm/xchm-1.2.tar.gz;
    md5 = "17f2cda873f61470636dbfeebb4a531d";
  };
  buildInputs = [wxGTK chmlib];
}

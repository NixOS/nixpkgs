{stdenv, fetchurl, wxGTK, chmlib}:

stdenv.mkDerivation {
  name = "xchm-1.9";
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/xchm/xchm-1.9.tar.gz;
    md5 = "12e1faf49447c743c5c936636cd8a172";
  };
  buildInputs = [wxGTK chmlib];
}

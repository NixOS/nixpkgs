{stdenv, fetchurl, wxGTK, chmlib}:

stdenv.mkDerivation {
  name = "xchm-1.9";
  src = fetchurl {
    url = mirror://sourceforge/xchm/xchm-1.14.tar.gz;
    sha256 = "0gx8h8iabfrawx86f3im36favwl18afwx6z7w9gkjamihcm1an1w";
  };
  buildInputs = [wxGTK chmlib];

  meta = {
    description = "A viewer for Microsoft HTML Help files";
    homepage = http://xchm.sourceforge.net;
  };
}

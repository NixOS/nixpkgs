{stdenv, fetchurl, wxGTK, chmlib}:

stdenv.mkDerivation {
  name = "xchm-1.17";
  src = fetchurl {
    url = mirror://sourceforge/xchm/xchm-1.17.tar.gz;
    sha256 = "0yizisn4833nnpd4apallyg8iv334y00hv3awbsbc0ks2zf93x0n";
  };
  buildInputs = [wxGTK chmlib];

  postConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS $(${wxGTK}/lib/wx/config/* --libs | sed -e s@-pthread@@)"
    echo $NIX_LDFLAGS
  '';

  meta = {
    description = "A viewer for Microsoft HTML Help files";
    homepage = http://xchm.sourceforge.net;
  };
}
